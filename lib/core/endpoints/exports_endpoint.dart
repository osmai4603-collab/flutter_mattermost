sealed class ExportsEndPoint {
  ExportsEndPoint._();

  static const String base = '/exports';
  static const String root = base;
  static String byExportName(String exportName) => '$base/$exportName';
  static String presignUrl(String exportName) =>
      '$base/$exportName/presign-url';
}
