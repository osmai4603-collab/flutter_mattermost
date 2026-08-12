import 'package:flutter_mattermost/features/common/domain/entities/playbook_autofollows_entity.dart';

final class PlaybookAutofollowsModel extends PlaybookAutofollowsEntity {
  const PlaybookAutofollowsModel({
    required super.total_count,
    required super.items,
  });

  factory PlaybookAutofollowsModel.fromMap(Map<String, dynamic> map) {
    return PlaybookAutofollowsModel(
      total_count: (map["total_count"] as num?)?.toInt(),
      items: List<String>.from(map["items"] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "total_count": total_count,
      "items": items,
    };
  }

  factory PlaybookAutofollowsModel.fromEntity(PlaybookAutofollowsEntity entity) {
    return PlaybookAutofollowsModel(
      total_count: entity.total_count,
      items: entity.items,
    );
  }

  @override
  PlaybookAutofollowsModel copyWith({
    int? total_count,
    List<String>? items,
  }) {
    return PlaybookAutofollowsModel(
      total_count: total_count ?? this.total_count,
      items: items ?? this.items,
    );
  }

  PlaybookAutofollowsEntity toEntity() => PlaybookAutofollowsEntity(
        total_count: total_count,
        items: items,
      );
}
