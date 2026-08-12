sealed class ConfigEndPoint {
  ConfigEndPoint._();

  static const String base = '/config';
  static const String root = base;
  static const String client = '$base/client';
  static const String environment = '$base/environment';
  static const String migrate = '$base/migrate';
  static const String patch = '$base/patch';
  static const String reload = '$base/reload';
}
