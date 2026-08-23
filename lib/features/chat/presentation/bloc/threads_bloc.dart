import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
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

class FollowThreadEvent extends ThreadsEvent {
  final String userId;
  final String teamId;
  final String threadId;
  const FollowThreadEvent({
    required this.userId,
    required this.teamId,
    required this.threadId,
  });
  @override
  List<Object?> get props => [userId, teamId, threadId];
}

class UnfollowThreadEvent extends ThreadsEvent {
  final String userId;
  final String teamId;
  final String threadId;
  const UnfollowThreadEvent({
    required this.userId,
    required this.teamId,
    required this.threadId,
  });
  @override
  List<Object?> get props => [userId, teamId, threadId];
}

class MarkAllThreadsReadEvent extends ThreadsEvent {
  final String userId;
  final String teamId;
  const MarkAllThreadsReadEvent({required this.userId, required this.teamId});
  @override
  List<Object?> get props => [userId, teamId];
}

class SetThreadUnreadEvent extends ThreadsEvent {
  final String userId;
  final String teamId;
  final String threadId;
  const SetThreadUnreadEvent({
    required this.userId,
    required this.teamId,
    required this.threadId,
  });
  @override
  List<Object?> get props => [userId, teamId, threadId];
}

class MoveThreadEvent extends ThreadsEvent {
  final String userId;
  final String teamId;
  final String threadId;
  final String channelId;
  final String channelName;
  const MoveThreadEvent({
    required this.userId,
    required this.teamId,
    required this.threadId,
    required this.channelId,
    required this.channelName,
  });
  @override
  List<Object?> get props => [userId, teamId, threadId, channelId, channelName];
}

/// تحديث لحظي من WebSocket عند تغيير حالة المتابعة من جهاز آخر
/// (thread_follow_changed).
class ThreadFollowChangedSocketEvent extends ThreadsEvent {
  final String teamId;
  final String threadId;
  final bool following;
  const ThreadFollowChangedSocketEvent({
    required this.teamId,
    required this.threadId,
    required this.following,
  });
  @override
  List<Object?> get props => [teamId, threadId, following];
}

/// تحديث لحظي من WebSocket عند تغيير حالة القراءة (thread_read_changed).
class ThreadReadChangedSocketEvent extends ThreadsEvent {
  final String teamId;
  final String threadId;
  final int lastViewedAt;
  final int unreadMentions;
  final int unreadReplies;
  const ThreadReadChangedSocketEvent({
    required this.teamId,
    required this.threadId,
    required this.lastViewedAt,
    required this.unreadMentions,
    required this.unreadReplies,
  });
  @override
  List<Object?> get props => [
    teamId,
    threadId,
    lastViewedAt,
    unreadMentions,
    unreadReplies,
  ];
}

/// حفظ/إزالة من المحفوظات لجذر المحادثة — مطابق flag/unflag في webapp
/// (يحفظ المنشور بكود save_reaction ويظهر في صفحة Saved Messages).
class ToggleSaveEvent extends ThreadsEvent {
  final String teamId;
  final String threadId;
  final bool isCurrentlySaved;
  const ToggleSaveEvent({
    required this.teamId,
    required this.threadId,
    required this.isCurrentlySaved,
  });
  @override
  List<Object?> get props => [teamId, threadId, isCurrentlySaved];
}

