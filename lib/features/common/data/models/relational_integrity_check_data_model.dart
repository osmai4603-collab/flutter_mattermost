import 'package:flutter_mattermost/features/common/domain/entities/relational_integrity_check_data_entity.dart';

final class RelationalIntegrityCheckDataModel extends RelationalIntegrityCheckDataEntity {
  const RelationalIntegrityCheckDataModel({
    required super.parent_name,
    required super.child_name,
    required super.parent_id_attr,
    required super.child_id_attr,
    required super.records,
  });

  factory RelationalIntegrityCheckDataModel.fromMap(Map<String, dynamic> map) {
    return RelationalIntegrityCheckDataModel(
      parent_name: map["parent_name"] as String?,
      child_name: map["child_name"] as String?,
      parent_id_attr: map["parent_id_attr"] as String?,
      child_id_attr: map["child_id_attr"] as String?,
      records: (map["records"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "parent_name": parent_name,
      "child_name": child_name,
      "parent_id_attr": parent_id_attr,
      "child_id_attr": child_id_attr,
      "records": records,
    };
  }

  factory RelationalIntegrityCheckDataModel.fromEntity(RelationalIntegrityCheckDataEntity entity) {
    return RelationalIntegrityCheckDataModel(
      parent_name: entity.parent_name,
      child_name: entity.child_name,
      parent_id_attr: entity.parent_id_attr,
      child_id_attr: entity.child_id_attr,
      records: entity.records,
    );
  }

  @override
  RelationalIntegrityCheckDataModel copyWith({
    String? parent_name,
    String? child_name,
    String? parent_id_attr,
    String? child_id_attr,
    List<Map<String, dynamic>>? records,
  }) {
    return RelationalIntegrityCheckDataModel(
      parent_name: parent_name ?? this.parent_name,
      child_name: child_name ?? this.child_name,
      parent_id_attr: parent_id_attr ?? this.parent_id_attr,
      child_id_attr: child_id_attr ?? this.child_id_attr,
      records: records ?? this.records,
    );
  }

  RelationalIntegrityCheckDataEntity toEntity() => RelationalIntegrityCheckDataEntity(
        parent_name: parent_name,
        child_name: child_name,
        parent_id_attr: parent_id_attr,
        child_id_attr: child_id_attr,
        records: records,
      );
}
