import 'package:flutter_mattermost/features/integrations/domain/entities/outgoing_o_auth_connection_get_item_entity.dart';

final class OutgoingOAuthConnectionGetItemModel extends OutgoingOAuthConnectionGetItemEntity {
  const OutgoingOAuthConnectionGetItemModel({
    required super.id,
    required super.name,
    required super.create_at,
    required super.update_at,
    required super.grant_type,
    required super.audiences,
  });

  factory OutgoingOAuthConnectionGetItemModel.fromMap(Map<String, dynamic> map) {
    return OutgoingOAuthConnectionGetItemModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      grant_type: map["grant_type"] as String?,
      audiences: map["audiences"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "create_at": create_at,
      "update_at": update_at,
      "grant_type": grant_type,
      "audiences": audiences,
    };
  }

  factory OutgoingOAuthConnectionGetItemModel.fromEntity(OutgoingOAuthConnectionGetItemEntity entity) {
    return OutgoingOAuthConnectionGetItemModel(
      id: entity.id,
      name: entity.name,
      create_at: entity.create_at,
      update_at: entity.update_at,
      grant_type: entity.grant_type,
      audiences: entity.audiences,
    );
  }

  @override
  OutgoingOAuthConnectionGetItemModel copyWith({
    String? id,
    String? name,
    int? create_at,
    int? update_at,
    String? grant_type,
    String? audiences,
  }) {
    return OutgoingOAuthConnectionGetItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      grant_type: grant_type ?? this.grant_type,
      audiences: audiences ?? this.audiences,
    );
  }

  OutgoingOAuthConnectionGetItemEntity toEntity() => OutgoingOAuthConnectionGetItemEntity(
        id: id,
        name: name,
        create_at: create_at,
        update_at: update_at,
        grant_type: grant_type,
        audiences: audiences,
      );
}
