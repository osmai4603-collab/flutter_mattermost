import 'package:flutter_mattermost/features/channels/domain/entities/view_with_count_entity.dart';

final class ViewWithCountModel extends ViewWithCountEntity {
  const ViewWithCountModel({
    super.views,
    super.total_count,
  });

  factory ViewWithCountModel.fromMap(Map<String, dynamic> map) {
    return ViewWithCountModel(
      views: (map["views"] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList(),
      total_count: (map["total_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "views": views,
      "total_count": total_count,
    };
  }

  factory ViewWithCountModel.fromEntity(ViewWithCountEntity entity) {
    return ViewWithCountModel(
      views: entity.views,
      total_count: entity.total_count,
    );
  }

  @override
  ViewWithCountModel copyWith({
    List<Map<String, dynamic>>? views,
    int? total_count,
  }) {
    return ViewWithCountModel(
      views: views ?? this.views,
      total_count: total_count ?? this.total_count,
    );
  }

  ViewWithCountEntity toEntity() => ViewWithCountEntity(
        views: views,
        total_count: total_count,
      );
}
