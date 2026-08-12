sealed class UploadsEndPoint {
  UploadsEndPoint._();

  static const String base = '/uploads';
  static const String root = base;
  static String byUploadId(String uploadId) => '$base/$uploadId';
}
