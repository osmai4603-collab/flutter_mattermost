sealed class RecapsEndPoint {
  RecapsEndPoint._();

  static const String base = '/recaps';
  static const String root = base;
  static const String limitStatus = '$base/limit_status';
  static const String markViewed = '$base/mark_viewed';
  static String byRecapId(String recapId) => '$base/$recapId';
  static String read(String recapId) => '$base/$recapId/read';
  static String regenerate(String recapId) => '$base/$recapId/regenerate';
}
