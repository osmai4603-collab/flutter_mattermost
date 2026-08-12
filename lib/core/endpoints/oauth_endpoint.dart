sealed class OAuthEndPoint {
  OAuthEndPoint._();

  static const String base = '/oauth';
  static const String apps = '$base/apps';
  static const String appsRegister = '$base/apps/register';
  static String apps2(String appId) => '$base/apps/$appId';
  static String appsInfo(String appId) => '$base/apps/$appId/info';
  static String appsRegenSecret(String appId) =>
      '$base/apps/$appId/regen_secret';
  static const String outgoingConnections = '$base/outgoing_connections';
  static const String outgoingConnectionsValidate =
      '$base/outgoing_connections/validate';
  static String outgoingConnections2(String outgoingOauthConnectionId) =>
      '$base/outgoing_connections/$outgoingOauthConnectionId';
  static const String intune = '../oauth/intune';
  static const String authorizationServerMetadata =
      '../.well-known/oauth-authorization-server';
}
