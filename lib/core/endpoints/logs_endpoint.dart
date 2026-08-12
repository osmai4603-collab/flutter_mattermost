sealed class LogsEndPoint {
  LogsEndPoint._();

  static const String base = '/logs';
  static const String root = base;
  static const String download = '$base/download';
  static const String query = '$base/query';
}
