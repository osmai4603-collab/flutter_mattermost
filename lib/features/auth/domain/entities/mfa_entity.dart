import 'package:flutter_mattermost/core/entities/entity.dart';

class MfaEntity extends Entity {
  final String secret;
  final String qrCode;

  const MfaEntity({
    this.secret = '',
    this.qrCode = '',
  });

  @override
  List<Object?> get props => [secret, qrCode];

  MfaEntity copyWith({
    String? secret,
    String? qrCode,
  }) {
    return MfaEntity(
      secret: secret ?? this.secret,
      qrCode: qrCode ?? this.qrCode,
    );
  }
}
