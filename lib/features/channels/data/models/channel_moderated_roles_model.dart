import 'package:flutter_mattermost/features/channels/domain/entities/channel_moderated_roles_entity.dart';

final class ChannelModeratedRolesModel extends ChannelModeratedRolesEntity {
  const ChannelModeratedRolesModel({
    required super.guests,
    required super.members,
  });

  factory ChannelModeratedRolesModel.fromMap(Map<String, dynamic> map) {
    return ChannelModeratedRolesModel(
      guests: map["guests"] as Map<String, dynamic>?,
      members: map["members"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "guests": guests,
      "members": members,
    };
  }

  factory ChannelModeratedRolesModel.fromEntity(ChannelModeratedRolesEntity entity) {
    return ChannelModeratedRolesModel(
      guests: entity.guests,
      members: entity.members,
    );
  }

  @override
  ChannelModeratedRolesModel copyWith({
    Map<String, dynamic>? guests,
    Map<String, dynamic>? members,
  }) {
    return ChannelModeratedRolesModel(
      guests: guests ?? this.guests,
      members: members ?? this.members,
    );
  }

  ChannelModeratedRolesEntity toEntity() => ChannelModeratedRolesEntity(
        guests: guests,
        members: members,
      );
}
