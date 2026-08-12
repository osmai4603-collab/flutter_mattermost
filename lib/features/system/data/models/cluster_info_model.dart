import 'package:flutter_mattermost/features/system/domain/entities/cluster_info_entity.dart';

final class ClusterInfoModel extends ClusterInfoEntity {
  const ClusterInfoModel({
    required super.items,
  });

  factory ClusterInfoModel.fromMap(Map<String, dynamic> map) {
    return ClusterInfoModel(
      items: map["items"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "items": items,
    };
  }

  factory ClusterInfoModel.fromEntity(ClusterInfoEntity entity) {
    return ClusterInfoModel(
      items: entity.items,
    );
  }

  @override
  ClusterInfoModel copyWith({
    Map<String, dynamic>? items,
  }) {
    return ClusterInfoModel(
      items: items ?? this.items,
    );
  }

  ClusterInfoEntity toEntity() => ClusterInfoEntity(
        items: items,
      );
}
