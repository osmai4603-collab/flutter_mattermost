import 'package:flutter_mattermost/features/auth/domain/entities/mfa_entity.dart';

final class MfaModel extends MfaEntity {
  const MfaModel({
    super.secret,
    super.qrCode,
  });

  factory MfaModel.fromMap(Map<String, dynamic> data) {
    return MfaModel(
      secret: data['secret'] ?? '',
      qrCode: data['qr_code'] ?? '',
    );
  }

  factory MfaModel.fromEntity(MfaEntity entity) {
    return MfaModel(
      secret: entity.secret,
      qrCode: entity.qrCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'secret': secret,
      'qr_code': qrCode,
    };
  }

  @override
  MfaModel copyWith({
    String? secret,
    String? qrCode,
  }) {
    return MfaModel(
      secret: secret ?? this.secret,
      qrCode: qrCode ?? this.qrCode,
    );
  }

  MfaEntity toEntity() {
    return MfaEntity(
      secret: secret,
      qrCode: qrCode,
    );
  }
}
