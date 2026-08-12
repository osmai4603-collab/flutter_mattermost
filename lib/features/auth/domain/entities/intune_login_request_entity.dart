import 'package:equatable/equatable.dart';

class IntuneLoginRequestEntity extends Equatable {
  final String? access_token;
  final String? device_id;
  final String? voip_device_id;

  const IntuneLoginRequestEntity({
    required this.access_token,
    this.device_id,
    this.voip_device_id,
  });

  @override
  List<Object?> get props => [
        access_token,
        device_id,
        voip_device_id,
      ];

  IntuneLoginRequestEntity copyWith({
    String? access_token,
    String? device_id,
    String? voip_device_id,
  }) {
    return IntuneLoginRequestEntity(
      access_token: access_token ?? this.access_token,
      device_id: device_id ?? this.device_id,
      voip_device_id: voip_device_id ?? this.voip_device_id,
    );
  }
}
