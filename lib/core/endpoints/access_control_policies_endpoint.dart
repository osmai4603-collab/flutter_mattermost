sealed class AccessControlPoliciesEndPoint {
  AccessControlPoliciesEndPoint._();

  static const String base = '/access_control_policies';
  static const String root = base;
  static const String activate = '$base/activate';
  static const String celAutocompleteFields = '$base/cel/autocomplete/fields';
  static const String celCheck = '$base/cel/check';
  static const String celSimulateUsers = '$base/cel/simulate_users';
  static const String celTest = '$base/cel/test';
  static const String celValidateRequester = '$base/cel/validate_requester';
  static const String celVisualAst = '$base/cel/visual_ast';
  static const String search = '$base/search';
  static String byPolicyId(String policyId) => '$base/$policyId';
  static String activate2(String policyId) => '$base/$policyId/activate';
  static String assign(String policyId) => '$base/$policyId/assign';
  static String resourcesChannels(String policyId) =>
      '$base/$policyId/resources/channels';
  static String resourcesChannelsSearch(String policyId) =>
      '$base/$policyId/resources/channels/search';
  static String unassign(String policyId) => '$base/$policyId/unassign';
}
