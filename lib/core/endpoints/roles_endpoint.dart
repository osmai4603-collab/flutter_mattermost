sealed class RolesEndPoint {
  RolesEndPoint._();

  static const String base = '/roles';
  static const String root = base;
  static String name(String roleName) => '$base/name/$roleName';
  static const String names = '$base/names';
  static String byRoleId(String roleId) => '$base/$roleId';
  static String patch(String roleId) => '$base/$roleId/patch';
}
