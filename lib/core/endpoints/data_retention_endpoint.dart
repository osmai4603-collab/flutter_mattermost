sealed class DataRetentionEndPoint {
  DataRetentionEndPoint._();

  static const String base = '/data_retention';
  static const String policies = '$base/policies';
  static String policies2(String policyId) => '$base/policies/$policyId';
  static String policiesChannels(String policyId) =>
      '$base/policies/$policyId/channels';
  static String policiesChannelsSearch(String policyId) =>
      '$base/policies/$policyId/channels/search';
  static String policiesTeams(String policyId) =>
      '$base/policies/$policyId/teams';
  static String policiesTeamsSearch(String policyId) =>
      '$base/policies/$policyId/teams/search';
  static const String policiesCount = '$base/policies_count';
  static const String policy = '$base/policy';
}
