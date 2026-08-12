import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/threads_repository.dart';

/// أحداث صفحة المحادثات (Global Threads).
abstract class ThreadsEvent extends Equatable {
  const ThreadsEvent();
  @override
  List<Object?> get props => [];
}

class LoadThreadsEvent extends ThreadsEvent {
  final String userId;
  final String teamId;
  final bool unreadOnly;
  const LoadThreadsEvent({
    required this.userId,
    required this.teamId,
    this.unreadOnly = false,
  });
  @override
  List<Object?> get props => [userId, teamId, unreadOnly];
}

class SetThreadsUnreadFilterEvent extends ThreadsEvent {
  final bool unreadOnly;
  const SetThreadsUnreadFilterEvent(this.unreadOnly);
  @override
  List<Object?> get props => [unreadOnly];
}

class MarkThreadReadEvent extends ThreadsEvent {
  final String userId;
  final String teamId;
  final String threadId;
  const MarkThreadReadEvent({
    required this.userId,
    required this.teamId,
    required this.threadId,
  });
  @override
  List<Object?> get props => [userId, teamId, threadId];
}

/// حالات صفحة المحادثات.
abstract class ThreadsState extends Equatable {
  const ThreadsState();
  @override
  List<Object?> get props => [];
}

class ThreadsLoadingState extends ThreadsState {}

class ThreadsLoadedState extends ThreadsState {
  final List<ThreadEntity> threads;
  final bool unreadOnly;

  const ThreadsLoadedState({
    required this.threads,
    this.unreadOnly = false,
  });

  @override
  List<Object?> get props => [threads, unreadOnly];
}

class ThreadsErrorState extends ThreadsState {
  final String message;
  const ThreadsErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

class ThreadsBloc extends Bloc<ThreadsEvent, ThreadsState> {
  final ThreadsRepository _threadsRepository;

  ThreadsBloc(this._threadsRepository) : super(ThreadsLoadingState()) {
    on<LoadThreadsEvent>(_onLoad);
    on<SetThreadsUnreadFilterEvent>(_onSetFilter);
    on<MarkThreadReadEvent>(_onMarkRead);
  }

  Future<void> _onLoad(
    LoadThreadsEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    emit(ThreadsLoadingState());
    try {
      final threads = await _threadsRepository.getThreadsForUser(
        event.userId,
        event.teamId,
        unread: event.unreadOnly,
      );
      emit(ThreadsLoadedState(threads: threads, unreadOnly: event.unreadOnly));
    } catch (e) {
      emit(ThreadsErrorState(e.toString()));
    }
  }

  void _onSetFilter(SetThreadsUnreadFilterEvent event, Emitter<ThreadsState> emit) {
    final current = state;
    if (current is ThreadsLoadedState) {
      emit(current.copyWith(unreadOnly: event.unreadOnly));
    }
  }

  Future<void> _onMarkRead(
    MarkThreadReadEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    try {
      await _threadsRepository.markThreadAsRead(
        event.userId,
        event.teamId,
        event.threadId,
      );
      emit(
        current.copyWith(
          threads: [
            for (final t in current.threads)
              if (t.rootPostId == event.threadId)
                ThreadEntity(
                  rootPostId: t.rootPostId,
                  channelId: t.channelId,
                  channelName: t.channelName,
                  rootPost: t.rootPost,
                  replyCount: t.replyCount,
                  lastReplyAt: t.lastReplyAt,
                  lastViewedAt: t.lastViewedAt,
                  isFollowing: t.isFollowing,
                  unreadReplies: 0,
                  unreadMentions: 0,
                )
              else
                t,
          ],
        ),
      );
    } catch (_) {
      // يحافظ على الحالة الحالية عند الفشل (webapp يظهر toast).
    }
  }
}

extension on ThreadsLoadedState {
  ThreadsLoadedState copyWith({
    List<ThreadEntity>? threads,
    bool? unreadOnly,
  }) => ThreadsLoadedState(
    threads: threads ?? this.threads,
    unreadOnly: unreadOnly ?? this.unreadOnly,
  );
}