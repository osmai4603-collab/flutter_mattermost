import 'package:flutter_mattermost/app/routes/app_router.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NotificationPayloadHandler {
  Future<void> handlePayload(Map<String, dynamic> data) async {
    final type = data['type'] as String?;
    
    if (type == 'post') {
      final channelId = data['channelId'] as String?;
      if (channelId != null) {
        appRouter.push('/channels/$channelId');
      }
    } else if (type == 'call') {
      final channelId = data['channelId'] as String?;
      if (channelId != null) {
        // Navigate to call screen or channel
        appRouter.push('/channels/$channelId');
      }
    }
  }
}
