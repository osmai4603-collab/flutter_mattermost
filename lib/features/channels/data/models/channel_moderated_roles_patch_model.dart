import 'package:flutter_mattermost/features/channels/domain/entities/channel_moderated_roles_patch_entity.dart';

final class ChannelModeratedRolesPatchModel extends ChannelModeratedRolesPatchEntity {
  const ChannelModeratedRolesPatchModel({
    required super.guests,
    required super.members,
  });

  factory ChannelModeratedRolesPatchModel.fromMap(Map<String, dynamic> map) {
    return ChannelModeratedRolesPatchModel(
      guests: map["guests"] as bool?,
      members: map["members"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "guests": guests,
      "members": members,
    };
  }

  factory ChannelModeratedRolesPatchModel.fromEntity(ChannelModeratedRolesPatchEntity entity) {
    return ChannelModeratedRolesPatchModel(
      guests: entity.guests,
      members: entity.members,
    );
  }

  @override
  ChannelModeratedRolesPatchModel copyWith({
    bool? guests,
    bool? members,
  }) {
    return ChannelModeratedRolesPatchModel(
      guests: guests ?? this.guests,
      members: members ?? this.members,
    );
  }

  ChannelModeratedRolesPatchEntity toEntity() => ChannelModeratedRolesPatchEntity(
        guests: guests,
        members: members,
      );
}
