import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/typing_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/file_info_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/threads_repository.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';

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
  final Map<String, dynamic>? metadata;
  final int? scheduledAt;
  final Completer<PostEntity>? completer;

  const SendPostEvent({
    required this.channelId,
    required this.message,
    this.rootId,
    this.fileIds = const [],
    this.alsoSendToChannel = false,
    this.metadata,
    this.scheduledAt,
    this.completer,
  });
  @override
  List<Object?> get props => [
    channelId,
    message,
    rootId,
    fileIds,
    alsoSendToChannel,
  ];
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

/// تحديث حالة متابعة محادثة من WebSocket (thread_follow_changed).
class RealtimeThreadFollowChangedEvent extends PostEvent {
  final String threadId;
  final bool following;
  const RealtimeThreadFollowChangedEvent(this.threadId, this.following);
  @override
  List<Object?> get props => [threadId, following];
}

/// تحديث عدادات قراءة محادثة من WebSocket (thread_read_changed).
class RealtimeThreadReadChangedEvent extends PostEvent {
  final String threadId;
  final int unreadReplies;
  const RealtimeThreadReadChangedEvent(this.threadId, this.unreadReplies);
  @override
  List<Object?> get props => [threadId, unreadReplies];
}

/// متابعة/إلغاء متابعة محادثة من تذييل الرسالة (ThreadFooter).
class ToggleThreadFollowEvent extends PostEvent {
  final String channelId;
  final String threadId;
  final bool follow;
  const ToggleThreadFollowEvent({
    required this.channelId,
    required this.threadId,
    required this.follow,
  });
  @override
  List<Object?> get props => [channelId, threadId, follow];
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

  /// حالة متابعة المحادثات (root post id ← isFollowing) لعرض تذييل الرسالة.
  final Map<String, bool> threadFollowing;

  /// عدد الردود غير المقروءة لكل محادثة (root post id ← count).
  final Map<String, int> threadUnreadReplies;

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
    this.threadFollowing = const {},
    this.threadUnreadReplies = const {},
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

  List<FileInfoEntity> filesFor(String postId) {
    final list = files[postId];
    if (list != null && list.isNotEmpty) return list;

    final post = postById(postId);
    if (post != null &&
        post.metadata?.files != null &&
        post.metadata!.files!.isNotEmpty) {
      final parsed = <FileInfoEntity>[];
      for (final info in post.metadata!.files!) {
        try {
          if (info.id.isNotEmpty) parsed.add(info);
        } catch (_) {}
      }
      if (parsed.isNotEmpty) return parsed;
    }
    return const [];
  }

