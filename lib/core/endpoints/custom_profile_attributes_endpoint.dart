sealed class CustomProfileAttributesEndPoint {
  CustomProfileAttributesEndPoint._();

  static const String base = '/custom_profile_attributes';
  static const String fields = '$base/fields';
  static String fields2(String fieldId) => '$base/fields/$fieldId';
  static const String group = '$base/group';
  static const String values = '$base/values';
}
