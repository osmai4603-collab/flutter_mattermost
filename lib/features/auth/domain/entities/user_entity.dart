import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/permissions/enums/mattermost_permission.dart';
import 'package:flutter_mattermost/core/permissions/enums/mattermost_role.dart';

class UserEntity extends Entity {
  final String id;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String username;
  final String firstName;
  final String lastName;
  final String nickname;
  final String email;
  final bool emailVerified;
  final String authService;
  final String roles;
  final String locale;
  final UserNotifyPropsEntity notifyProps;
  final Map<String, dynamic> propsData;
  final int lastPasswordUpdate;
  final int lastPictureUpdate;
  final int failedAttempts;
  final bool mfaActive;
  final UserTimezone timezone;
  final String termsOfServiceId;
  final int termsOfServiceCreateAt;
  final String position;

  const UserEntity({
    required this.id,
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.username = '',
    this.firstName = '',
    this.lastName = '',
    this.nickname = '',
    this.email = '',
    this.emailVerified = false,
    this.authService = '',
    this.roles = 'system_user',
    this.locale = '',
    this.notifyProps = const UserNotifyPropsEntity(),
    this.propsData = const {},
    this.lastPasswordUpdate = 0,
    this.lastPictureUpdate = 0,
    this.failedAttempts = 0,
    this.mfaActive = false,
    this.timezone = const UserTimezone(),
    this.termsOfServiceId = '',
    this.termsOfServiceCreateAt = 0,
    this.position = '',
  });

  bool get isActive => deleteAt == 0;

  @override
  List<Object?> get props => [
    id,
    createAt,
    updateAt,
    deleteAt,
    username,
    firstName,
    lastName,
    nickname,
    email,
    emailVerified,
    authService,
    roles,
    locale,
    notifyProps,
    propsData,
    lastPasswordUpdate,
    lastPictureUpdate,
    failedAttempts,
    mfaActive,
    timezone,
    termsOfServiceId,
    termsOfServiceCreateAt,
    position,
  ];

  UserEntity copyWith({
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
    return UserEntity(
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

  bool hasPermission(MMPermission permission) {
    final roles = this.roles
        .split(' ')
        .map((role) => MMRole.of(role)!)
        .toList();
    return roles.any((role) => role.hasPermission(permission));
  }

  bool hasAnyPermissions(Set<MMPermission> permissions) {
    final roles = this.roles
        .split(' ')
        .map((role) => MMRole.of(role)!)
        .toList();
    return roles.any((role) => role.hasAnyPermissions(permissions));
  }

  bool hasAllPermissions(List<MMPermission> permissions) {
    final roles = this.roles
        .split(' ')
        .map((role) => MMRole.of(role)!)
        .toList();
    return roles.any((role) => role.hasAllPermissions(permissions));
  }

  bool hasRole(MMRole role) {
    return roles.contains(role.value);
  }
}

class UserNotifyPropsEntity extends Entity {
  final bool channel;
  final bool channelMentionAutoFollowThreads;
  final String comments;
  final String desktop;
  final bool desktopSound;
  final String desktopThreads;
  final bool email;
  final String emailThreads;
  final bool firstName;
  final String mentionKeys;
  final PushType push;
  final PushStatus pushStatus;
  final String pushThreads;

  const UserNotifyPropsEntity({
    this.channel = false,
    this.channelMentionAutoFollowThreads = false,
    this.comments = '',
    this.desktop = 'all',
    this.desktopSound = true,
    this.desktopThreads = 'all',
    this.email = true,
    this.emailThreads = 'all',
    this.firstName = true,
    this.mentionKeys = '',
    this.push = .mention,
    this.pushStatus = .online,
    this.pushThreads = 'all',
  });

  @override
  List<Object?> get props => [
    channel,
    channelMentionAutoFollowThreads,
    comments,
    desktop,
    desktopSound,
    desktopThreads,
    email,
    emailThreads,
    firstName,
    push,
    pushStatus,
    pushThreads,
  ];

  UserNotifyPropsEntity copyWith({
    bool? channel,
    bool? channelMentionAutoFollowThreads,
    String? comments,
    String? desktop,
    bool? desktopSound,
    String? desktopThreads,
    bool? email,
    String? emailThreads,
    bool? firstName,
    String? mentionKeys,
    PushType? push,
    PushStatus? pushStatus,
    String? pushThreads,
  }) {
    return UserNotifyPropsEntity(
      channel: channel ?? this.channel,
      channelMentionAutoFollowThreads:
          channelMentionAutoFollowThreads ??
          this.channelMentionAutoFollowThreads,
      comments: comments ?? this.comments,
      desktop: desktop ?? this.desktop,
      desktopSound: desktopSound ?? this.desktopSound,
      desktopThreads: desktopThreads ?? this.desktopThreads,
      email: email ?? this.email,
      emailThreads: emailThreads ?? this.emailThreads,
      firstName: firstName ?? this.firstName,
      mentionKeys: mentionKeys ?? this.mentionKeys,
      push: push ?? this.push,
      pushStatus: pushStatus ?? this.pushStatus,
      pushThreads: pushThreads ?? this.pushThreads,
    );
  }
}

class UserTimezone extends Entity {
  final bool automaticTimezone;
  final String manualTimezone;
  final bool useAutomaticTimezone;

  const UserTimezone({
    this.automaticTimezone = false,
    this.manualTimezone = '',
    this.useAutomaticTimezone = true,
  });

  @override
  List<Object?> get props => [
    automaticTimezone,
    manualTimezone,
    useAutomaticTimezone,
  ];

  UserTimezone copyWith({
    bool? automaticTimezone,
    String? manualTimezone,
    bool? useAutomaticTimezone,
  }) {
    return UserTimezone(
      automaticTimezone: automaticTimezone ?? this.automaticTimezone,
      manualTimezone: manualTimezone ?? this.manualTimezone,
      useAutomaticTimezone: useAutomaticTimezone ?? this.useAutomaticTimezone,
    );
  }
}

enum PushType {
  mention,
  all,
  none;

  static PushType of(String value) {
    return values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw Exception('Can not find PushType of:$value'),
    );
  }

  @override
  String toString() {
    return name;
  }
}

enum PushStatus {
  online;

  static PushStatus of(String value) {
    return values.firstWhere(
      (type) => type.name == value,
      orElse: () => throw Exception('Can not find PushStatus of:$value'),
    );
  }

  @override
  String toString() {
    return name;
  }
}

class UserPropsDataEntity extends Entity {
  final String emoji;
  final String text;
  final String duration;
  final DateTime expiresAt;

  const UserPropsDataEntity({
    required this.emoji,
    required this.text,
    required this.duration,
    required this.expiresAt,
  });

  UserPropsDataEntity copyWith({
    String? emoji,
    String? text,
    String? duration,
    DateTime? expiresAt,
  }) {
    return UserPropsDataEntity(
      emoji: emoji ?? this.emoji,
      text: text ?? this.text,
      duration: duration ?? this.duration,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  List<Object?> get props => [emoji, text, duration, expiresAt];
}
