import 'package:flutter_mattermost/features/channels/domain/entities/channel_moderation_entity.dart';

final class ChannelModerationModel extends ChannelModerationEntity {
  const ChannelModerationModel({
    required super.name,
    required super.roles,
  });

  factory ChannelModerationModel.fromMap(Map<String, dynamic> map) {
    return ChannelModerationModel(
      name: map["name"] as String?,
      roles: map["roles"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "roles": roles,
    };
  }

  factory ChannelModerationModel.fromEntity(ChannelModerationEntity entity) {
    return ChannelModerationModel(
      name: entity.name,
      roles: entity.roles,
    );
  }

  @override
  ChannelModerationModel copyWith({
    String? name,
    Map<String, dynamic>? roles,
  }) {
    return ChannelModerationModel(
      name: name ?? this.name,
      roles: roles ?? this.roles,
    );
  }

  ChannelModerationEntity toEntity() => ChannelModerationEntity(
        name: name,
        roles: roles,
      );
}
