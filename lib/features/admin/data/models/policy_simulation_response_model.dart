import 'package:flutter_mattermost/features/admin/domain/entities/policy_simulation_response_entity.dart';

final class PolicySimulationResponseModel extends PolicySimulationResponseEntity {
  const PolicySimulationResponseModel({
    required super.results,
    required super.total,
  });

  factory PolicySimulationResponseModel.fromMap(Map<String, dynamic> map) {
    return PolicySimulationResponseModel(
      results: (map["results"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      total: (map["total"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "results": results,
      "total": total,
    };
  }

  factory PolicySimulationResponseModel.fromEntity(PolicySimulationResponseEntity entity) {
    return PolicySimulationResponseModel(
      results: entity.results,
      total: entity.total,
    );
  }

  PolicySimulationResponseModel copyWith({
    List<Map<String, dynamic>>? results,
    int? total,
  }) {
    return PolicySimulationResponseModel(
      results: results ?? this.results,
      total: total ?? this.total,
    );
  }

  PolicySimulationResponseEntity toEntity() => PolicySimulationResponseEntity(
        results: results,
        total: total,
      );
}
