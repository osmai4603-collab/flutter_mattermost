// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js';

/// Web-only implementation using the Browser Notification API via `dart:js`.
/// Selected only when building for the web (see conditional import in
/// local_notification_service.dart).
class WebNotifier {
  const WebNotifier();

  void requestNotificationPermission() {
    context.callMethod('eval', [
      """
      if (Notification.permission !== 'granted' && Notification.permission !== 'denied') {
        Notification.requestPermission();
      }
      """
    ]);
  }

  void showNotification(String title, String body) {
    context.callMethod('eval', [
      "if (Notification.permission === 'granted') { new Notification('$title', { body: '$body' }); }"
    ]);
  }
}
