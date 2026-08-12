sealed class ReportsEndPoint {
  ReportsEndPoint._();

  static const String base = '/reports';
  static const String posts = '$base/posts';
  static const String users = '$base/users';
  static const String usersCount = '$base/users/count';
  static const String usersExport = '$base/users/export';
}
