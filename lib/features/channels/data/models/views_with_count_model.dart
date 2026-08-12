import 'package:flutter_mattermost/features/channels/domain/entities/views_with_count_entity.dart';

final class ViewsWithCountModel extends ViewsWithCountEntity {
  const ViewsWithCountModel({
    required super.views,
    required super.total_count,
  });

  factory ViewsWithCountModel.fromMap(Map<String, dynamic> map) {
    return ViewsWithCountModel(
      views: (map["views"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      total_count: (map["total_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "views": views,
      "total_count": total_count,
    };
  }

  factory ViewsWithCountModel.fromEntity(ViewsWithCountEntity entity) {
    return ViewsWithCountModel(
      views: entity.views,
      total_count: entity.total_count,
    );
  }

  @override
  ViewsWithCountModel copyWith({
    List<Map<String, dynamic>>? views,
    int? total_count,
  }) {
    return ViewsWithCountModel(
      views: views ?? this.views,
      total_count: total_count ?? this.total_count,
    );
  }

  ViewsWithCountEntity toEntity() => ViewsWithCountEntity(
        views: views,
        total_count: total_count,
      );
}
