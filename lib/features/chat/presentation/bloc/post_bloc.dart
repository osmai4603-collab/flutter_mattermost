import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/typing_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';

// Events
abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object?> get props => [];
}

class LoadPostsForChannelEvent extends PostEvent {
  final String channelId;
  const LoadPostsForChannelEvent(this.channelId);
  @override
  List<Object?> get props => [channelId];
}

class LoadMorePostsEvent extends PostEvent {
  final String channelId;
  final String oldestPostId;
  const LoadMorePostsEvent(this.channelId, this.oldestPostId);
  @override
  List<Object?> get props => [channelId, oldestPostId];
}

/// تحميل منشورات حول رسالة محددة + تحديدها للتسليط عليها (webapp jumpToPost).
class LoadPostsAroundEvent extends PostEvent {
  final String channelId;
  final String postId;
  const LoadPostsAroundEvent(this.channelId, this.postId);
  @override
  List<Object?> get props => [channelId, postId];
}

class SendPostEvent extends PostEvent {
  final String channelId;
  final String message;
  final String? rootId;
  final List<String> fileIds;
  final bool alsoSendToChannel;

  const SendPostEvent({
    required this.channelId,
    required this.message,
    this.rootId,
    this.fileIds = const [],
    this.alsoSendToChannel = false,
  });
  @override
  List<Object?> get props => [channelId, message, rootId, fileIds, alsoSendToChannel];
}

class RealtimePostReceivedEvent extends PostEvent {
  final PostEntity post;
  const RealtimePostReceivedEvent(this.post);
  @override
  List<Object?> get props => [post];
}

class RealtimePostUpdatedEvent extends PostEvent {
  final PostEntity post;
  const RealtimePostUpdatedEvent(this.post);
  @override
  List<Object?> get props => [post];
}

