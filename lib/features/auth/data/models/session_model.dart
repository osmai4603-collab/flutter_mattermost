import 'package:flutter_mattermost/features/auth/domain/entities/session_entity.dart';

final class SessionModel extends SessionEntity {
  const SessionModel({
    super.createAt,
    super.deviceId,
    super.voipDeviceId,
    super.expiresAt,
    super.id,
    super.isOauth,
    super.lastActivityAt,
    super.propsData,
    super.roles,
    super.teamMembers,
    super.token,
    required super.userId,
  });

  factory SessionModel.fromMap(Map<String, dynamic> data) {
    return SessionModel(
      createAt: (data['create_at'] ?? 0).toInt(),
      deviceId: data['device_id'] ?? '',
      voipDeviceId: data['voip_device_id'] ?? '',
      expiresAt: (data['expires_at'] ?? 0).toInt(),
      id: data['id'] ?? '',
      isOauth: data['is_oauth'] ?? false,
      lastActivityAt: (data['last_activity_at'] ?? 0).toInt(),
      propsData: Map<String, dynamic>.from(data['props'] ?? const {}),
      roles: data['roles'] ?? '',
      teamMembers: (data['team_members'] as List<dynamic>? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList(),
      token: data['token'] ?? '',
      userId: data['user_id'] ?? '',
    );
  }

  factory SessionModel.fromEntity(SessionEntity entity) {
    return SessionModel(
      createAt: entity.createAt,
      deviceId: entity.deviceId,
      voipDeviceId: entity.voipDeviceId,
      expiresAt: entity.expiresAt,
      id: entity.id,
      isOauth: entity.isOauth,
      lastActivityAt: entity.lastActivityAt,
      propsData: entity.propsData,
      roles: entity.roles,
      teamMembers: entity.teamMembers,
      token: entity.token,
      userId: entity.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'create_at': createAt,
      'device_id': deviceId,
      'voip_device_id': voipDeviceId,
      'expires_at': expiresAt,
      'id': id,
      'is_oauth': isOauth,
      'last_activity_at': lastActivityAt,
      'props': propsData,
      'roles': roles,
      'team_members': teamMembers,
      'token': token,
      'user_id': userId,
    };
  }

  @override
  SessionModel copyWith({
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
    return SessionModel(
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

  SessionEntity toEntity() {
    return SessionEntity(
      createAt: createAt,
      deviceId: deviceId,
      voipDeviceId: voipDeviceId,
      expiresAt: expiresAt,
      id: id,
      isOauth: isOauth,
      lastActivityAt: lastActivityAt,
      propsData: propsData,
      roles: roles,
      teamMembers: teamMembers,
      token: token,
      userId: userId,
    );
  }
}
