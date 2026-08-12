import 'package:flutter_mattermost/features/channels/domain/entities/channel_moderation_patch_entity.dart';

final class ChannelModerationPatchModel extends ChannelModerationPatchEntity {
  const ChannelModerationPatchModel({
    required super.name,
    required super.roles,
  });

  factory ChannelModerationPatchModel.fromMap(Map<String, dynamic> map) {
    return ChannelModerationPatchModel(
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

  factory ChannelModerationPatchModel.fromEntity(ChannelModerationPatchEntity entity) {
    return ChannelModerationPatchModel(
      name: entity.name,
      roles: entity.roles,
    );
  }

  @override
  ChannelModerationPatchModel copyWith({
    String? name,
    Map<String, dynamic>? roles,
  }) {
    return ChannelModerationPatchModel(
      name: name ?? this.name,
      roles: roles ?? this.roles,
    );
  }

  ChannelModerationPatchEntity toEntity() => ChannelModerationPatchEntity(
        name: name,
        roles: roles,
      );
}
