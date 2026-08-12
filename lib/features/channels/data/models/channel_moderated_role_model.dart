import 'package:flutter_mattermost/features/channels/domain/entities/channel_moderated_role_entity.dart';

final class ChannelModeratedRoleModel extends ChannelModeratedRoleEntity {
  const ChannelModeratedRoleModel({
    required super.value,
    required super.enabled,
  });

  factory ChannelModeratedRoleModel.fromMap(Map<String, dynamic> map) {
    return ChannelModeratedRoleModel(
      value: map["value"] as bool?,
      enabled: map["enabled"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "value": value,
      "enabled": enabled,
    };
  }

  factory ChannelModeratedRoleModel.fromEntity(ChannelModeratedRoleEntity entity) {
    return ChannelModeratedRoleModel(
      value: entity.value,
      enabled: entity.enabled,
    );
  }

  @override
  ChannelModeratedRoleModel copyWith({
    bool? value,
    bool? enabled,
  }) {
    return ChannelModeratedRoleModel(
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }

  ChannelModeratedRoleEntity toEntity() => ChannelModeratedRoleEntity(
        value: value,
        enabled: enabled,
      );
}
