/// Stub used on non-web platforms. The real implementation lives in
/// [web_notifier_web.dart] and is selected via a conditional import
/// (`dart.library.js_interop`), so `dart:js` never leaks into native builds.
class WebNotifier {
  const WebNotifier();

  void requestNotificationPermission() {}

  void showNotification(String title, String body) {}
}
