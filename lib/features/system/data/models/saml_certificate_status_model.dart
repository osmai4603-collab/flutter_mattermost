import 'package:flutter_mattermost/features/system/domain/entities/saml_certificate_status_entity.dart';

final class SamlCertificateStatusModel extends SamlCertificateStatusEntity {
  const SamlCertificateStatusModel({
    required super.idp_certificate_file,
    required super.public_certificate_file,
    required super.private_key_file,
  });

  factory SamlCertificateStatusModel.fromMap(Map<String, dynamic> map) {
    return SamlCertificateStatusModel(
      idp_certificate_file: map["idp_certificate_file"] as bool?,
      public_certificate_file: map["public_certificate_file"] as bool?,
      private_key_file: map["private_key_file"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "idp_certificate_file": idp_certificate_file,
      "public_certificate_file": public_certificate_file,
      "private_key_file": private_key_file,
    };
  }

  factory SamlCertificateStatusModel.fromEntity(SamlCertificateStatusEntity entity) {
    return SamlCertificateStatusModel(
      idp_certificate_file: entity.idp_certificate_file,
      public_certificate_file: entity.public_certificate_file,
      private_key_file: entity.private_key_file,
    );
  }

  @override
  SamlCertificateStatusModel copyWith({
    bool? idp_certificate_file,
    bool? public_certificate_file,
    bool? private_key_file,
  }) {
    return SamlCertificateStatusModel(
      idp_certificate_file: idp_certificate_file ?? this.idp_certificate_file,
      public_certificate_file: public_certificate_file ?? this.public_certificate_file,
      private_key_file: private_key_file ?? this.private_key_file,
    );
  }

  SamlCertificateStatusEntity toEntity() => SamlCertificateStatusEntity(
        idp_certificate_file: idp_certificate_file,
        public_certificate_file: public_certificate_file,
        private_key_file: private_key_file,
      );
}
