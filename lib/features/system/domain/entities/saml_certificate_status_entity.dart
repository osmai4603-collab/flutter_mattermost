import 'package:equatable/equatable.dart';

class SamlCertificateStatusEntity extends Equatable {
  final bool? idp_certificate_file;
  final bool? public_certificate_file;
  final bool? private_key_file;

  const SamlCertificateStatusEntity({
    this.idp_certificate_file,
    this.public_certificate_file,
    this.private_key_file,
  });

  @override
  List<Object?> get props => [
        idp_certificate_file,
        public_certificate_file,
        private_key_file,
      ];

  SamlCertificateStatusEntity copyWith({
    bool? idp_certificate_file,
    bool? public_certificate_file,
    bool? private_key_file,
  }) {
    return SamlCertificateStatusEntity(
      idp_certificate_file: idp_certificate_file ?? this.idp_certificate_file,
      public_certificate_file: public_certificate_file ?? this.public_certificate_file,
      private_key_file: private_key_file ?? this.private_key_file,
    );
  }
}
