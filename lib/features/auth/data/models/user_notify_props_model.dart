import 'package:flutter_mattermost/features/auth/domain/entities/user_notify_props_entity.dart';

final class UserNotifyPropsModel extends UserNotifyPropsEntity {
  const UserNotifyPropsModel({
    required super.email,
    required super.push,
    required super.desktop,
    required super.desktop_sound,
    required super.mention_keys,
    required super.channel,
    required super.first_name,
    required super.auto_responder_message,
    required super.push_threads,
    required super.comments,
    required super.desktop_threads,
    required super.email_threads,
  });

  factory UserNotifyPropsModel.fromMap(Map<String, dynamic> map) {
    return UserNotifyPropsModel(
      email: map["email"] as String?,
      push: map["push"] as String?,
      desktop: map["desktop"] as String?,
      desktop_sound: map["desktop_sound"] as String?,
      mention_keys: map["mention_keys"] as String?,
      channel: map["channel"] as String?,
      first_name: map["first_name"] as String?,
      auto_responder_message: map["auto_responder_message"] as String?,
      push_threads: map["push_threads"] as String?,
      comments: map["comments"] as String?,
      desktop_threads: map["desktop_threads"] as String?,
      email_threads: map["email_threads"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "push": push,
      "desktop": desktop,
      "desktop_sound": desktop_sound,
      "mention_keys": mention_keys,
      "channel": channel,
      "first_name": first_name,
      "auto_responder_message": auto_responder_message,
      "push_threads": push_threads,
      "comments": comments,
      "desktop_threads": desktop_threads,
      "email_threads": email_threads,
    };
  }

  factory UserNotifyPropsModel.fromEntity(UserNotifyPropsEntity entity) {
    return UserNotifyPropsModel(
      email: entity.email,
      push: entity.push,
      desktop: entity.desktop,
      desktop_sound: entity.desktop_sound,
      mention_keys: entity.mention_keys,
      channel: entity.channel,
      first_name: entity.first_name,
      auto_responder_message: entity.auto_responder_message,
      push_threads: entity.push_threads,
      comments: entity.comments,
      desktop_threads: entity.desktop_threads,
      email_threads: entity.email_threads,
    );
  }

  @override
  UserNotifyPropsModel copyWith({
    String? email,
    String? push,
    String? desktop,
    String? desktop_sound,
    String? mention_keys,
    String? channel,
    String? first_name,
    String? auto_responder_message,
    String? push_threads,
    String? comments,
    String? desktop_threads,
    String? email_threads,
  }) {
    return UserNotifyPropsModel(
      email: email ?? this.email,
      push: push ?? this.push,
      desktop: desktop ?? this.desktop,
      desktop_sound: desktop_sound ?? this.desktop_sound,
      mention_keys: mention_keys ?? this.mention_keys,
      channel: channel ?? this.channel,
      first_name: first_name ?? this.first_name,
      auto_responder_message: auto_responder_message ?? this.auto_responder_message,
      push_threads: push_threads ?? this.push_threads,
      comments: comments ?? this.comments,
      desktop_threads: desktop_threads ?? this.desktop_threads,
      email_threads: email_threads ?? this.email_threads,
    );
  }

  UserNotifyPropsEntity toEntity() => UserNotifyPropsEntity(
        email: email,
        push: push,
        desktop: desktop,
        desktop_sound: desktop_sound,
        mention_keys: mention_keys,
        channel: channel,
        first_name: first_name,
        auto_responder_message: auto_responder_message,
        push_threads: push_threads,
        comments: comments,
        desktop_threads: desktop_threads,
        email_threads: email_threads,
      );
}
