import 'dart:async';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';

@lazySingleton
class WebSocketDbSyncService {
  final WebSocketClientManager _wsManager;
  final AppDatabase _db;
  final SecureStorageService _secureStorage;
  StreamSubscription? _eventSubscription;

  WebSocketDbSyncService(this._wsManager, this._db, this._secureStorage);

  void startListening() {
    _eventSubscription?.cancel();
    _eventSubscription = _wsManager.eventStream.listen(_onEventReceived);
  }

  void stopListening() {
    _eventSubscription?.cancel();
    _eventSubscription = null;
  }

  Future<void> _onEventReceived(TypedWebSocketEvent event) async {
    final serverId = await _secureStorage.getServerUrl() ?? 'default_server';

    if (event is PostCreatedEvent) {
      await _handlePostCreated(event, serverId);
    }
    // Handle other events like UserTypingEvent if needed in the future
  }

  Future<void> _handlePostCreated(
    PostCreatedEvent event,
    String serverId,
  ) async {
    final post = event.post;

    final postId = post.id;
    if (postId.isEmpty) return;

    final channelId = post.channelId.isNotEmpty
        ? post.channelId
        : event.channelId;
    final userId = post.userId;
    final message = post.message;
    final rootId = post.rootId;
    final createAt = post.createAt;
    final updateAt = post.updateAt;
    final deleteAt = post.deleteAt;
    final pendingPostId = post.pendingPostId;

    final companion = CachedPostsCompanion(
      serverId: Value(serverId),
      id: Value(postId),
      channelId: Value(channelId),
      userId: Value(userId),
      message: Value(message),
      rootId: Value(rootId),
      createAt: Value(createAt),
      updateAt: Value(updateAt),
      deleteAt: Value(deleteAt),
      pendingPostId: Value(pendingPostId),
    );

    await _db.into(_db.cachedPosts).insertOnConflictUpdate(companion);
  }
}
