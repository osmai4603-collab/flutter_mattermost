import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';

import 'package:flutter_mattermost/features/chat/domain/entities/pending_post_entity.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheChannels(List<ChannelEntity> channels);
  Future<List<ChannelEntity>> getCachedChannels(String teamId);
  Future<void> cacheReactions(List<ReactionEntity> reactions);
  Future<Map<String, List<ReactionEntity>>> getCachedReactionsForPosts(
    List<String> postIds,
  );
  Future<void> removeReaction(String userId, String postId, String emojiName);
  Future<void> cacheUserStatuses(List<UserStatusEntity> statuses);
  Future<void> cacheUsers(List<UserEntity> users);
  Future<List<UserEntity>> getCachedUsers();
  Future<void> enqueuePendingAction(
    String actionType,
    Map<String, dynamic> payload,
  );
  Future<List<Map<String, dynamic>>> getPendingActions({
    String status = 'pending',
  });
  Future<void> completePendingAction(int actionId);

  // Pending Posts
  Future<void> savePendingPost(PendingPostEntity post);
  Future<List<PendingPostEntity>> getPendingPosts();
  Future<void> updatePendingPost(PendingPostEntity post);
  Future<void> deletePendingPost(String id);
}

@LazySingleton(as: ChatLocalDataSource)
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final AppDatabase _db;
  final ServerManager _serverManager;

  ChatLocalDataSourceImpl(this._db, this._serverManager);

  @override
  Future<void> cacheChannels(List<ChannelEntity> channels) async {
    await _db.batch((batch) {
      for (final channel in channels) {
        batch.insert(
          _db.cachedChannels,
          CachedChannelsCompanion.insert(
            serverId: _serverManager.activeServerUrl,
            id: channel.id,
            teamId: Value(channel.teamId),
            name: channel.name,
            displayName: channel.displayName,
            header: Value(channel.header),
            purpose: Value(channel.purpose),
            type: channel.type.value,
            lastPostAt: channel.lastPostAt,
            totalMsgCount: Value(channel.totalMsgCount),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<List<ChannelEntity>> getCachedChannels(String teamId) async {
    final query = _db.select(_db.cachedChannels)
      ..where(
        (tbl) =>
            tbl.teamId.equals(teamId) &
            tbl.serverId.equals(_serverManager.activeServerUrl),
      );
    final rows = await query.get();

    return rows
        .map(
          (row) => ChannelEntity(
            id: row.id,
            teamId: row.teamId,
            name: row.name,
            displayName: row.displayName,
            header: row.header,
            purpose: row.purpose,
            type: ChannelType.fromValue(row.type),
            lastPostAt: row.lastPostAt,
            totalMsgCount: row.totalMsgCount,
          ),
        )
        .toList();
  }

  @override
  Future<void> enqueuePendingAction(
    String actionType,
    Map<String, dynamic> payload,
  ) async {
    await _db
        .into(_db.pendingActions)
        .insert(
          PendingActionsCompanion.insert(
            serverId: _serverManager.activeServerUrl,
            actionType: actionType,
            payloadJson: jsonEncode(payload),
            createdAt: DateTime.now().millisecondsSinceEpoch,
          ),
        );
  }

  @override
  Future<void> cacheReactions(List<ReactionEntity> reactions) async {
    await _db.batch((batch) {
      for (final reaction in reactions) {
        batch.insert(
          _db.cachedReactions,
          CachedReactionsCompanion.insert(
            serverId: _serverManager.activeServerUrl,
            userId: reaction.userId,
            postId: reaction.postId,
            emojiName: reaction.emojiName,
            createAt: reaction.createAt,
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<Map<String, List<ReactionEntity>>> getCachedReactionsForPosts(
    List<String> postIds,
  ) async {
    if (postIds.isEmpty) return {};
    final query = (_db.select(_db.cachedReactions)
      ..where(
        (r) =>
            r.serverId.equals(_serverManager.activeServerUrl) &
            r.postId.isIn(postIds),
      ));
    final rows = await query.get();

    final byPost = <String, List<ReactionEntity>>{};
    for (final row in rows) {
      byPost.putIfAbsent(row.postId, () => []).add(
        ReactionEntity(
          serverId: row.serverId,
          userId: row.userId,
          postId: row.postId,
          emojiName: row.emojiName,
          createAt: row.createAt,
        ),
      );
    }
    return byPost;
  }

  @override
  Future<void> removeReaction(
    String userId,
    String postId,
    String emojiName,
  ) async {
    await (_db.delete(_db.cachedReactions)..where(
          (r) =>
              r.serverId.equals(_serverManager.activeServerUrl) &
              r.userId.equals(userId) &
              r.postId.equals(postId) &
              r.emojiName.equals(emojiName),
        ))
        .go();
  }

  @override
  Future<void> cacheUserStatuses(List<UserStatusEntity> statuses) async {
    await _db.batch((batch) {
      for (final status in statuses) {
        batch.insert(
          _db.cachedUserStatuses,
          CachedUserStatusesCompanion.insert(
            serverId: _serverManager.activeServerUrl,
            userId: status.userId,
            status: status.status.value,
            lastActivityAt: Value(status.lastActivityAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<void> cacheUsers(List<UserEntity> users) async {
    await _db.batch((batch) {
      for (final user in users) {
        batch.insert(
          _db.cachedUsers,
          CachedUsersCompanion.insert(
            serverId: _serverManager.activeServerUrl,
            id: user.id,
            username: user.username,
            email: user.email,
            firstName: Value(user.firstName),
            lastName: Value(user.lastName),
            nickname: Value(user.nickname),
            position: Value(user.position),
            roles: Value(user.roles),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  @override
  Future<List<UserEntity>> getCachedUsers() async {
    final rows = (_db.select(
      _db.cachedUsers,
    )..where((t) => t.serverId.equals(_serverManager.activeServerUrl))).get();
    return (await rows)
        .map(
          (row) => UserEntity(
            id: row.id,
            username: row.username,
            email: row.email,
            firstName: row.firstName,
            lastName: row.lastName,
            nickname: row.nickname,
            position: row.position,
            roles: row.roles,
          ),
        )
        .toList();
  }

  @override
  Future<List<Map<String, dynamic>>> getPendingActions({
    String status = 'pending',
  }) async {
    final query = (_db.select(_db.pendingActions)
      ..where(
        (a) =>
            a.serverId.equals(_serverManager.activeServerUrl) &
            a.status.equals(status),
      )
      ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]));
    final rows = await query.get();
    return rows
        .map(
          (row) => {
            'id': row.id,
            'actionType': row.actionType,
            'payload': jsonDecode(row.payloadJson) as Map<String, dynamic>,
            'createdAt': row.createdAt,
            'retryCount': row.retryCount,
          },
        )
        .toList();
  }

  @override
  Future<void> completePendingAction(int actionId) async {
    await (_db.update(_db.pendingActions)..where((a) => a.id.equals(actionId)))
        .write(PendingActionsCompanion(status: const Value('completed')));
  }

  @override
  Future<void> savePendingPost(PendingPostEntity post) async {
    await _db.into(_db.pendingPosts).insert(
      PendingPostsCompanion.insert(
        id: post.id,
        serverId: _serverManager.activeServerUrl,
        channelId: post.channelId,
        userId: '', // Will be filled if needed, or get from session
        message: post.message,
        rootId: Value(post.rootId),
        fileIds: Value(jsonEncode(post.fileIds)),
        createdAt: post.createdAt,
        lastAttemptAt: Value(post.lastAttemptAt),
        retryCount: Value(post.retryCount),
        status: Value(post.status.name),
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  @override
  Future<List<PendingPostEntity>> getPendingPosts() async {
    final query = _db.select(_db.pendingPosts)
      ..where((t) => t.serverId.equals(_serverManager.activeServerUrl));
    final rows = await query.get();

    return rows.map((row) {
      return PendingPostEntity(
        id: row.id,
        channelId: row.channelId,
        message: row.message,
        rootId: row.rootId,
        fileIds: (jsonDecode(row.fileIds) as List).cast<String>(),
        createdAt: row.createdAt,
        lastAttemptAt: row.lastAttemptAt,
        retryCount: row.retryCount,
        status: PendingPostStatus.values.firstWhere(
          (e) => e.name == row.status,
          orElse: () => PendingPostStatus.pending,
        ),
      );
    }).toList();
  }

  @override
  Future<void> updatePendingPost(PendingPostEntity post) async {
    await (_db.update(_db.pendingPosts)..where(
          (t) =>
              t.id.equals(post.id) &
              t.serverId.equals(_serverManager.activeServerUrl),
        ))
        .write(
          PendingPostsCompanion(
            status: Value(post.status.name),
            retryCount: Value(post.retryCount),
            lastAttemptAt: Value(post.lastAttemptAt),
          ),
        );
  }

  @override
  Future<void> deletePendingPost(String id) async {
    await (_db.delete(_db.pendingPosts)..where(
          (t) =>
              t.id.equals(id) &
              t.serverId.equals(_serverManager.activeServerUrl),
        ))
        .go();
  }
}
