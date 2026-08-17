import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

/// قيم الحالة المدعومة (مطابقة Mattermost v4).

// Events
abstract class UserStatusEvent extends Equatable {
  const UserStatusEvent();
  @override
  List<Object?> get props => [];
}

class LoadUserStatusesEvent extends UserStatusEvent {
  final List<String> userIds;
  const LoadUserStatusesEvent(this.userIds);
  @override
  List<Object?> get props => [userIds];
}

class LoadMyStatusEvent extends UserStatusEvent {
  final String userId;
  const LoadMyStatusEvent(this.userId);
  @override
  List<Object?> get props => [userId];
}

class SetMyUserStatusEvent extends UserStatusEvent {
  final UserStatus status;
  const SetMyUserStatusEvent(this.status);
  @override
  List<Object?> get props => [status];
}

class RealtimeUserStatusEvent extends UserStatusEvent {
  final String userId;
  final UserStatus status;
  const RealtimeUserStatusEvent(this.userId, this.status);
  @override
  List<Object?> get props => [userId, status];
}

/// حدث داخلي يُطلق من المؤقت الدوري لتحديث الحالات المخزنة.
class _PollStatusesEvent extends UserStatusEvent {
  const _PollStatusesEvent();
}

// States
abstract class UserStatusState extends Equatable {
  const UserStatusState();
  @override
  List<Object?> get props => [];
}

class UserStatusInitialState extends UserStatusState {}

class UserStatusesLoadedState extends UserStatusState {
  final Map<String, UserStatus> statuses;

  const UserStatusesLoadedState(this.statuses);

  UserStatus? statusOf(String userId) => statuses[userId];

  @override
  List<Object?> get props => [statuses];
}

@LazySingleton()
class UserStatusBloc extends Bloc<UserStatusEvent, UserStatusState> {
  final UserRepository _userRepository;
  final WebSocketClientManager _webSocketManager;

  /// معرفات المستخدمين المطلوب تتبع حالتهم — يُحدَّث من أحداث التحميل.
  final Set<String> _trackedUserIds = {};

  /// تحديث دوري للحالة كل دقيقة — نظير status polling في webapp
  /// (يعوّض الأحداث المفقودة من الـ WebSocket).
  static const Duration pollInterval = Duration(seconds: 60);
  Timer? _pollTimer;

  UserStatusBloc(this._userRepository, this._webSocketManager)
    : super(UserStatusInitialState()) {
    on<LoadUserStatusesEvent>(_onLoadStatuses);
    on<LoadMyStatusEvent>(_onLoadMyStatus);
    on<SetMyUserStatusEvent>(_onSetMyStatus);
    on<RealtimeUserStatusEvent>(_onRealtimeStatus);
    on<_PollStatusesEvent>(_onPollStatuses);

    _webSocketManager.eventStream.listen((event) {
      if (event is UserPresenceEvent) {
        add(RealtimeUserStatusEvent(event.userId, event.status));
      }
    });

    _pollTimer = Timer.periodic(pollInterval, (_) => _pollStatuses());
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }

  void _pollStatuses() {
    if (_trackedUserIds.isEmpty) return;
    add(const _PollStatusesEvent());
  }

  Future<void> _onPollStatuses(
    _PollStatusesEvent event,
    Emitter<UserStatusState> emit,
  ) async {
    final ids = _trackedUserIds.toList();
    try {
      final statuses = await _userRepository.getStatusesByIds(ids);
      final current = state is UserStatusesLoadedState
          ? (state as UserStatusesLoadedState).statuses
          : const <String, UserStatus>{};
      final merged = {...current};
      for (final s in statuses) {
        merged[s.userId] = s.status;
      }
      emit(UserStatusesLoadedState(merged));
    } catch (_) {}
  }

  Future<void> _onLoadStatuses(
    LoadUserStatusesEvent event,
    Emitter<UserStatusState> emit,
  ) async {
    _trackedUserIds.addAll(event.userIds);
    if (event.userIds.isEmpty) return;
    final current = state is UserStatusesLoadedState
        ? (state as UserStatusesLoadedState).statuses
        : const <String, UserStatus>{};
    final missing = event.userIds
        .where((id) => !current.containsKey(id))
        .toList();
    if (missing.isEmpty) return;
    try {
      final statuses = await _userRepository.getStatusesByIds(missing);
      final merged = {...current};
      for (final s in statuses) {
        merged[s.userId] = s.status;
      }
      emit(UserStatusesLoadedState(merged));
    } catch (_) {}
  }

  Future<void> _onLoadMyStatus(
    LoadMyStatusEvent event,
    Emitter<UserStatusState> emit,
  ) async {
    try {
      final statuses = await _userRepository.getStatusesByIds([event.userId]);
      if (statuses.isNotEmpty) {
        final current = state is UserStatusesLoadedState
            ? (state as UserStatusesLoadedState).statuses
            : const <String, UserStatus>{};
        emit(UserStatusesLoadedState({...current, 'me': statuses.first.status, event.userId: statuses.first.status}));
      }
    } catch (_) {}
  }

  Future<void> _onSetMyStatus(
    SetMyUserStatusEvent event,
    Emitter<UserStatusState> emit,
  ) async {
    try {
      await _userRepository.updateMyStatus(event.status);
      final current = state is UserStatusesLoadedState
          ? (state as UserStatusesLoadedState).statuses
          : const <String, UserStatus>{};
      emit(UserStatusesLoadedState({...current, 'me': event.status}));
    } catch (_) {}
  }

  void _onRealtimeStatus(
    RealtimeUserStatusEvent event,
    Emitter<UserStatusState> emit,
  ) {
    final current = state is UserStatusesLoadedState
        ? (state as UserStatusesLoadedState).statuses
        : const <String, UserStatus>{};
    emit(UserStatusesLoadedState({...current, event.userId: event.status}));
  }
}
