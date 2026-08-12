sealed class HooksEndPoint {
  HooksEndPoint._();

  static const String base = '/hooks';
  static const String incoming = '$base/incoming';
  static String incoming2(String hookId) => '$base/incoming/$hookId';
  static const String outgoing = '$base/outgoing';
  static String outgoing2(String hookId) => '$base/outgoing/$hookId';
  static String outgoingRegenToken(String hookId) =>
      '$base/outgoing/$hookId/regen_token';
}
