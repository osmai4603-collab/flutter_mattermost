import 'package:flutter_mattermost/features/admin/domain/entities/policy_simulation_session_entity.dart';

final class PolicySimulationSessionModel extends PolicySimulationSessionEntity {
  const PolicySimulationSessionModel({
    required super.device,
    required super.network,
    required super.last_active_at,
    required super.decisions,
    required super.attributes,
  });

  factory PolicySimulationSessionModel.fromMap(Map<String, dynamic> map) {
    return PolicySimulationSessionModel(
      device: map["device"] as String?,
      network: map["network"] as String?,
      last_active_at: (map["last_active_at"] as num?)?.toInt(),
      decisions: map["decisions"] as Map<String, dynamic>?,
      attributes: map["attributes"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "device": device,
      "network": network,
      "last_active_at": last_active_at,
      "decisions": decisions,
      "attributes": attributes,
    };
  }

  factory PolicySimulationSessionModel.fromEntity(PolicySimulationSessionEntity entity) {
    return PolicySimulationSessionModel(
      device: entity.device,
      network: entity.network,
      last_active_at: entity.last_active_at,
      decisions: entity.decisions,
      attributes: entity.attributes,
    );
  }

  PolicySimulationSessionModel copyWith({
    String? device,
    String? network,
    int? last_active_at,
    Map<String, dynamic>? decisions,
    Map<String, dynamic>? attributes,
  }) {
    return PolicySimulationSessionModel(
      device: device ?? this.device,
      network: network ?? this.network,
      last_active_at: last_active_at ?? this.last_active_at,
      decisions: decisions ?? this.decisions,
      attributes: attributes ?? this.attributes,
    );
  }

  PolicySimulationSessionEntity toEntity() => PolicySimulationSessionEntity(
        device: device,
        network: network,
        last_active_at: last_active_at,
        decisions: decisions,
        attributes: attributes,
      );
}
