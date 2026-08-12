import 'package:flutter_mattermost/features/channels/domain/entities/shared_channel_entity.dart';

final class SharedChannelModel extends SharedChannelEntity {
  const SharedChannelModel({
    required super.id,
    required super.team_id,
    required super.home,
    required super.readonly,
    required super.name,
    required super.display_name,
    required super.purpose,
    required super.header,
    required super.creator_id,
    required super.create_at,
    required super.update_at,
    required super.remote_id,
  });

  factory SharedChannelModel.fromMap(Map<String, dynamic> map) {
    return SharedChannelModel(
      id: map["id"] as String?,
      team_id: map["team_id"] as String?,
      home: map["home"] as bool?,
      readonly: map["readonly"] as bool?,
      name: map["name"] as String?,
      display_name: map["display_name"] as String?,
      purpose: map["purpose"] as String?,
      header: map["header"] as String?,
      creator_id: map["creator_id"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      remote_id: map["remote_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "team_id": team_id,
      "home": home,
      "readonly": readonly,
      "name": name,
      "display_name": display_name,
      "purpose": purpose,
      "header": header,
      "creator_id": creator_id,
      "create_at": create_at,
      "update_at": update_at,
      "remote_id": remote_id,
    };
  }

  factory SharedChannelModel.fromEntity(SharedChannelEntity entity) {
    return SharedChannelModel(
      id: entity.id,
      team_id: entity.team_id,
      home: entity.home,
      readonly: entity.readonly,
      name: entity.name,
      display_name: entity.display_name,
      purpose: entity.purpose,
      header: entity.header,
      creator_id: entity.creator_id,
      create_at: entity.create_at,
      update_at: entity.update_at,
      remote_id: entity.remote_id,
    );
  }

  @override
  SharedChannelModel copyWith({
    String? id,
    String? team_id,
    bool? home,
    bool? readonly,
    String? name,
    String? display_name,
    String? purpose,
    String? header,
    String? creator_id,
    int? create_at,
    int? update_at,
    String? remote_id,
  }) {
    return SharedChannelModel(
      id: id ?? this.id,
      team_id: team_id ?? this.team_id,
      home: home ?? this.home,
      readonly: readonly ?? this.readonly,
      name: name ?? this.name,
      display_name: display_name ?? this.display_name,
      purpose: purpose ?? this.purpose,
      header: header ?? this.header,
      creator_id: creator_id ?? this.creator_id,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      remote_id: remote_id ?? this.remote_id,
    );
  }

  SharedChannelEntity toEntity() => SharedChannelEntity(
        id: id,
        team_id: team_id,
        home: home,
        readonly: readonly,
        name: name,
        display_name: display_name,
        purpose: purpose,
        header: header,
        creator_id: creator_id,
        create_at: create_at,
        update_at: update_at,
        remote_id: remote_id,
      );
}
