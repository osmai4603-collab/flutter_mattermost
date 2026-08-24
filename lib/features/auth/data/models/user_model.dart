import 'package:flutter_mattermost/core/utils/printing.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';

final class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    required super.username,
    super.firstName,
    super.lastName,
    super.nickname,
    required super.email,
    super.emailVerified,
    super.authService,
    super.roles,
    super.locale,
    super.notifyProps,
    super.propsData,
    super.lastPasswordUpdate,
    super.lastPictureUpdate,
    super.failedAttempts,
    super.mfaActive,
    super.timezone,
    super.termsOfServiceId,
    super.termsOfServiceCreateAt,
    super.position,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    if (data['id'] == 'd8pcxbz1ejyhtm8bfg1jypycyo') {
      printMap(title: 'UserModel.fromMap: ', data: data);
    }
    return UserModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      username: data['username'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      nickname: data['nickname'] ?? '',
      email: data['email'] ?? '',
      emailVerified: data['email_verified'] ?? false,
      authService: data['auth_service'] ?? '',
      roles: data['roles'] ?? 'system_user',
      locale: data['locale'] ?? '',
      notifyProps: UserNotifyPropsModel.fromMap(
        data['notify_props'] ?? const {},
      ),
      propsData: Map<String, dynamic>.from(data['props'] ?? const {}),
      lastPasswordUpdate: (data['last_password_update'] ?? 0).toInt(),
      lastPictureUpdate: (data['last_picture_update'] ?? 0).toInt(),
      failedAttempts: (data['failed_attempts'] ?? 0).toInt(),
      mfaActive: data['mfa_active'] ?? false,
      timezone: UserTimezoneModel.fromMap(data['timezone'] ?? const {}),
      termsOfServiceId: data['terms_of_service_id'] ?? '',
      termsOfServiceCreateAt: (data['terms_of_service_create_at'] ?? 0).toInt(),
      position: data['position'] ?? '',
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      username: entity.username,
      firstName: entity.firstName,
      lastName: entity.lastName,
      nickname: entity.nickname,
      email: entity.email,
      emailVerified: entity.emailVerified,
      authService: entity.authService,
      roles: entity.roles,
      locale: entity.locale,
      notifyProps: entity.notifyProps,
      propsData: entity.propsData,
      lastPasswordUpdate: entity.lastPasswordUpdate,
      lastPictureUpdate: entity.lastPictureUpdate,
      failedAttempts: entity.failedAttempts,
      mfaActive: entity.mfaActive,
      timezone: entity.timezone,
      termsOfServiceId: entity.termsOfServiceId,
      termsOfServiceCreateAt: entity.termsOfServiceCreateAt,
      position: entity.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'username': username,
      'first_name': firstName,
      'last_name': lastName,
      'nickname': nickname,
      'email': email,
      'email_verified': emailVerified,
      'auth_service': authService,
      'roles': roles,
      'locale': locale,
      'notify_props': notifyProps,
      'props': propsData,
      'last_password_update': lastPasswordUpdate,
      'last_picture_update': lastPictureUpdate,
      'failed_attempts': failedAttempts,
      'mfa_active': mfaActive,
      'timezone': timezone,
      'terms_of_service_id': termsOfServiceId,
      'terms_of_service_create_at': termsOfServiceCreateAt,
      'position': position,
    };
  }

  @override
  UserModel copyWith({
    String? id,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? username,
    String? firstName,
    String? lastName,
    String? nickname,
    String? email,
    bool? emailVerified,
    String? authService,
    String? roles,
    String? locale,
    UserNotifyPropsEntity? notifyProps,
    Map<String, dynamic>? propsData,
    int? lastPasswordUpdate,
    int? lastPictureUpdate,
    int? failedAttempts,
    bool? mfaActive,
    UserTimezone? timezone,
    String? termsOfServiceId,
    int? termsOfServiceCreateAt,
    String? position,
  }) {
    return UserModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      emailVerified: emailVerified ?? this.emailVerified,
      authService: authService ?? this.authService,
      roles: roles ?? this.roles,
      locale: locale ?? this.locale,
      notifyProps: notifyProps ?? this.notifyProps,
      propsData: propsData ?? this.propsData,
      lastPasswordUpdate: lastPasswordUpdate ?? this.lastPasswordUpdate,
      lastPictureUpdate: lastPictureUpdate ?? this.lastPictureUpdate,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      mfaActive: mfaActive ?? this.mfaActive,
      timezone: timezone ?? this.timezone,
      termsOfServiceId: termsOfServiceId ?? this.termsOfServiceId,
      termsOfServiceCreateAt:
          termsOfServiceCreateAt ?? this.termsOfServiceCreateAt,
      position: position ?? this.position,
    );
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      username: username,
      firstName: firstName,
      lastName: lastName,
      nickname: nickname,
      email: email,
      emailVerified: emailVerified,
      authService: authService,
      roles: roles,
      locale: locale,
      notifyProps: notifyProps,
      propsData: propsData,
      lastPasswordUpdate: lastPasswordUpdate,
      lastPictureUpdate: lastPictureUpdate,
      failedAttempts: failedAttempts,
      mfaActive: mfaActive,
      timezone: timezone,
      termsOfServiceId: termsOfServiceId,
      termsOfServiceCreateAt: termsOfServiceCreateAt,
      position: position,
    );
  }
}

