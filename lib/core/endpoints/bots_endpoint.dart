sealed class BotsEndPoint {
  BotsEndPoint._();

  static const String base = '/bots';
  static const String root = base;
  static String byBotUserId(String botUserId) => '$base/$botUserId';
  static String assign(String botUserId, String userId) =>
      '$base/$botUserId/assign/$userId';
  static String convertToUser(String botUserId) =>
      '$base/$botUserId/convert_to_user';
  static String disable(String botUserId) => '$base/$botUserId/disable';
  static String enable(String botUserId) => '$base/$botUserId/enable';
}
