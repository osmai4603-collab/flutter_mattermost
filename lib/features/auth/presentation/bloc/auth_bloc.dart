import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_mattermost/features/chat/data/realtime/realtime_sync_service.dart';
import 'package:flutter_mattermost/features/chat/data/sync/offline_sync_service.dart';

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
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final WebSocketClientManager _webSocketClientManager;
  final RealtimeSyncService _realtimeSyncService;
  final OfflineSyncService _offlineSyncService;

  AuthBloc(
    this._authRepository,
    this._webSocketClientManager,
    this._realtimeSyncService,
    this._offlineSyncService,
  ) : super(AuthInitialState()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginSubmittedEvent>(_onLoginSubmitted);
    on<LogoutRequestedEvent>(_onLogoutRequested);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthLoadingState());
    final user = await _authRepository.getCurrentUser();
    if (user != null) {
      _realtimeSyncService.start();
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
        _realtimeSyncService.start();
        _webSocketClientManager.connect();
        await _offlineSyncService.syncPendingActions();
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
    _realtimeSyncService.stop();
    _webSocketClientManager.disconnect();
    emit(UnauthenticatedState());
  }
}
