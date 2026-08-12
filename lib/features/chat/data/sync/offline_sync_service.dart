import 'package:flutter_mattermost/features/chat/domain/repositories/post_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/chat_local_data_source.dart';

/// يعالج مهام Offline المعلقة (قائمة PendingActions) بإعادة إرسالها
/// للخادم وتحديث حالتها عند النجاح.
@lazySingleton
class OfflineSyncService {
  final ChatLocalDataSource _localDataSource;
  final PostRepository _postRepository;

  OfflineSyncService(this._localDataSource, this._postRepository);

  Future<int> syncPendingActions() async {
    final actions = await _localDataSource.getPendingActions();
    var synced = 0;

    for (final action in actions) {
      final type = action['actionType'] as String? ?? '';
      final payload = action['payload'] as Map<String, dynamic>;
      final actionId = action['id'] as int;

      try {
        if (type == 'CREATE_POST') {
          final channelId = payload['channel_id'] as String? ?? '';
          final message = payload['message'] as String? ?? '';
          final rootId = payload['root_id'] as String?;
          if (channelId.isEmpty || message.isEmpty) continue;
          await _postRepository.sendPost(channelId, message, rootId: rootId);
        } else {
          // أنواع غير مدعومة بعد (ADD_REACTION, ...) — نتخطى بصمت
          continue;
        }
        await _localDataSource.completePendingAction(actionId);
        synced++;
      } catch (e) {
        // نترك المهمة معلّقة لإعادة المحاولة لاحقاً.
      }
    }

    return synced;
  }
}