class ClearThreadsEvent extends ThreadsEvent {}

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

  const ThreadsLoadedState({required this.threads, this.unreadOnly = false});

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
    on<FollowThreadEvent>(_onFollow);
    on<UnfollowThreadEvent>(_onUnfollow);
    on<MarkAllThreadsReadEvent>(_onMarkAllRead);
    on<SetThreadUnreadEvent>(_onSetUnread);
    on<MoveThreadEvent>(_onMove);
    on<ThreadFollowChangedSocketEvent>(_onSocketFollowChanged);
    on<ThreadReadChangedSocketEvent>(_onSocketReadChanged);
    on<ToggleSaveEvent>(_onToggleSave);
    on<ClearThreadsEvent>(_onClear);
  }

  void _onClear(ClearThreadsEvent event, Emitter<ThreadsState> emit) {
    emit(const ThreadsLoadedState(threads: []));
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

  void _onSetFilter(
    SetThreadsUnreadFilterEvent event,
    Emitter<ThreadsState> emit,
  ) {
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
                  participants: t.participants,
                )
              else
                t,
          ],
        ),
      );
    } catch (e) {
      debugPrint('[ThreadsBloc] _onMarkRead error: $e');
      // يحافظ على الحالة الحالية عند الفشل (webapp يظهر toast).
    }
  }

  Future<void> _onFollow(
    FollowThreadEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    debugPrint('[ThreadsBloc] _onFollow: userId=${event.userId}, teamId=${event.teamId}, threadId=${event.threadId}');
    try {
      await _threadsRepository.followThread(
        event.userId,
        event.teamId,
        event.threadId,
      );
      debugPrint('[ThreadsBloc] _onFollow: remote call succeeded, updating UI');
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
                  isFollowing: true,
                  unreadReplies: t.unreadReplies,
                  unreadMentions: t.unreadMentions,
                  participants: t.participants,
                )
              else
                t,
          ],
        ),
      );
    } catch (e) {
      debugPrint('[ThreadsBloc] _onFollow error: $e');
    }
  }

  Future<void> _onUnfollow(
    UnfollowThreadEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    debugPrint('[ThreadsBloc] _onUnfollow: userId=${event.userId}, teamId=${event.teamId}, threadId=${event.threadId}');
    try {
      await _threadsRepository.unfollowThread(
        event.userId,
        event.teamId,
        event.threadId,
      );
      debugPrint('[ThreadsBloc] _onUnfollow: remote call succeeded, updating UI');
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
                  isFollowing: false,
                  unreadReplies: t.unreadReplies,
                  unreadMentions: t.unreadMentions,
                  participants: t.participants,
                )
              else
                t,
          ],
        ),
      );
    } catch (e) {
      debugPrint('[ThreadsBloc] _onUnfollow error: $e');
    }
  }

  Future<void> _onMarkAllRead(
    MarkAllThreadsReadEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    try {
      await _threadsRepository.markAllThreadsAsRead(event.userId, event.teamId);
      emit(
        current.copyWith(
          threads: [
            for (final t in current.threads)
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
                participants: t.participants,
              ),
          ],
        ),
      );
    } catch (e) {
      debugPrint('[ThreadsBloc] _onMarkAllRead error: $e');
    }
  }

  Future<void> _onSetUnread(
    SetThreadUnreadEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    try {
      // webapp يستخدم آخر رد في المحادثة؛ ThreadEntity لا يحمله هنا
      // لذا نستخدم جذر المحادثة كمعرّف رسالة.
      await _threadsRepository.setThreadUnread(
        event.userId,
        event.teamId,
        event.threadId,
        event.threadId,
      );
      emit(
        current.copyWith(
          threads: [
            for (final t in current.threads)
              if (t.rootPostId == event.threadId)
                t.copyWith(
                  unreadReplies: t.unreadReplies < 1 ? 1 : t.unreadReplies,
                  lastViewedAt: DateTime.now().millisecondsSinceEpoch,
                )
              else
                t,
          ],
        ),
      );
    } catch (e) {
      debugPrint('[ThreadsBloc] _onSetUnread error: $e');
    }
  }

  Future<void> _onMove(
    MoveThreadEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    try {
      await _threadsRepository.moveThread(event.threadId, event.channelId);
      emit(
        current.copyWith(
          threads: [
            for (final t in current.threads)
              if (t.rootPostId == event.threadId)
                t.copyWith(
                  channelId: event.channelId,
                  channelName: event.channelName,
                )
              else
                t,
          ],
        ),
      );
    } catch (e) {
      debugPrint('[ThreadsBloc] _onMove error: $e');
    }
  }

  /// thread_follow_changed من WebSocket — تحديث القائمة محلياً
  /// دون إعادة تحميل كاملة من الخادم.
  void _onSocketFollowChanged(
    ThreadFollowChangedSocketEvent event,
    Emitter<ThreadsState> emit,
  ) {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    emit(
      current.copyWith(
        threads: [
          for (final t in current.threads)
            if (t.rootPostId == event.threadId)
              t.copyWith(isFollowing: event.following)
            else
              t,
        ],
      ),
    );
  }

  /// thread_read_changed من WebSocket — تحديث عدادات القراءة محلياً.
  void _onSocketReadChanged(
    ThreadReadChangedSocketEvent event,
    Emitter<ThreadsState> emit,
  ) {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    emit(
      current.copyWith(
        threads: [
          for (final t in current.threads)
            if (t.rootPostId == event.threadId)
              t.copyWith(
                lastViewedAt: event.lastViewedAt,
                unreadMentions: event.unreadMentions,
                unreadReplies: event.unreadReplies,
              )
            else
              t,
        ],
      ),
    );
  }

  /// حفظ/إزالة من المحفوظات — يرسل flag/unflag للخادم ثم يحدّث حالة
  /// is_saved محلياً (مطابق للسلوك المتفائل في webapp).
  Future<void> _onToggleSave(
    ToggleSaveEvent event,
    Emitter<ThreadsState> emit,
  ) async {
    final current = state;
    if (current is! ThreadsLoadedState) return;
    try {
      final postRepository = getIt<PostRepository>();
      if (event.isCurrentlySaved) {
        await postRepository.unflagPost(event.threadId);
      } else {
        await postRepository.flagPost(event.threadId);
      }
      emit(
        current.copyWith(
          threads: [
            for (final t in current.threads)
              if (t.rootPostId == event.threadId)
                t.copyWith(
                  rootPost: t.rootPost.copyWith(
                    isSaved: !event.isCurrentlySaved,
                  ),
                )
              else
                t,
          ],
        ),
      );
    } catch (e) {
      debugPrint('[ThreadsBloc] _onToggleSave error: $e');
      // لا نوقف القائمة عند فشل الشبكة — تبقى الحالة القديمة.
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
