import 'package:flutter_mattermost/features/common/domain/entities/bridge_agent_info_entity.dart';

final class BridgeAgentInfoModel extends BridgeAgentInfoEntity {
  const BridgeAgentInfoModel({
    required super.id,
    required super.displayName,
    required super.username,
    required super.service_id,
    required super.service_type,
  });

  factory BridgeAgentInfoModel.fromMap(Map<String, dynamic> map) {
    return BridgeAgentInfoModel(
      id: map["id"] as String?,
      displayName: map["displayName"] as String?,
      username: map["username"] as String?,
      service_id: map["service_id"] as String?,
      service_type: map["service_type"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "displayName": displayName,
      "username": username,
      "service_id": service_id,
      "service_type": service_type,
    };
  }

  factory BridgeAgentInfoModel.fromEntity(BridgeAgentInfoEntity entity) {
    return BridgeAgentInfoModel(
      id: entity.id,
      displayName: entity.displayName,
      username: entity.username,
      service_id: entity.service_id,
      service_type: entity.service_type,
    );
  }

  @override
  BridgeAgentInfoModel copyWith({
    String? id,
    String? displayName,
    String? username,
    String? service_id,
    String? service_type,
  }) {
    return BridgeAgentInfoModel(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      service_id: service_id ?? this.service_id,
      service_type: service_type ?? this.service_type,
    );
  }

  BridgeAgentInfoEntity toEntity() => BridgeAgentInfoEntity(
        id: id,
        displayName: displayName,
        username: username,
        service_id: service_id,
        service_type: service_type,
      );
}