class UserNotifyPropsModel extends UserNotifyPropsEntity {
  const UserNotifyPropsModel({
    required super.channel,
    required super.channelMentionAutoFollowThreads,
    required super.comments,
    required super.desktop,
    required super.desktopSound,
    required super.desktopThreads,
    required super.email,
    required super.emailThreads,
    required super.firstName,
    required super.mentionKeys,
    required super.push,
    required super.pushStatus,
    required super.pushThreads,
  });

  factory UserNotifyPropsModel.fromMap(Map<String, dynamic> data) {
    return UserNotifyPropsModel(
      channel: data['channel']?.toString() == 'true',
      channelMentionAutoFollowThreads:
          data['channel_mention_auto_follow_threads']?.toString() == 'true',
      comments: data['comments'] as String? ?? '',
      desktop: data['desktop'] as String? ?? 'all',
      desktopSound: data['desktop_sound']?.toString() != 'false',
      desktopThreads: data['desktop_threads'] as String? ?? 'all',
      email: data['email']?.toString() != 'false',
      emailThreads: data['email_threads'] as String? ?? 'all',
      firstName: data['first_name']?.toString() != 'false',
      mentionKeys: data['mention_keys'] as String? ?? '',
      push: PushType.of(data['push'] as String? ?? 'mention'),
      pushStatus: PushStatus.of(data['push_status'] as String? ?? 'online'),
      pushThreads: data['push_threads'] as String? ?? 'all',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'channel': channel.toString(),
      'channel_mention_auto_follow_threads': channelMentionAutoFollowThreads
          .toString(),
      'comments': comments,
      'desktop': desktop,
      'desktop_sound': desktopSound.toString(),
      'desktop_threads': desktopThreads,
      'email': email.toString(),
      'email_threads': emailThreads,
      'first_name': firstName.toString(),
      'mention_keys': mentionKeys,
      'push': push,
      'push_status': pushStatus,
      'push_threads': pushThreads,
    };
  }

  static UserNotifyPropsModel fromEntity(UserNotifyPropsEntity entity) {
    return UserNotifyPropsModel(
      channel: entity.channel,
      channelMentionAutoFollowThreads: entity.channelMentionAutoFollowThreads,
      desktop: entity.desktop,
      desktopSound: entity.desktopSound,
      desktopThreads: entity.desktopThreads,
      email: entity.email,
      emailThreads: entity.emailThreads,
      firstName: entity.firstName,
      mentionKeys: entity.mentionKeys,
      push: entity.push,
      pushStatus: entity.pushStatus,
      pushThreads: entity.pushThreads,
      comments: entity.comments,
    );
  }
}

class UserTimezoneModel extends UserTimezone {
  const UserTimezoneModel({
    required super.automaticTimezone,
    required super.manualTimezone,
    required super.useAutomaticTimezone,
  });

  factory UserTimezoneModel.fromMap(Map<String, dynamic> data) {
    return UserTimezoneModel(
      automaticTimezone: (data['automaticTimezone'] as String?) == 'true',
      manualTimezone: data['manualTimezone'] as String? ?? '',
      useAutomaticTimezone: (data['useAutomaticTimezone'] as String?) == 'true',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'automaticTimezone': automaticTimezone,
      'manualTimezone': manualTimezone,
      'useAutomaticTimezone': useAutomaticTimezone.toString(),
    };
  }
}
