sealed class LicenseEndPoint {
  LicenseEndPoint._();

  static const String base = '/license';
  static const String root = base;
  static const String client = '$base/client';
  static const String loadMetric = '$base/load_metric';
  static const String preview = '$base/preview';
}
