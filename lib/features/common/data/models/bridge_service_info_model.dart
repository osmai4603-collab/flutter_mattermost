import 'package:flutter_mattermost/features/common/domain/entities/bridge_service_info_entity.dart';

final class BridgeServiceInfoModel extends BridgeServiceInfoEntity {
  const BridgeServiceInfoModel({
    required super.id,
    required super.name,
    required super.type,
  });

  factory BridgeServiceInfoModel.fromMap(Map<String, dynamic> map) {
    return BridgeServiceInfoModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      type: map["type"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "type": type,
    };
  }

  factory BridgeServiceInfoModel.fromEntity(BridgeServiceInfoEntity entity) {
    return BridgeServiceInfoModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
    );
  }

  @override
  BridgeServiceInfoModel copyWith({
    String? id,
    String? name,
    String? type,
  }) {
    return BridgeServiceInfoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  BridgeServiceInfoEntity toEntity() => BridgeServiceInfoEntity(
        id: id,
        name: name,
        type: type,
      );
}
