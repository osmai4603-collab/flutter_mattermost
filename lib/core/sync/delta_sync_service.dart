import 'dart:async';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';

/// يتتبع watermark لكل قناة ويزوّده عند وصول أحداث realtime
/// لمنع إعادة جلب الرسائل القديمة عند المزامنة التالية.
@lazySingleton
class DeltaSyncService {
  final AppDatabase _db;
  final ServerManager _serverManager;
  final WebSocketClientManager _webSocketClientManager;

  StreamSubscription<TypedWebSocketEvent>? _wsSubscription;
  bool _started = false;

  DeltaSyncService(
    this._db,
    this._serverManager,
    this._webSocketClientManager,
  );

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
