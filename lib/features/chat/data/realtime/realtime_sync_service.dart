import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/websocket_client.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';

/// يشترك في أحداث WebSocket الفورية ويكتبها في قاعدة البيانات المحلية
/// حتى تبقى واجهة المستخدم متزامنة دون إعادة جلب كاملة.
@lazySingleton
class RealtimeSyncService {
  final WebSocketClientManager _wsClient;
  final ChatLocalDataSource _localDataSource;
  StreamSubscription<TypedWebSocketEvent>? _subscription;

  RealtimeSyncService(this._wsClient, this._localDataSource);

  /// يبدأ الاستماع لأحداث WebSocket (بلا اتصال — الاتصال عبر [WebSocketClientManager.connect]).
  void start() {
    if (_subscription != null) return;
    _subscription = _wsClient.eventStream.listen(_handleEvent);
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }

  void _handleEvent(TypedWebSocketEvent event) async {
    if (event is PostCreatedEvent) {
      await _localDataSource.cachePosts([event.post]);
    } else if (event is PostUpdatedEvent) {
      await _localDataSource.updateCachedPost(event.post);
    } else if (event is PostDeletedEvent) {
      await _localDataSource.markPostDeleted(event.postId);
    } else if (event is ReactionChangedEvent) {
      final entity = event.reaction;
      if (event.added) {
        await _localDataSource.cacheReactions([entity]);
      } else {
        await _localDataSource.removeReaction(
          entity.userId,
          entity.postId,
          entity.emojiName,
        );
      }
    } else if (event is UserPresenceEvent) {
      await _localDataSource.cacheUserStatuses([
        UserStatusEntity(
          serverId: '',
          userId: event.userId,
          status: event.status,
        ),
      ]);
    }
    // ChannelUpdatedEvent: يمكن الكتابة لاحقاً عند الحاجة لتحديث القنوات.
  }
}
