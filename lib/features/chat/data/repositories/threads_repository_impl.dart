import 'package:flutter_mattermost/core/enums/post_type.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/threads_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/models/post_model.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/thread_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/repositories/threads_repository.dart';

/// ينفّذ [ThreadsRepository] عبر ThreadsRemoteDataSource مع فتح
/// الجذر (root post) من حمولة الاستجابة.
class ThreadsRepositoryImpl implements ThreadsRepository {
  final ThreadsRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  ThreadsRepositoryImpl(this._remoteDataSource, this._secureStorage);

  Future<String> _currentUserId() async =>
      (await _secureStorage.getUserId()) ?? 'me';

  @override
  Future<List<ThreadEntity>> getThreadsForUser(
    String userId,
    String teamId, {
    int page = 0,
    int perPage = 60,
    bool unread = false,
  }) async {
    final data = await _remoteDataSource.getThreadsForUser(
      teamId,
      page: page,
      perPage: perPage,
      unread: unread,
    );
    final rawThreads = (data['threads'] as List<dynamic>? ?? const []);
    return [
      for (final raw in rawThreads)
        _fromJson(raw as Map<String, dynamic>, userId),
    ];
  }

  ThreadEntity _fromJson(Map<String, dynamic> json, String _) {
    final postJson = json['post'] as Map<String, dynamic>?;
    final post = postJson != null
        ? PostModel.fromMap(postJson).toEntity()
        : _emptyRoot(json['id'] as String? ?? '');
    return ThreadEntity(
      rootPostId: json['id'] as String? ??
          post.id,
      channelId: post.channelId,
      channelName: json['channel_name'] as String? ?? '',
      rootPost: post,
      replyCount: (json['reply_count'] as num?)?.toInt() ?? 0,
      lastReplyAt: (json['last_reply_at'] as num?)?.toInt() ?? 0,
      lastViewedAt: (json['last_viewed_at'] as num?)?.toInt() ?? 0,
      isFollowing: json['is_following'] as bool? ?? true,
      unreadReplies: (json['unread_replies'] as num?)?.toInt() ?? 0,
      unreadMentions: (json['unread_mentions'] as num?)?.toInt() ?? 0,
    );
  }

  /// جذر فارغ احتياطي عندما لا تحتوي الحمولة على "post".
  PostEntity _emptyRoot(String id) => PostEntity(
    id: id,
    channelId: '',
    userId: '',
    message: '',
    rootId: '',
    createAt: 0,
    updateAt: 0,
    deleteAt: 0,
    editAt: 0,
    originalId: '',
    type: PostType.defaultType,
    propsData: const {},
    hashtag: '',
    fileIds: const [],
    pendingPostId: '',
  );

  @override
  Future<void> markThreadAsRead(
    String userId,
    String teamId,
    String threadId,
  ) async {
    await _remoteDataSource.markThreadAsRead(
      userId,
      teamId,
      threadId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
