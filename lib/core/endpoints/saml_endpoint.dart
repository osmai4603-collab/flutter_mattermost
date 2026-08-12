sealed class SamlEndPoint {
  SamlEndPoint._();

  static const String base = '/saml';
  static const String certificateIdp = '$base/certificate/idp';
  static const String certificatePrivate = '$base/certificate/private';
  static const String certificatePublic = '$base/certificate/public';
  static const String certificateStatus = '$base/certificate/status';
  static const String metadata = '$base/metadata';
  static const String metadatafromidp = '$base/metadatafromidp';
  static const String resetAuthData = '$base/reset_auth_data';
}
