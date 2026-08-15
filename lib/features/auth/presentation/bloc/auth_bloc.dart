import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/chat/data/sync/offline_sync_service.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/connectivity_monitor.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/sync/delta_sync_service.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_mattermost/core/sync/websocket_db_sync_service.dart';
import 'package:flutter_mattermost/core/sync/outbox_retry_service.dart';
import 'package:flutter_mattermost/core/notifications/local_notification_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthStatusEvent extends AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmittedEvent({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LogoutRequestedEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthenticatedState extends AuthState {
  final UserEntity user;
  const AuthenticatedState(this.user);
  @override
  List<Object?> get props => [user];
}

class UnauthenticatedState extends AuthState {}

class AuthFailureState extends AuthState {
  final String message;
  const AuthFailureState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class AuthBloc extends Bloc<AuthEvent, AuthState> with WidgetsBindingObserver {
  final AuthRepository _authRepository;
  final WebSocketClientManager _webSocketClientManager;
  final WebsocketDbSyncService _websocketDbSyncService;
  final OutboxRetryService _outboxRetryService;
  final LocalNotificationService _notificationService;
  final OfflineSyncService _offlineSyncService;
  final ConnectivityMonitor _connectivityMonitor;
  final DeltaSyncService _deltaSyncService;

  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<TypedWebSocketEvent>? _wsEventSubscription;

  AuthBloc(
    this._authRepository,
    this._webSocketClientManager,
    this._websocketDbSyncService,
    this._outboxRetryService,
    this._notificationService,
    this._offlineSyncService,
    this._connectivityMonitor,
    this._deltaSyncService,
  ) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LogoutRequestedEvent>(_onLogoutRequested);

    WidgetsBinding.instance.addObserver(this);

    // Initial notification setup
    _notificationService.initialize();

    // عودة الاتصال بالشبكة → إعادة ربط الـ WebSocket ومزامنة العمليات
    // المعلقة ثم مزامنة تزايدية (الأحداث المفقودة تُستعاد أو تُكتمل).
    _connectivitySubscription =
        _connectivityMonitor.connectionChangeStream.listen(
      (hasConnection) {
        if (!hasConnection) return;
        _webSocketClientManager.connect();
        _offlineSyncService.syncPendingActions();
        _outboxRetryService.processOutbox();
        _deltaSyncService.fullSync();
      },
    );

    // فشل مصادقة الـ WebSocket (توكن منتهي/ملغى) → تسجيل الخروج.
    _wsEventSubscription = _webSocketClientManager.eventStream.listen((event) {
      if (event is WebSocketAuthFailedEvent) {
        add(LogoutRequestedEvent());
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    // عودة التطبيق للواجهة → إعادة ربط ومزامنة بعد فترة خلفية طويلة.
    _webSocketClientManager.connect();
    _offlineSyncService.syncPendingActions();
    _outboxRetryService.processOutbox();
    _deltaSyncService.fullSync();
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoadingState());
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      _websocketDbSyncService.start();
      _outboxRetryService.start();
      _notificationService.startListening();
      _deltaSyncService.start();
      _deltaSyncService.fullSync();
      _webSocketClientManager.connect();
      emit(AuthenticatedState(user));
    } else {
      emit(UnauthenticatedState());
    }
    } catch (e) {
      debugPrint('[auth] check auth status failed: $e');
      emit(AuthFailureState('Failed to check authentication status: $e'));
    }
  }

  Future<void> _onLoginSubmitted(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final user = await _authRepository.login(event.username, event.password);
      // خطوات ما بعد الدخول (realtime/websocket/مزامنة) ثانوية:
      // فشلها لا يمنع اعتماد الجلسة والانتقال للصفحة الرئيسية.
      try {
        _websocketDbSyncService.start();
        _outboxRetryService.start();
        _notificationService.startListening();
        _deltaSyncService.start();
        _webSocketClientManager.connect();
        await _offlineSyncService.syncPendingActions();
        await _outboxRetryService.processOutbox();
        await _deltaSyncService.fullSync();
      } catch (e) {
        debugPrint('[auth] post-login sync failed: $e');
      }
      emit(AuthenticatedState(user));
    } catch (e) {
      debugPrint('[auth] login failed: $e');
      emit(AuthFailureState('Failed to login: $e.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    _websocketDbSyncService.stop();
    _outboxRetryService.stop();
    _notificationService.stopListening();
    _deltaSyncService.stop();
    _webSocketClientManager.disconnect();
    emit(UnauthenticatedState());
  }

  @override
  Future<void> close() async {
    WidgetsBinding.instance.removeObserver(this);
    await _connectivitySubscription?.cancel();
    await _wsEventSubscription?.cancel();
    await super.close();
  }
}
