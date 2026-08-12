import 'package:flutter_mattermost/features/common/domain/entities/playbook_list_entity.dart';

final class PlaybookListModel extends PlaybookListEntity {
  const PlaybookListModel({
    required super.total_count,
    required super.page_count,
    required super.has_more,
    required super.items,
  });

  factory PlaybookListModel.fromMap(Map<String, dynamic> map) {
    return PlaybookListModel(
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

  factory PlaybookListModel.fromEntity(PlaybookListEntity entity) {
    return PlaybookListModel(
      total_count: entity.total_count,
      page_count: entity.page_count,
      has_more: entity.has_more,
      items: entity.items,
    );
  }

  @override
  PlaybookListModel copyWith({
    int? total_count,
    int? page_count,
    bool? has_more,
    List<Map<String, dynamic>>? items,
  }) {
    return PlaybookListModel(
      total_count: total_count ?? this.total_count,
      page_count: page_count ?? this.page_count,
      has_more: has_more ?? this.has_more,
      items: items ?? this.items,
    );
  }

  PlaybookListEntity toEntity() => PlaybookListEntity(
        total_count: total_count,
        page_count: page_count,
        has_more: has_more,
        items: items,
      );
}
