sealed class FilesEndPoint {
  FilesEndPoint._();

  static const String base = '/files';
  static const String root = base;
  static const String search = '$base/search';
  static String byFileId(String fileId) => '$base/$fileId';
  static String info(String fileId) => '$base/$fileId/info';
  static String link(String fileId) => '$base/$fileId/link';
  static String preview(String fileId) => '$base/$fileId/preview';
  static String public(String fileId) => '../files/$fileId/public';
  static String thumbnail(String fileId) => '$base/$fileId/thumbnail';
}
