import 'package:flutter_mattermost/features/admin/domain/entities/audit_entity.dart';

final class AuditModel extends AuditEntity {
  const AuditModel({
    super.id,
    super.createAt,
    super.userId,
    super.action,
    super.extraInfo,
    super.ipAddress,
    super.sessionId,
  });

  factory AuditModel.fromMap(Map<String, dynamic> data) {
    return AuditModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      userId: data['user_id'] ?? '',
      action: data['action'] ?? '',
      extraInfo: data['extra_info'] ?? '',
      ipAddress: data['ip_address'] ?? '',
      sessionId: data['session_id'] ?? '',
    );
  }

  factory AuditModel.fromEntity(AuditEntity entity) {
    return AuditModel(
      id: entity.id,
      createAt: entity.createAt,
      userId: entity.userId,
      action: entity.action,
      extraInfo: entity.extraInfo,
      ipAddress: entity.ipAddress,
      sessionId: entity.sessionId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'user_id': userId,
      'action': action,
      'extra_info': extraInfo,
      'ip_address': ipAddress,
      'session_id': sessionId,
    };
  }

  AuditModel copyWith({
    String? id,
    int? createAt,
    String? userId,
    String? action,
    String? extraInfo,
    String? ipAddress,
    String? sessionId,
  }) {
    return AuditModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      extraInfo: extraInfo ?? this.extraInfo,
      ipAddress: ipAddress ?? this.ipAddress,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  AuditEntity toEntity() {
    return AuditEntity(
      id: id,
      createAt: createAt,
      userId: userId,
      action: action,
      extraInfo: extraInfo,
      ipAddress: ipAddress,
      sessionId: sessionId,
    );
  }
}
