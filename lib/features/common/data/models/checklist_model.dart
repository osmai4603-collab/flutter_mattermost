import 'package:flutter_mattermost/features/common/domain/entities/checklist_entity.dart';

final class ChecklistModel extends ChecklistEntity {
  const ChecklistModel({
    required super.id,
    required super.title,
    required super.items,
  });

  factory ChecklistModel.fromMap(Map<String, dynamic> map) {
    return ChecklistModel(
      id: map["id"] as String?,
      title: map["title"] as String?,
      items: (map["items"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "items": items,
    };
  }

  factory ChecklistModel.fromEntity(ChecklistEntity entity) {
    return ChecklistModel(
      id: entity.id,
      title: entity.title,
      items: entity.items,
    );
  }

  @override
  ChecklistModel copyWith({
    String? id,
    String? title,
    List<Map<String, dynamic>>? items,
  }) {
    return ChecklistModel(
      id: id ?? this.id,
      title: title ?? this.title,
      items: items ?? this.items,
    );
  }

  ChecklistEntity toEntity() => ChecklistEntity(
        id: id,
        title: title,
        items: items,
      );
}