  PostsLoadedState copyWith({
    List<PostEntity>? posts,
    bool? hasMore,
    Set<String>? flaggedIds,
    Set<String>? typingUserIds,
    Map<String, List<ReactionEntity>>? reactions,
    Map<String, List<FileInfoEntity>>? files,
    Set<String>? pinnedIds,
    String? focusPostId,
    Map<String, bool>? threadFollowing,
    Map<String, int>? threadUnreadReplies,
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
    threadFollowing: threadFollowing ?? this.threadFollowing,
    threadUnreadReplies: threadUnreadReplies ?? this.threadUnreadReplies,
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
    threadFollowing,
    threadUnreadReplies,
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
  final ChannelBloc _channelBloc;
  final RhsBloc _rhsBloc;
  StreamSubscription? _wsSubscription;
  StreamSubscription? _channelSubscription;
  Timer? _typingClearTimer;

  /// يتتبع آخر وقت لتغيير التفاعل لكل (postId:emoji).
  /// يُستخدم لمنع أحداث WebSocket القديمة من إعادة إضافة تفاعل أُزيل بالفعل.
  final Map<String, int> _lastReactionToggleAt = {};

  void _cleanOldToggles() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _lastReactionToggleAt.removeWhere((_, ts) => now - ts > 10000);
  }

  PostBloc(
    this._postRepository,
    this._webSocketManager,
    this._typingDataSource,
    this._secureStorage,
    this._channelBloc,
    this._rhsBloc,
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
    on<RealtimeThreadFollowChangedEvent>(_onRealtimeThreadFollowChanged);
    on<RealtimeThreadReadChangedEvent>(_onRealtimeThreadReadChanged);
    on<ToggleThreadFollowEvent>(_onToggleThreadFollow);
    on<_ClearTypingEvent>(_onClearTyping);

    _listenToWebSocketEvents();

    // تحميل الرسائل فور اختيار قناة (أو عند أول تحميل للقنوات).
    void checkChannelState(ChannelState channelState) {
      if (channelState is ChannelsLoadedState &&
          channelState.selectedChannel != null) {
        final selectedId = channelState.selectedChannel!.id;
        final current = state;
        final currentChannelId =
            current is PostsLoadedState ? current.channelId : '';
        if (currentChannelId != selectedId) {
          add(LoadPostsForChannelEvent(selectedId));
        }
      }
    }

    _channelSubscription = _channelBloc.stream.listen(checkChannelState);
    checkChannelState(_channelBloc.state);
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
      } else if (event is ThreadFollowChangedEvent) {
        add(RealtimeThreadFollowChangedEvent(event.threadId, event.following));
      } else if (event is ThreadReadChangedEvent) {
        add(
          RealtimeThreadReadChangedEvent(event.threadId, event.unreadReplies),
        );
      }
    });
  }

  Future<void> _onLoadPosts(
    LoadPostsForChannelEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is PostsLoadedState && current.channelId == event.channelId) {
      return;
    }
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
      await _loadFlagged(emit);
      await _loadChannelExtras(emit);
      await _loadThreadFollowing(emit);
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
    } catch (e) {
      debugPrint('[PostBloc] _loadChannelExtras reactions error: $e');
    }

    final withFiles = current.posts.where((p) => p.fileIds.isNotEmpty).toList();
    if (withFiles.isNotEmpty) {
      final files = <String, List<FileInfoEntity>>{};
      final resolvedFromMetadata = <String>{};

      // 1) استخراج معلومات الملفات مباشرة من post.metadata.files
      // (نظير webapp الذي يستخدم metadata.files دون طلبات HTTP إضافية).
      for (final post in withFiles) {
        final metadataFiles = post.metadata?.files;
        if (metadataFiles == null || metadataFiles.isEmpty) continue;
        final list = <FileInfoEntity>[];
        for (final info in metadataFiles) {
          try {
            if (info.id.isEmpty) continue;
            list.add(info);
          } catch (_) {}
        }
        if (list.isNotEmpty) {
          files[post.id] = list;
          resolvedFromMetadata.add(post.id);
        }
      }

      // 2) مسودة احتياطية فقط للمنشورات التي تفتقد metadata.files.
      final needNetwork = withFiles
          .where((p) => !resolvedFromMetadata.contains(p.id))
          .toList();
      if (needNetwork.isNotEmpty) {
        await Future.wait(
          needNetwork.map((p) async {
            try {
              files[p.id] = await _postRepository.getFilesForPost(p.id);
            } catch (_) {}
          }),
        );
      }

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

  Future<void> _loadThreadFollowing(Emitter<PostsState> emit) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    try {
      final channelState = _channelBloc.state;
      final teamId = channelState is ChannelsLoadedState
          ? channelState.teamId
          : '';
      if (teamId.isEmpty) return;
      final userId = await _currentUserId();
      final threadsRepository = getIt<ThreadsRepository>();
      final followedThreads = await threadsRepository.getThreadsForUser(
        userId,
        teamId,
        perPage: 200,
      );
      if (state is PostsLoadedState) {
        final followedIds = {
          for (final t in followedThreads) t.rootPostId: true,
        };
        emit(
          (state as PostsLoadedState).copyWith(threadFollowing: followedIds),
        );
      }
    } catch (e) {
      debugPrint('[PostBloc] _loadThreadFollowing error: $e');
    }
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
      await _loadFlagged(emit);
      await _loadChannelExtras(emit);
      await _loadThreadFollowing(emit);
    } catch (e) {
      emit(PostErrorState(e.toString()));
    }
  }

  List<FileInfoEntity> _extractFilesFromPost(PostEntity post) {
    final metadataFiles = post.metadata?.files;
    if (metadataFiles == null || metadataFiles.isEmpty) return const [];
    final list = <FileInfoEntity>[];
    for (final info in metadataFiles) {
      try {
        if (info.id.isNotEmpty) list.add(info);
      } catch (_) {}
    }
    return list;
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
        metadata: event.metadata,
        scheduledAt: event.scheduledAt,
      );
      final current = state;
      if (current is PostsLoadedState && current.channelId == event.channelId) {
        final alreadyExists = current.posts.any((p) => p.id == newPost.id);
        if (!alreadyExists) {
          var updatedFiles = current.files;
          final fileList = _extractFilesFromPost(newPost);
          if (fileList.isNotEmpty) {
            updatedFiles =
                Map<String, List<FileInfoEntity>>.from(current.files)
                  ..[newPost.id] = fileList;
          } else if (newPost.fileIds.isNotEmpty) {
            try {
              final fetched = await _postRepository.getFilesForPost(newPost.id);
              if (fetched.isNotEmpty) {
                updatedFiles = Map<String, List<FileInfoEntity>>.from(
                  current.files,
                )..[newPost.id] = fetched;
              }
            } catch (_) {}
          }
          emit(
            current.copyWith(
              posts: [newPost, ...current.posts],
              files: updatedFiles,
            ),
          );
        }
      }
      event.completer?.complete(newPost);
    } catch (e) {
      event.completer?.completeError(e);
    }
  }

  Future<void> _onRealtimePostReceived(
    RealtimePostReceivedEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is PostsLoadedState &&
        current.channelId == event.post.channelId) {
      final exists = current.posts.any((p) => p.id == event.post.id);
      if (!exists) {
        var updatedFiles = current.files;
        final fileList = _extractFilesFromPost(event.post);
        if (fileList.isNotEmpty) {
          updatedFiles = Map<String, List<FileInfoEntity>>.from(current.files)
            ..[event.post.id] = fileList;
        } else if (event.post.fileIds.isNotEmpty) {
          try {
            final fetched = await _postRepository.getFilesForPost(
              event.post.id,
            );
            if (fetched.isNotEmpty) {
              updatedFiles = Map<String, List<FileInfoEntity>>.from(
                current.files,
              )..[event.post.id] = fetched;
            }
          } catch (_) {}
        }
        emit(
          current.copyWith(
            posts: [event.post, ...current.posts],
            files: updatedFiles,
          ),
        );
      }

      // Notify RHS if this is a reply to the currently open thread
      if (event.post.rootId.isNotEmpty) {
        _rhsBloc.add(ThreadRealtimeUpdatedEvent(event.post));
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

    // Notify RHS
    _rhsBloc.add(ThreadRealtimeUpdatedEvent(event.post));
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

    // Notify RHS
    _rhsBloc.add(ThreadRealtimeDeletedEvent(event.postId));
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
    } catch (e) {
      debugPrint('[PostBloc] _onToggleFlag error: $e');
    }
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
    } catch (e) {
      debugPrint('[PostBloc] _onSendTyping error: $e');
    }
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
    } catch (e) {
      debugPrint('[PostBloc] _onDeletePost error: $e');
    }
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
    } catch (e) {
      debugPrint('[PostBloc] _onEditPost error: $e');
    }
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
    } catch (e) {
      debugPrint('[PostBloc] _onTogglePin error: $e');
    }
  }

  Future<void> _onToggleReaction(
    ToggleReactionEvent event,
    Emitter<PostsState> emit,
  ) async {
    final userId = await _currentUserId();

    // جلب الحالة الحالية فوراً قبل البدء بالتحديث المتفائل
    if (state is! PostsLoadedState) return;
    var currentState = state as PostsLoadedState;

    final existing = currentState.reactionsFor(event.postId);
    final wasReacted = existing.any(
      (r) =>
          (r.userId == userId || r.userId == 'me') &&
          r.emojiName == event.emoji,
    );

    // تسجيل وقت التغيير لمنع أحداث WebSocket القديمة من التدخل
    final toggleKey = '${event.postId}:${event.emoji}';
    _lastReactionToggleAt[toggleKey] = DateTime.now().millisecondsSinceEpoch;
    _cleanOldToggles();

    final next = [...existing];
    if (wasReacted) {
      next.removeWhere(
        (r) =>
            (r.userId == userId || r.userId == 'me') &&
            r.emojiName == event.emoji,
      );
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

    // إرسال التحديث المتفائل باستخدام أحدث حالة متوفرة
    emit(
      currentState.copyWith(
        reactions: {...currentState.reactions, event.postId: next},
      ),
    );

    try {
      if (wasReacted) {
        await _postRepository.removeReaction(event.postId, event.emoji);
      } else {
        await _postRepository.addReaction(event.postId, event.emoji);
      }
    } catch (e) {
      debugPrint('[PostBloc] _onToggleReaction error: $e');
      // تراجع جراحي: نتحقق من الحالة اللحظية قبل التراجع
      final latestState = state;
      if (latestState is PostsLoadedState) {
        final currentForPost = latestState.reactionsFor(event.postId);

        // لا نتراجع إلا إذا كان التفاعل ما زال "متفائلاً" (بدون serverId)
        // ولم يتم تأكيده بعد بواسطة WebSocket.
        final isStillOptimistic =
            !wasReacted &&
            currentForPost.any(
              (r) =>
                  r.serverId.isEmpty &&
                  r.emojiName == event.emoji &&
                  (r.userId == userId || r.userId == 'me'),
            );
        final failedToRemove =
            wasReacted &&
            !currentForPost.any(
              (r) =>
                  r.emojiName == event.emoji &&
                  (r.userId == userId || r.userId == 'me'),
            );

        if (isStillOptimistic || failedToRemove) {
          final reverted = [...currentForPost];
          if (isStillOptimistic) {
            reverted.removeWhere(
              (r) => r.serverId.isEmpty && r.emojiName == event.emoji,
            );
          } else {
            reverted.add(
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
            latestState.copyWith(
              reactions: {...latestState.reactions, event.postId: reverted},
            ),
          );
        }
      }
    }
  }

  void _onRealtimeReaction(
    RealtimeReactionEvent event,
    Emitter<PostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! PostsLoadedState) return;

    if (event.added) {
      final userId = await _currentUserId();
      if (event.reaction.userId == userId) {
        final toggleKey = '${event.reaction.postId}:${event.reaction.emojiName}';
        final lastToggleAt = _lastReactionToggleAt[toggleKey];
        if (lastToggleAt != null) {
          final elapsed = DateTime.now().millisecondsSinceEpoch - lastToggleAt;
          if (elapsed < 5000) {
            return;
          }
        }
      }
    }

    final existing = currentState.reactionsFor(event.reaction.postId);
    final existingIndex = existing.indexWhere(
      (r) =>
          (r.userId == event.reaction.userId || r.userId == 'me') &&
          r.emojiName == event.reaction.emojiName,
    );

    List<ReactionEntity> next;
    if (event.added) {
      if (existingIndex != -1) {
        next = [...existing];
        next[existingIndex] = event.reaction;
      } else {
        next = [...existing, event.reaction];
      }
    } else {
      if (existingIndex != -1) {
        next = [...existing]..removeAt(existingIndex);
      } else {
        return;
      }
    }

    emit(
      currentState.copyWith(
        reactions: {...currentState.reactions, event.reaction.postId: next},
      ),
    );
  }

  /// thread_follow_changed من WebSocket — يحدّث زر المتابعة في تذييل الرسالة.
  void _onRealtimeThreadFollowChanged(
    RealtimeThreadFollowChangedEvent event,
    Emitter<PostsState> emit,
  ) {
    final current = state;
    if (current is! PostsLoadedState) return;
    emit(
      current.copyWith(
        threadFollowing: {
          ...current.threadFollowing,
          event.threadId: event.following,
        },
      ),
    );
  }

  /// thread_read_changed من WebSocket — يحدّث نقطة الردود غير المقروءة.
  void _onRealtimeThreadReadChanged(
    RealtimeThreadReadChangedEvent event,
    Emitter<PostsState> emit,
  ) {
    final current = state;
    if (current is! PostsLoadedState) return;
    emit(
      current.copyWith(
        threadUnreadReplies: {
          ...current.threadUnreadReplies,
          event.threadId: event.unreadReplies,
        },
      ),
    );
  }

  /// متابعة/إلغاء متابعة محادثة من تذييل الرسالة — يطابق
  /// followThread/unfollowThread في webapp (PUT/DELETE .../following).
  Future<void> _onToggleThreadFollow(
    ToggleThreadFollowEvent event,
    Emitter<PostsState> emit,
  ) async {
    final current = state;
    if (current is! PostsLoadedState) return;
    final channelState = _channelBloc.state;
    final teamId = channelState is ChannelsLoadedState
        ? channelState.teamId
        : '';
    final userId = (await _secureStorage.getUserId()) ?? 'me';
    debugPrint('[PostBloc] _onToggleThreadFollow: follow=${event.follow}, threadId=${event.threadId}, userId=$userId, teamId=$teamId');
    try {
      final threadsRepository = getIt<ThreadsRepository>();
      if (event.follow) {
        await threadsRepository.followThread(userId, teamId, event.threadId);
      } else {
        await threadsRepository.unfollowThread(userId, teamId, event.threadId);
      }
      debugPrint('[PostBloc] _onToggleThreadFollow: remote call succeeded');
      emit(
        current.copyWith(
          threadFollowing: {
            ...current.threadFollowing,
            event.threadId: event.follow,
          },
        ),
      );
    } catch (e) {
      debugPrint('[PostBloc] _onToggleThreadFollow error: $e');
      // يحافظ على الحالة عند فشل الشبكة.
    }
  }

  @override
  Future<void> close() async {
    _wsSubscription?.cancel();
    _channelSubscription?.cancel();
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
