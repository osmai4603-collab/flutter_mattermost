import 'package:flutter_mattermost/features/common/domain/entities/condition_entity.dart';

final class ConditionModel extends ConditionEntity {
  const ConditionModel({
    required super.id,
    required super.condition_expr,
    required super.version,
    required super.playbook_id,
    required super.run_id,
    required super.create_at,
    required super.update_at,
  });

  factory ConditionModel.fromMap(Map<String, dynamic> map) {
    return ConditionModel(
      id: map["id"] as String?,
      condition_expr: map["condition_expr"] as Map<String, dynamic>?,
      version: (map["version"] as num?)?.toInt(),
      playbook_id: map["playbook_id"] as String?,
      run_id: map["run_id"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "condition_expr": condition_expr,
      "version": version,
      "playbook_id": playbook_id,
      "run_id": run_id,
      "create_at": create_at,
      "update_at": update_at,
    };
  }

  factory ConditionModel.fromEntity(ConditionEntity entity) {
    return ConditionModel(
      id: entity.id,
      condition_expr: entity.condition_expr,
      version: entity.version,
      playbook_id: entity.playbook_id,
      run_id: entity.run_id,
      create_at: entity.create_at,
      update_at: entity.update_at,
    );
  }

  @override
  ConditionModel copyWith({
    String? id,
    Map<String, dynamic>? condition_expr,
    int? version,
    String? playbook_id,
    String? run_id,
    int? create_at,
    int? update_at,
  }) {
    return ConditionModel(
      id: id ?? this.id,
      condition_expr: condition_expr ?? this.condition_expr,
      version: version ?? this.version,
      playbook_id: playbook_id ?? this.playbook_id,
      run_id: run_id ?? this.run_id,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
    );
  }

  ConditionEntity toEntity() => ConditionEntity(
        id: id,
        condition_expr: condition_expr,
        version: version,
        playbook_id: playbook_id,
        run_id: run_id,
        create_at: create_at,
        update_at: update_at,
      );
}
