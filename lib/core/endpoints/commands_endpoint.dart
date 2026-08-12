sealed class CommandsEndPoint {
  CommandsEndPoint._();

  static const String base = '/commands';
  static const String root = base;
  static const String execute = '$base/execute';
  static String byCommandId(String commandId) => '$base/$commandId';
  static String move(String commandId) => '$base/$commandId/move';
  static String regenToken(String commandId) => '$base/$commandId/regen_token';
}
