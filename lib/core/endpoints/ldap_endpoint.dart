sealed class LdapEndPoint {
  LdapEndPoint._();

  static const String base = '/ldap';
  static const String certificatePrivate = '$base/certificate/private';
  static const String certificatePublic = '$base/certificate/public';
  static const String groups = '$base/groups';
  static String groupsLink(String remoteId) => '$base/groups/$remoteId/link';
  static const String migrateid = '$base/migrateid';
  static const String sync = '$base/sync';
  static const String test = '$base/test';
  static const String testConnection = '$base/test_connection';
  static const String testDiagnostics = '$base/test_diagnostics';
  static String usersGroupSyncMemberships(String userId) =>
      '$base/users/$userId/group_sync_memberships';
}
