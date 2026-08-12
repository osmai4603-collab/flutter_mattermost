import 'package:flutter_mattermost/features/channels/domain/entities/view_patch_entity.dart';

final class ViewPatchModel extends ViewPatchEntity {
  const ViewPatchModel({
    required super.title,
    required super.description,
    required super.sort_order,
    required super.props,
  });

  factory ViewPatchModel.fromMap(Map<String, dynamic> map) {
    return ViewPatchModel(
      title: map["title"] as String?,
      description: map["description"] as String?,
      sort_order: (map["sort_order"] as num?)?.toInt(),
      props: map["props"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "sort_order": sort_order,
      "props": props,
    };
  }

  factory ViewPatchModel.fromEntity(ViewPatchEntity entity) {
    return ViewPatchModel(
      title: entity.title,
      description: entity.description,
      sort_order: entity.sort_order,
      props: entity.props,
    );
  }

  @override
  ViewPatchModel copyWith({
    String? title,
    String? description,
    int? sort_order,
    Map<String, dynamic>? props,
  }) {
    return ViewPatchModel(
      title: title ?? this.title,
      description: description ?? this.description,
      sort_order: sort_order ?? this.sort_order,
      props: props ?? this.props,
    );
  }

  ViewPatchEntity toEntity() => ViewPatchEntity(
        title: title,
        description: description,
        sort_order: sort_order,
        props: props,
      );
}
