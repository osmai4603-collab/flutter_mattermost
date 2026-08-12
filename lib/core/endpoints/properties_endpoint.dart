sealed class PropertiesEndPoint {
  PropertiesEndPoint._();

  static const String base = '/properties';
  static String groupsFieldsSearch(String groupName) =>
      '$base/groups/$groupName/fields/search';
  static String groupsSystemValues(String groupName) =>
      '$base/groups/$groupName/system/values';
  static String groupsFields(String groupName, String objectType) =>
      '$base/groups/$groupName/$objectType/fields';
  static String groupsFields2(
    String groupName,
    String objectType,
    String fieldId,
  ) => '$base/groups/$groupName/$objectType/fields/$fieldId';
  static String groupsValues(
    String groupName,
    String objectType,
    String targetId,
  ) => '$base/groups/$groupName/$objectType/values/$targetId';
}