class RealtimePostDeletedEvent extends PostEvent {
  final String postId;
  const RealtimePostDeletedEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class RealtimeTypingEvent extends PostEvent {
  final String userId;
  final String channelId;
  const RealtimeTypingEvent(this.userId, this.channelId);
  @override
  List<Object?> get props => [userId, channelId];
}

class SendTypingEvent extends PostEvent {
  final String channelId;
  final String? parentId;
  const SendTypingEvent(this.channelId, {this.parentId});
  @override
  List<Object?> get props => [channelId, parentId];
}

class ToggleFlagPostEvent extends PostEvent {
  final String postId;
  const ToggleFlagPostEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class DeletePostEvent extends PostEvent {
  final String postId;
  const DeletePostEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class EditPostEvent extends PostEvent {
  final String postId;
  final String newMessage;
  const EditPostEvent(this.postId, this.newMessage);
  @override
  List<Object?> get props => [postId, newMessage];
}

class TogglePinPostEvent extends PostEvent {
  final String postId;
  const TogglePinPostEvent(this.postId);
  @override
  List<Object?> get props => [postId];
}

class ToggleReactionEvent extends PostEvent {
  final String postId;
  final String emoji;
  const ToggleReactionEvent(this.postId, this.emoji);
  @override
  List<Object?> get props => [postId, emoji];
}

class RealtimeReactionEvent extends PostEvent {
  final ReactionEntity reaction;
  final bool added;
  const RealtimeReactionEvent(this.reaction, this.added);
  @override
  List<Object?> get props => [reaction, added];
}

// States
abstract class PostsState extends Equatable {
  const PostsState();
  @override
  List<Object?> get props => [];
}

class PostInitialState extends PostsState {}

class PostLoadingState extends PostsState {
  final String channelId;
  const PostLoadingState(this.channelId);
  @override
  List<Object?> get props => [channelId];
}

class PostsLoadedState extends PostsState {
  final String channelId;
  final List<PostEntity> posts;
  final bool hasMore;
  final Set<String> flaggedIds;
  final Set<String> typingUserIds;
  final Map<String, List<ReactionEntity>> reactions;
  final Map<String, List<FileInfoEntity>> files;
  final Set<String> pinnedIds;
  final String? focusPostId;

  const PostsLoadedState({
    required this.channelId,
    required this.posts,
    this.hasMore = false,
    this.flaggedIds = const {},
    this.typingUserIds = const {},
    this.reactions = const {},
    this.files = const {},
    this.pinnedIds = const {},
    this.focusPostId,
  });

  /// الرسائل الرئيسية (غير المتصلة) بترتيب الأحدث إلى الأقدم.
  List<PostEntity> get rootPosts =>
      posts.where((p) => p.rootId.isEmpty).toList();

  PostEntity? postById(String id) {
    for (final p in posts) {
      if (p.id == id) return p;
    }
    return null;
  }

  /// عدد الردود ضمن النطاق المحمّل.
  int replyCountFor(String rootId) =>
      posts.where((p) => p.rootId == rootId).length;

  bool isFlagged(String postId) => flaggedIds.contains(postId);

  bool isPinned(String postId) => pinnedIds.contains(postId);

  List<ReactionEntity> reactionsFor(String postId) =>
      reactions[postId] ?? const [];

  List<FileInfoEntity> filesFor(String postId) => files[postId] ?? const [];

  PostsLoadedState copyWith({
    List<PostEntity>? posts,
    bool? hasMore,
    Set<String>? flaggedIds,
    Set<String>? typingUserIds,
    Map<String, List<ReactionEntity>>? reactions,
    Map<String, List<FileInfoEntity>>? files,
    Set<String>? pinnedIds,
    String? focusPostId,
  }) => PostsLoadedState(
    channelId: channelId,
    posts: posts ?? this.posts,
    hasMore: hasMore ?? this.hasMore,
    flaggedIds: flaggedIds ?? this.flaggedIds,
    typingUserIds: typingUserIds ?? this.typingUserIds,
    reactions: reactions ?? this.reactions,
    files: files ?? this.files,
    pinnedIds: pinnedIds ?? this.pinnedIds,
    focusPostId: focusPostId ?? this.focusPostId,
  );

  @override
  List<Object?> get props => [
    channelId,
    posts,
    hasMore,
    flaggedIds,
    typingUserIds,
    reactions,
    files,
    pinnedIds,
    focusPostId,
  ];
}

class PostErrorState extends PostsState {
  final String message;
  const PostErrorState(this.message);
  @override
  List<Object?> get props => [message];
}

@LazySingleton()
class PostBloc extends Bloc<PostEvent, PostsState> {
  final PostRepository _postRepository;
  final WebSocketClientManager _webSocketManager;
  final TypingRemoteDataSource _typingDataSource;
  final SecureStorageService _secureStorage;
  StreamSubscription? _wsSubscription;
  Timer? _typingClearTimer;

  PostBloc(
    this._postRepository,
    this._webSocketManager,
    this._typingDataSource,
    this._secureStorage,
  ) : super(PostInitialState()) {
    on<LoadPostsForChannelEvent>(_onLoadPosts);
    on<LoadMorePostsEvent>(_onLoadMorePosts);
    on<LoadPostsAroundEvent>(_onLoadPostsAround);
    on<SendPostEvent>(_onSendPost);
    on<RealtimePostReceivedEvent>(_onRealtimePostReceived);
    on<RealtimePostUpdatedEvent>(_onRealtimePostUpdated);
    on<RealtimePostDeletedEvent>(_onRealtimePostDeleted);
    on<RealtimeTypingEvent>(_onRealtimeTyping);
    on<ToggleFlagPostEvent>(_onToggleFlag);
    on<DeletePostEvent>(_onDeletePost);
    on<EditPostEvent>(_onEditPost);
    on<TogglePinPostEvent>(_onTogglePin);
    on<ToggleReactionEvent>(_onToggleReaction);
    on<RealtimeReactionEvent>(_onRealtimeReaction);
    on<SendTypingEvent>(_onSendTyping);
    on<_ClearTypingEvent>(_onClearTyping);

    _listenToWebSocketEvents();
  }

  Future<String> _currentUserId() async =>
      (await _secureStorage.getUserId()) ?? 'me';

  void _listenToWebSocketEvents() {
    _wsSubscription = _webSocketManager.eventStream.listen((event) {
      if (event is PostCreatedEvent) {
        add(RealtimePostReceivedEvent((event.post)));
      } else if (event is PostUpdatedEvent) {
        add(RealtimePostUpdatedEvent((event.post)));
      } else if (event is PostDeletedEvent) {
        add(RealtimePostDeletedEvent(event.postId));
      } else if (event is UserTypingEvent) {
        add(RealtimeTypingEvent(event.userId, event.channelId));
      } else if (event is ReactionChangedEvent) {
        add(RealtimeReactionEvent(event.reaction, event.added));
      }
    });
  }

  Future<void> _onLoadPosts(
    LoadPostsForChannelEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostLoadingState(event.channelId));
    try {
      final posts = await _postRepository.getPostsForChannel(event.channelId);
      emit(
        PostsLoadedState(
          channelId: event.channelId,
          posts: posts,
          hasMore: posts.length >= 60,
        ),
      );
      _loadFlagged(emit);
      _loadChannelExtras(emit);
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  Future<void> _loadChannelExtras(Emitter<PostsState> emit) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    final postIds = current.posts.map((p) => p.id).toList();

    try {
      final byPost = await _postRepository.getReactionsForPosts(postIds);
      if (state is PostsLoadedState) {
        emit((state as PostsLoadedState).copyWith(reactions: byPost));
      }
    } catch (_) {}

    final withFiles = current.posts.where((p) => p.fileIds.isNotEmpty).toList();
    if (withFiles.isNotEmpty) {
      final files = <String, List<FileInfoEntity>>{};
      await Future.wait(
        withFiles.map((p) async {
          try {
            files[p.id] = await _postRepository.getFilesForPost(p.id);
          } catch (_) {}
        }),
      );
      if (state is PostsLoadedState) {
        emit((state as PostsLoadedState).copyWith(files: files));
      }
    }

    try {
      final pinned = await _postRepository.getPinnedPosts(current.channelId);
      if (state is PostsLoadedState) {
        emit(
          (state as PostsLoadedState).copyWith(
            pinnedIds: {for (final p in pinned) p.id},
          ),
        );
      }
    } catch (_) {}
  }

  Future<void> _loadFlagged(Emitter<PostsState> emit) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    try {
      final flagged = await _postRepository.getFlaggedPosts('me');
      emit(current.copyWith(flaggedIds: {for (final p in flagged) p.id}));
    } catch (_) {}
  }

  Future<void> _onLoadMorePosts(
    LoadMorePostsEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoadedState ||
        current.channelId != event.channelId ||
        !current.hasMore) {
      return;
    }
    try {
      final older = await _postRepository.getPostsForChannel(
        event.channelId,
        before: event.oldestPostId,
      );
      emit(
        current.copyWith(
          posts: [...current.posts, ...older],
          hasMore: older.length >= 60,
        ),
      );
    } catch (_) {}
  }

