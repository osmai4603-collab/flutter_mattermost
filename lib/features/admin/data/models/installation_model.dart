import 'package:flutter_mattermost/features/admin/domain/entities/installation_entity.dart';

final class InstallationModel extends InstallationEntity {
  const InstallationModel({
    required super.id,
    required super.allowed_ip_ranges,
    required super.state,
  });

  factory InstallationModel.fromMap(Map<String, dynamic> map) {
    return InstallationModel(
      id: map["id"] as String?,
      allowed_ip_ranges: map["allowed_ip_ranges"] as Map<String, dynamic>?,
      state: map["state"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "allowed_ip_ranges": allowed_ip_ranges,
      "state": state,
    };
  }

  factory InstallationModel.fromEntity(InstallationEntity entity) {
    return InstallationModel(
      id: entity.id,
      allowed_ip_ranges: entity.allowed_ip_ranges,
      state: entity.state,
    );
  }

  InstallationModel copyWith({
    String? id,
    Map<String, dynamic>? allowed_ip_ranges,
    String? state,
  }) {
    return InstallationModel(
      id: id ?? this.id,
      allowed_ip_ranges: allowed_ip_ranges ?? this.allowed_ip_ranges,
      state: state ?? this.state,
    );
  }

  InstallationEntity toEntity() => InstallationEntity(
        id: id,
        allowed_ip_ranges: allowed_ip_ranges,
        state: state,
      );
}
