import 'package:flutter_mattermost/features/channels/domain/entities/channel_notify_props_entity.dart';

final class ChannelNotifyPropsModel extends ChannelNotifyPropsEntity {
  const ChannelNotifyPropsModel({
    required super.email,
    required super.push,
    required super.desktop,
    required super.mark_unread,
  });

  factory ChannelNotifyPropsModel.fromMap(Map<String, dynamic> map) {
    return ChannelNotifyPropsModel(
      email: map["email"] as String?,
      push: map["push"] as String?,
      desktop: map["desktop"] as String?,
      mark_unread: map["mark_unread"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "push": push,
      "desktop": desktop,
      "mark_unread": mark_unread,
    };
  }

  factory ChannelNotifyPropsModel.fromEntity(ChannelNotifyPropsEntity entity) {
    return ChannelNotifyPropsModel(
      email: entity.email,
      push: entity.push,
      desktop: entity.desktop,
      mark_unread: entity.mark_unread,
    );
  }

  @override
  ChannelNotifyPropsModel copyWith({
    String? email,
    String? push,
    String? desktop,
    String? mark_unread,
  }) {
    return ChannelNotifyPropsModel(
      email: email ?? this.email,
      push: push ?? this.push,
      desktop: desktop ?? this.desktop,
      mark_unread: mark_unread ?? this.mark_unread,
    );
  }

  ChannelNotifyPropsEntity toEntity() => ChannelNotifyPropsEntity(
        email: email,
        push: push,
        desktop: desktop,
        mark_unread: mark_unread,
      );
}
