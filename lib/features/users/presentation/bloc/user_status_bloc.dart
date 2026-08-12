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

  UserStatusBloc(this._userRepository, this._webSocketManager)
    : super(UserStatusInitialState()) {
    on<LoadUserStatusesEvent>(_onLoadStatuses);
    on<SetMyUserStatusEvent>(_onSetMyStatus);
    on<RealtimeUserStatusEvent>(_onRealtimeStatus);

    _webSocketManager.eventStream.listen((event) {
      if (event is UserPresenceEvent) {
        add(RealtimeUserStatusEvent(event.userId, event.status));
      }
    });
  }

  Future<void> _onLoadStatuses(
    LoadUserStatusesEvent event,
    Emitter<UserStatusState> emit,
  ) async {
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
