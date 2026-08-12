import 'package:flutter_mattermost/features/common/domain/entities/orphaned_record_entity.dart';

final class OrphanedRecordModel extends OrphanedRecordEntity {
  const OrphanedRecordModel({
    required super.parent_id,
    required super.child_id,
  });

  factory OrphanedRecordModel.fromMap(Map<String, dynamic> map) {
    return OrphanedRecordModel(
      parent_id: map["parent_id"] as String?,
      child_id: map["child_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "parent_id": parent_id,
      "child_id": child_id,
    };
  }

  factory OrphanedRecordModel.fromEntity(OrphanedRecordEntity entity) {
    return OrphanedRecordModel(
      parent_id: entity.parent_id,
      child_id: entity.child_id,
    );
  }

  @override
  OrphanedRecordModel copyWith({
    String? parent_id,
    String? child_id,
  }) {
    return OrphanedRecordModel(
      parent_id: parent_id ?? this.parent_id,
      child_id: child_id ?? this.child_id,
    );
  }

  OrphanedRecordEntity toEntity() => OrphanedRecordEntity(
        parent_id: parent_id,
        child_id: child_id,
      );
}
