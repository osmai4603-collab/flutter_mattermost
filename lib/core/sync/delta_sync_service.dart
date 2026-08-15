import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_remote_data_sources.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

/// مزامنة تزايدية (Delta Sync) قائمة على `since`:
/// كل قناة تحفظ watermark في جدول [SyncMetadata]، وعند التزامن تُجلب
/// الرسائل الجديدة فقط منذ آخر مزامنة عبر `getPostsForChannel(since: ...)`.
///
/// تكملة للـ WebSocket: عند إعادة الاتصال باسترجاع الأحداث المفقودة
/// (connection_id + sequence_number) لا نحتاج لمزامنة كاملة، بينما عند
/// تغيّر connection_id أو فقدان السبك يطلب الخادم/العميل مزامنة كاملة.
@lazySingleton
class DeltaSyncService {
  final ChatLocalDataSource _localDataSource;
  final PostRemoteDataSource _postRemoteDataSource;
  final AuthRepository _authRepository;
  final AppDatabase _db;
  final ServerManager _serverManager;
  final TeamRepository _teamRepository;
  final WebSocketClientManager _webSocketClientManager;

  StreamSubscription<TypedWebSocketEvent>? _wsSubscription;
  bool _started = false;

  DeltaSyncService(
    this._localDataSource,
    this._postRemoteDataSource,
    this._authRepository,
    this._db,
    this._serverManager,
    this._teamRepository,
    this._webSocketClientManager,
  );

  /// يجلب قنوات المستخدم (كل الفرق) ويزامن رسائلها الجديدة منذ آخر
  /// مزامنة — يُستدعى عند تسجيل الدخول وبعد إعادة اتصال كاملة.
  Future<void> fullSync() async {
    final user = await _authRepository.getCurrentUser();
    if (user == null) return;

    try {
      final teams = await _teamRepository.getMyTeams();
      for (final team in teams) {
        final channels = await _localDataSource.getCachedChannels(team.id);
        for (final channel in channels) {
          await syncPosts(channel.id);
        }
      }
    } catch (e) {
      debugPrint('[delta_sync] fullSync failed: $e');
    }
  }

  /// مزامنة تزايدية لقناة واحدة: يُجلب كل ما تغيّر منذ آخر watermark
  /// ثم يُحدَّث watermark إلى آخر createAt مستلم.
  Future<void> syncPosts(String channelId) async {
    try {
      final since = await _getWatermark(channelId);
      final posts = await _postRemoteDataSource.getPostsForChannel(
        channelId,
        since: since,
        perPage: 200,
      );
      if (posts.isEmpty) return;

      await _localDataSource.cachePosts(
        posts.map((dto) => dto.toEntity()).toList(),
      );

      final maxCreateAt = posts
          .map((p) => p.createAt)
          .fold<int>(since, (max, v) => v > max ? v : max);
      await _saveWatermark(channelId, maxCreateAt);
    } catch (e) {
      debugPrint('[delta_sync] syncPosts($channelId) failed: $e');
    }
  }

  /// يحدّث watermark لقناة ما عند استلام أحداث realtime (posted/post_edited)
  /// حتى لا تُجلب هذه الرسائل مجدداً في المزامنة التالية.
  Future<void> advanceWatermark(String channelId, int createAt) async {
    final since = await _getWatermark(channelId);
    if (createAt > since) {
      await _saveWatermark(channelId, createAt);
    }
  }

  /// يبدأ الاستماع لأحداث الـ WebSocket للاستجابة لإعادة الاتصال
  /// ولمزامنة قنوات أُغفلت أثناء الانقطاع.
  void start() {
    if (_started) return;
    _started = true;
    _wsSubscription = _webSocketClientManager.eventStream.listen(_onEvent);
  }

  void stop() {
    _started = false;
    _wsSubscription?.cancel();
    _wsSubscription = null;
  }

  void _onEvent(TypedWebSocketEvent event) {
    // إعادة اتصال كاملة (تغيّر connection_id) → مزامنة كاملة.
    if (event is WebSocketReconnectedEvent && event.fullResync) {
      fullSync();
      return;
    }

    if (event is WebSocketSequenceGapEvent) {
      debugPrint('[delta_sync] gap detected, expected ${event.expectedSeq}, got ${event.receivedSeq}');
      // Trigger sync for all active/cached channels to fill potential gaps
      fullSync();
      return;
    }

    // رسالة جديدة/معدلة → تقدم watermark للقناة (بصمة createAt فقط،
    // بدون إعادة كتابة الرسالة — الكتابة تتم في RealtimeSyncService).
    if (event is PostCreatedEvent) {
      advanceWatermark(event.channelId, event.post.createAt);
    } else if (event is PostUpdatedEvent) {
      advanceWatermark(event.channelId, event.post.createAt);
    }
  }

  String _keyForChannel(String channelId) => 'posts_sync_$channelId';

  Future<int> _getWatermark(String channelId) async {
    final query = _db.select(_db.syncMetadata)
      ..where(
        (tbl) =>
            tbl.serverId.equals(_serverManager.activeServerUrl) &
            tbl.key.equals(_keyForChannel(channelId)),
      );
    final rows = await query.get();
    if (rows.isEmpty) return 0;
    return rows.first.lastSyncAt;
  }

  Future<void> _saveWatermark(String channelId, int value) async {
    await _db.into(_db.syncMetadata).insertOnConflictUpdate(
      SyncMetadataCompanion.insert(
        serverId: _serverManager.activeServerUrl,
        key: _keyForChannel(channelId),
        lastSyncAt: value,
      ),
    );
  }

  void dispose() {
    stop();
  }
}
