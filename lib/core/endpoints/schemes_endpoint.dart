sealed class SchemesEndPoint {
  SchemesEndPoint._();

  static const String base = '/schemes';
  static const String root = base;
  static String bySchemeId(String schemeId) => '$base/$schemeId';
  static String channels(String schemeId) => '$base/$schemeId/channels';
  static String patch(String schemeId) => '$base/$schemeId/patch';
  static String teams(String schemeId) => '$base/$schemeId/teams';
}
