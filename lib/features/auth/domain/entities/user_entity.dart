import 'package:flutter_mattermost/core/entities/entity.dart';

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
  final Map<String, dynamic> notifyProps;
  final Map<String, dynamic> propsData;
  final int lastPasswordUpdate;
  final int lastPictureUpdate;
  final int failedAttempts;
  final bool mfaActive;
  final Map<String, dynamic> timezone;
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
    this.notifyProps = const {},
    this.propsData = const {},
    this.lastPasswordUpdate = 0,
    this.lastPictureUpdate = 0,
    this.failedAttempts = 0,
    this.mfaActive = false,
    this.timezone = const {},
    this.termsOfServiceId = '',
    this.termsOfServiceCreateAt = 0,
    this.position = '',
  });

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
    Map<String, dynamic>? notifyProps,
    Map<String, dynamic>? propsData,
    int? lastPasswordUpdate,
    int? lastPictureUpdate,
    int? failedAttempts,
    bool? mfaActive,
    Map<String, dynamic>? timezone,
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
      termsOfServiceCreateAt: termsOfServiceCreateAt ?? this.termsOfServiceCreateAt,
      position: position ?? this.position,
    );
  }
}