  Future<void> _onLoadPostsAround(
    LoadPostsAroundEvent event,
    Emitter<PostsState> emit,
  ) async {
    emit(PostLoadingState(event.channelId));
    try {
      final posts = await _postRepository.getPostsAround(
        event.channelId,
        event.postId,
      );
      final sorted = [...posts]
        ..sort((a, b) => b.createAt.compareTo(a.createAt));
      emit(
        PostsLoadedState(
          channelId: event.channelId,
          posts: sorted,
          hasMore: sorted.length >= PAGE_SIZE,
          focusPostId: event.postId,
        ),
      );
      _loadFlagged(emit);
      _loadChannelExtras(emit);
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  Future<void> _onSendPost(
    SendPostEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      final newPost = await _postRepository.sendPost(
        event.channelId,
        event.message,
        rootId: event.rootId,
        fileIds: event.fileIds,
        alsoSendToChannel: event.alsoSendToChannel,
      );
      final current = state;
      if (current is PostsLoadedState && current.channelId == event.channelId) {
        emit(current.copyWith(posts: [newPost, ...current.posts]));
      }
    } catch (_) {
      // فشل الإرسال — يتعامل معه الـ repository عبر طابور الإرسال المحلي.
    }
  }

  void _onRealtimePostReceived(
    RealtimePostReceivedEvent event,
    Emitter<PostsState> emit,
  ) {
    final current = state;
    if (current is PostsLoadedState &&
        current.channelId == event.post.channelId) {
      final exists = current.posts.any((p) => p.id == event.post.id);
      if (!exists) {
        emit(current.copyWith(posts: [event.post, ...current.posts]));
      }
    }
  }

  void _onRealtimePostUpdated(
    RealtimePostUpdatedEvent event,
    Emitter<PostsState> emit,
  ) {
    final current = state;
    if (current is PostsLoadedState &&
        current.channelId == event.post.channelId) {
      emit(
        current.copyWith(
          posts: current.posts
              .map((p) => p.id == event.post.id ? event.post : p)
              .toList(),
        ),
      );
    }
  }

  void _onRealtimePostDeleted(
    RealtimePostDeletedEvent event,
    Emitter<PostsState> emit,
  ) {
    final current = state;
    if (current is PostsLoadedState) {
      emit(
        current.copyWith(
          posts: current.posts.where((p) => p.id != event.postId).toList(),
        ),
      );
    }
  }

  void _onRealtimeTyping(RealtimeTypingEvent event, Emitter<PostsState> emit) {
    final current = state;
    if (current is PostsLoadedState && current.channelId == event.channelId) {
      if (event.userId.isEmpty ||
          current.typingUserIds.contains(event.userId)) {
        return;
      }
      emit(
        current.copyWith(
          typingUserIds: {...current.typingUserIds, event.userId},
        ),
      );
      _typingClearTimer?.cancel();
      _typingClearTimer = Timer(const Duration(seconds: 6), () {
        final st = state;
        if (st is PostsLoadedState) {
          add(_ClearTypingEvent(st.typingUserIds));
        }
      });
    }
  }

  void _onClearTyping(_ClearTypingEvent event, Emitter<PostsState> emit) {
    final current = state;
    if (current is PostsLoadedState) {
      emit(current.copyWith(typingUserIds: {}));
    }
  }

  Future<void> _onToggleFlag(
    ToggleFlagPostEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    final isFlagged = current.flaggedIds.contains(event.postId);
    try {
      if (isFlagged) {
        await _postRepository.unflagPost(event.postId);
      } else {
        await _postRepository.flagPost(event.postId);
      }
      final next = {...current.flaggedIds};
      isFlagged ? next.remove(event.postId) : next.add(event.postId);
      emit(current.copyWith(flaggedIds: next));
    } catch (_) {}
  }

  Future<void> _onSendTyping(
    SendTypingEvent event,
    Emitter<PostsState> emit,
  ) async {
    try {
      await _typingDataSource.sendTypingEvent(
        event.channelId,
        parentId: event.parentId,
      );
    } catch (_) {}
  }

  Future<void> _onDeletePost(
    DeletePostEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    if (current.postById(event.postId) == null) return;
    try {
      await _postRepository.deletePost(event.postId);
      emit(
        current.copyWith(
          posts: current.posts.where((p) => p.id != event.postId).toList(),
        ),
      );
    } catch (_) {}
  }

  Future<void> _onEditPost(
    EditPostEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    if (current.postById(event.postId) == null) return;
    try {
      final updated = await _postRepository.patchPost(event.postId, {
        'message': event.newMessage,
      });
      emit(
        current.copyWith(
          posts: current.posts
              .map((p) => p.id == event.postId ? updated : p)
              .toList(),
        ),
      );
    } catch (_) {}
  }

  Future<void> _onTogglePin(
    TogglePinPostEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    final isPinned = current.pinnedIds.contains(event.postId);
    try {
      if (isPinned) {
        await _postRepository.unpinPost(event.postId);
      } else {
        await _postRepository.pinPost(event.postId);
      }
      final next = {...current.pinnedIds};
      isPinned ? next.remove(event.postId) : next.add(event.postId);
      emit(current.copyWith(pinnedIds: next));
    } catch (_) {}
  }

  Future<void> _onToggleReaction(
    ToggleReactionEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    final existing = current.reactionsFor(event.postId);
    final userId = await _currentUserId();
    final mine = existing.where((r) => r.userId == userId).toList();
    final wasReacted = mine.any((r) => r.emojiName == event.emoji);

    final next = [...existing];
    if (wasReacted) {
      next.removeWhere((r) => r.userId == userId && r.emojiName == event.emoji);
    } else {
      next.add(
        ReactionEntity(
          serverId: '',
          userId: userId,
          postId: event.postId,
          emojiName: event.emoji,
          createAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
    emit(
      current.copyWith(reactions: {...current.reactions, event.postId: next}),
    );

    try {
      if (wasReacted) {
        await _postRepository.removeReaction(event.postId, event.emoji);
      } else {
        await _postRepository.addReaction(event.postId, event.emoji);
      }
    } catch (_) {
      // التراجع عن التحديث المتفائل عند الفشل.
      emit(current.copyWith(reactions: current.reactions));
    }
  }

  void _onRealtimeReaction(
    RealtimeReactionEvent event,
    Emitter<PostsState> emit,
  ) {
    final current = state;
    if (current is! PostsLoadedState) return;
    final existing = current.reactionsFor(event.reaction.postId);
    final alreadyPresent = existing.any(
      (r) =>
          r.userId == event.reaction.userId &&
          r.emojiName == event.reaction.emojiName,
    );
    List<ReactionEntity> next;
    if (event.added && !alreadyPresent) {
      next = [...existing, event.reaction];
    } else if (!event.added && alreadyPresent) {
      next = existing
          .where(
            (r) =>
                !(r.userId == event.reaction.userId &&
                    r.emojiName == event.reaction.emojiName),
          )
          .toList();
    } else {
      return;
    }
    emit(
      current.copyWith(
        reactions: {...current.reactions, event.reaction.postId: next},
      ),
    );
  }

  @override
  Future<void> close() async {
    _wsSubscription?.cancel();
    _typingClearTimer?.cancel();
    await super.close();
  }
}

class _ClearTypingEvent extends PostEvent {
  final Set<String> userIds;
  const _ClearTypingEvent(this.userIds);
  @override
  List<Object?> get props => [userIds];
}

const int PAGE_SIZE = 60;
