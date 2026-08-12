sealed class ComplianceEndPoint {
  ComplianceEndPoint._();

  static const String base = '/compliance';
  static const String reports = '$base/reports';
  static String reports2(String reportId) => '$base/reports/$reportId';
  static String reportsDownload(String reportId) =>
      '$base/reports/$reportId/download';
}
