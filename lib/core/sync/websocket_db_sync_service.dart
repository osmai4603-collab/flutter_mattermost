import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:drift/drift.dart';

import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';

import 'package:flutter_mattermost/core/sync/event_batch_processor.dart';

@lazySingleton
class WebsocketDbSyncService {
  final WebSocketClientManager _wsClient;
  final ChatLocalDataSource _chatLocalDataSource;
  final AppDatabase _db;
  final EventBatchProcessor _batchProcessor;
  StreamSubscription? _subscription;

  WebsocketDbSyncService(
    this._wsClient,
    this._chatLocalDataSource,
    this._db,
    this._batchProcessor,
  );

  void start() {
    if (_subscription != null) return;
    _subscription = _wsClient.eventStream.listen(_handleEvent);
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  Future<void> _handleEvent(TypedWebSocketEvent event) async {
    if (event is PostCreatedEvent) {
      _batchProcessor.bufferPost(event.post);
      // If it has pendingPostId, clean up outbox
      if (event.post.pendingPostId.isNotEmpty) {
        await _chatLocalDataSource.deletePendingPost(event.post.pendingPostId);
      }
    } else if (event is PostUpdatedEvent) {
      await _chatLocalDataSource.updateCachedPost(event.post);
    } else if (event is PostDeletedEvent) {
      await _chatLocalDataSource.markPostDeleted(event.postId);
    } else if (event is ReactionChangedEvent) {
      final entity = event.reaction;
      if (event.added) {
        await _chatLocalDataSource.cacheReactions([entity]);
      } else {
        await _chatLocalDataSource.removeReaction(
          entity.userId,
          entity.postId,
          entity.emojiName,
        );
      }
    } else if (event is UserPresenceEvent) {
      await _chatLocalDataSource.cacheUserStatuses([
        UserStatusEntity(
          serverId: '', 
          userId: event.userId,
          status: event.status,
        ),
      ]);
    } else if (event is ChannelUpdatedEvent) {
      await _chatLocalDataSource.cacheChannels([event.channel]);
    } else if (event is ChannelConvertedEvent) {
      // Update channel type
      await (_db.update(_db.cachedChannels)
            ..where((t) => t.id.equals(event.channelId)))
          .write(CachedChannelsCompanion(type: Value(event.type)));
    } else if (event is ChannelViewedEvent) {
      // Update last viewed at for the current user
      if (event.lastViewedAt != null) {
        await (_db.update(_db.cachedChannelMembers)
              ..where((t) => t.channelId.equals(event.channelId)))
            .write(CachedChannelMembersCompanion(
                lastViewedAt: Value(event.lastViewedAt!)));
      }
    } else if (event is UserUpdatedEvent) {
      // Update cached user
      final user = event.userJson;
      await _db.into(_db.cachedUsers).insert(
            CachedUsersCompanion.insert(
              serverId: '', // Need to handle serverId
              id: user['id'] as String? ?? '',
              username: user['username'] as String? ?? '',
              email: user['email'] as String? ?? '',
              firstName: Value(user['first_name'] as String? ?? ''),
              lastName: Value(user['last_name'] as String? ?? ''),
              nickname: Value(user['nickname'] as String? ?? ''),
              position: Value(user['position'] as String? ?? ''),
              roles: Value(user['roles'] as String? ?? 'system_user'),
            ),
            mode: InsertMode.insertOrReplace,
          );
    } else if (event is PostUnreadEvent) {
      await (_db.update(_db.cachedChannelMembers)
            ..where((t) => t.channelId.equals(event.channelId)))
          .write(CachedChannelMembersCompanion(
        msgCount: Value(event.msgCount),
        mentionCount: Value(event.mentionCount),
      ));
    }
    // Add more handlers as needed
  }
}
