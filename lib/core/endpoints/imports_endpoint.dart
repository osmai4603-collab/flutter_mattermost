sealed class ImportsEndPoint {
  ImportsEndPoint._();

  static const String base = '/imports';
  static const String root = base;
  static String byImportName(String importName) => '$base/$importName';
}
