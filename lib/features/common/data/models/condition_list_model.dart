import 'package:flutter_mattermost/features/common/domain/entities/condition_list_entity.dart';

final class ConditionListModel extends ConditionListEntity {
  const ConditionListModel({
    required super.total_count,
    required super.page_count,
    required super.has_more,
    required super.items,
  });

  factory ConditionListModel.fromMap(Map<String, dynamic> map) {
    return ConditionListModel(
      total_count: (map["total_count"] as num?)?.toInt(),
      page_count: (map["page_count"] as num?)?.toInt(),
      has_more: map["has_more"] as bool?,
      items: (map["items"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "total_count": total_count,
      "page_count": page_count,
      "has_more": has_more,
      "items": items,
    };
  }

  factory ConditionListModel.fromEntity(ConditionListEntity entity) {
    return ConditionListModel(
      total_count: entity.total_count,
      page_count: entity.page_count,
      has_more: entity.has_more,
      items: entity.items,
    );
  }

  @override
  ConditionListModel copyWith({
    int? total_count,
    int? page_count,
    bool? has_more,
    List<Map<String, dynamic>>? items,
  }) {
    return ConditionListModel(
      total_count: total_count ?? this.total_count,
      page_count: page_count ?? this.page_count,
      has_more: has_more ?? this.has_more,
      items: items ?? this.items,
    );
  }

  ConditionListEntity toEntity() => ConditionListEntity(
        total_count: total_count,
        page_count: page_count,
        has_more: has_more,
        items: items,
      );
}
