import 'package:flutter_mattermost/features/auth/domain/entities/intune_login_request_entity.dart';

final class IntuneLoginRequestModel extends IntuneLoginRequestEntity {
  const IntuneLoginRequestModel({
    required super.access_token,
    required super.device_id,
    required super.voip_device_id,
  });

  factory IntuneLoginRequestModel.fromMap(Map<String, dynamic> map) {
    return IntuneLoginRequestModel(
      access_token: map["access_token"] as String?,
      device_id: map["device_id"] as String?,
      voip_device_id: map["voip_device_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "access_token": access_token,
      "device_id": device_id,
      "voip_device_id": voip_device_id,
    };
  }

  factory IntuneLoginRequestModel.fromEntity(IntuneLoginRequestEntity entity) {
    return IntuneLoginRequestModel(
      access_token: entity.access_token,
      device_id: entity.device_id,
      voip_device_id: entity.voip_device_id,
    );
  }

  @override
  IntuneLoginRequestModel copyWith({
    String? access_token,
    String? device_id,
    String? voip_device_id,
  }) {
    return IntuneLoginRequestModel(
      access_token: access_token ?? this.access_token,
      device_id: device_id ?? this.device_id,
      voip_device_id: voip_device_id ?? this.voip_device_id,
    );
  }

  IntuneLoginRequestEntity toEntity() => IntuneLoginRequestEntity(
        access_token: access_token,
        device_id: device_id,
        voip_device_id: voip_device_id,
      );
}
