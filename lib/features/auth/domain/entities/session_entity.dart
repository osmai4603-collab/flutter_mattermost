import 'package:flutter_mattermost/core/entities/entity.dart';

class SessionEntity extends Entity {
  final int createAt;
  final String deviceId;
  final String voipDeviceId;
  final int expiresAt;
  final String id;
  final bool isOauth;
  final int lastActivityAt;
  final Map<String, dynamic> propsData;
  final String roles;
  final List<Map<String, dynamic>> teamMembers;
  final String token;
  final String userId;

  const SessionEntity({
    this.createAt = 0,
    this.deviceId = '',
    this.voipDeviceId = '',
    this.expiresAt = 0,
    this.id = '',
    this.isOauth = false,
    this.lastActivityAt = 0,
    this.propsData = const {},
    this.roles = '',
    this.teamMembers = const [],
    this.token = '',
    required this.userId,
  });

  @override
  List<Object?> get props => [
        createAt,
        deviceId,
        voipDeviceId,
        expiresAt,
        id,
        isOauth,
        lastActivityAt,
        propsData,
        roles,
        teamMembers,
        token,
        userId,
      ];

  SessionEntity copyWith({
    int? createAt,
    String? deviceId,
    String? voipDeviceId,
    int? expiresAt,
    String? id,
    bool? isOauth,
    int? lastActivityAt,
    Map<String, dynamic>? propsData,
    String? roles,
    List<Map<String, dynamic>>? teamMembers,
    String? token,
    String? userId,
  }) {
    return SessionEntity(
      createAt: createAt ?? this.createAt,
      deviceId: deviceId ?? this.deviceId,
      voipDeviceId: voipDeviceId ?? this.voipDeviceId,
      expiresAt: expiresAt ?? this.expiresAt,
      id: id ?? this.id,
      isOauth: isOauth ?? this.isOauth,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      propsData: propsData ?? this.propsData,
      roles: roles ?? this.roles,
      teamMembers: teamMembers ?? this.teamMembers,
      token: token ?? this.token,
      userId: userId ?? this.userId,
    );
  }
}
