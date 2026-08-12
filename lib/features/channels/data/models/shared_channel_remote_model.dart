import 'package:flutter_mattermost/features/channels/domain/entities/shared_channel_remote_entity.dart';

final class SharedChannelRemoteModel extends SharedChannelRemoteEntity {
  const SharedChannelRemoteModel({
    required super.id,
    required super.channel_id,
    required super.creator_id,
    required super.create_at,
    required super.update_at,
    required super.delete_at,
    required super.is_invite_accepted,
    required super.is_invite_confirmed,
    required super.remote_id,
    required super.last_post_update_at,
    required super.last_post_id,
    required super.last_post_create_at,
    required super.last_post_create_id,
  });

  factory SharedChannelRemoteModel.fromMap(Map<String, dynamic> map) {
    return SharedChannelRemoteModel(
      id: map["id"] as String?,
      channel_id: map["channel_id"] as String?,
      creator_id: map["creator_id"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
      is_invite_accepted: map["is_invite_accepted"] as bool?,
      is_invite_confirmed: map["is_invite_confirmed"] as bool?,
      remote_id: map["remote_id"] as String?,
      last_post_update_at: (map["last_post_update_at"] as num?)?.toInt(),
      last_post_id: map["last_post_id"] as String?,
      last_post_create_at: map["last_post_create_at"] as String?,
      last_post_create_id: map["last_post_create_id"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "channel_id": channel_id,
      "creator_id": creator_id,
      "create_at": create_at,
      "update_at": update_at,
      "delete_at": delete_at,
      "is_invite_accepted": is_invite_accepted,
      "is_invite_confirmed": is_invite_confirmed,
      "remote_id": remote_id,
      "last_post_update_at": last_post_update_at,
      "last_post_id": last_post_id,
      "last_post_create_at": last_post_create_at,
      "last_post_create_id": last_post_create_id,
    };
  }

  factory SharedChannelRemoteModel.fromEntity(SharedChannelRemoteEntity entity) {
    return SharedChannelRemoteModel(
      id: entity.id,
      channel_id: entity.channel_id,
      creator_id: entity.creator_id,
      create_at: entity.create_at,
      update_at: entity.update_at,
      delete_at: entity.delete_at,
      is_invite_accepted: entity.is_invite_accepted,
      is_invite_confirmed: entity.is_invite_confirmed,
      remote_id: entity.remote_id,
      last_post_update_at: entity.last_post_update_at,
      last_post_id: entity.last_post_id,
      last_post_create_at: entity.last_post_create_at,
      last_post_create_id: entity.last_post_create_id,
    );
  }

  @override
  SharedChannelRemoteModel copyWith({
    String? id,
    String? channel_id,
    String? creator_id,
    int? create_at,
    int? update_at,
    int? delete_at,
    bool? is_invite_accepted,
    bool? is_invite_confirmed,
    String? remote_id,
    int? last_post_update_at,
    String? last_post_id,
    String? last_post_create_at,
    String? last_post_create_id,
  }) {
    return SharedChannelRemoteModel(
      id: id ?? this.id,
      channel_id: channel_id ?? this.channel_id,
      creator_id: creator_id ?? this.creator_id,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
      is_invite_accepted: is_invite_accepted ?? this.is_invite_accepted,
      is_invite_confirmed: is_invite_confirmed ?? this.is_invite_confirmed,
      remote_id: remote_id ?? this.remote_id,
      last_post_update_at: last_post_update_at ?? this.last_post_update_at,
      last_post_id: last_post_id ?? this.last_post_id,
      last_post_create_at: last_post_create_at ?? this.last_post_create_at,
      last_post_create_id: last_post_create_id ?? this.last_post_create_id,
    );
  }

  SharedChannelRemoteEntity toEntity() => SharedChannelRemoteEntity(
        id: id,
        channel_id: channel_id,
        creator_id: creator_id,
        create_at: create_at,
        update_at: update_at,
        delete_at: delete_at,
        is_invite_accepted: is_invite_accepted,
        is_invite_confirmed: is_invite_confirmed,
        remote_id: remote_id,
        last_post_update_at: last_post_update_at,
        last_post_id: last_post_id,
        last_post_create_at: last_post_create_at,
        last_post_create_id: last_post_create_id,
      );
}
