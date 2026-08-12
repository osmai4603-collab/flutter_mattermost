import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_without_id_entity.dart';

/// سياسة الاحتفاظ بالبيانات (DataRetentionPolicy):
/// جميع حقول DataRetentionPolicyWithoutId إضافة إلى المعرّف.
class DataRetentionPolicyEntity extends DataRetentionPolicyWithoutIdEntity {
  final String? id;

  const DataRetentionPolicyEntity({
    super.display_name,
    super.post_duration,
    this.id,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        id,
      ];

  @override
  DataRetentionPolicyEntity copyWith({
    String? display_name,
    int? post_duration,
    String? id,
  }) {
    return DataRetentionPolicyEntity(
      display_name: display_name ?? this.display_name,
      post_duration: post_duration ?? this.post_duration,
      id: id ?? this.id,
    );
  }
}
