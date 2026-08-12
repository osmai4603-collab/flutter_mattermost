sealed class NotificationsEndPoint {
  NotificationsEndPoint._();

  static const String base = '/notifications';
  static const String ack = '$base/ack';
  static const String test = '$base/test';
}
