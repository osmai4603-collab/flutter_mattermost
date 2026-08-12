import 'package:flutter_mattermost/core/entities/entity.dart';

class AuditEntity extends Entity {
  final String id;
  final int createAt;
  final String userId;
  final String action;
  final String extraInfo;
  final String ipAddress;
  final String sessionId;

  const AuditEntity({
    this.id = '',
    this.createAt = 0,
    this.userId = '',
    this.action = '',
    this.extraInfo = '',
    this.ipAddress = '',
    this.sessionId = '',
  });

  @override
  List<Object?> get props => [
        id,
        createAt,
        userId,
        action,
        extraInfo,
        ipAddress,
        sessionId,
      ];

  AuditEntity copyWith({
    String? id,
    int? createAt,
    String? userId,
    String? action,
    String? extraInfo,
    String? ipAddress,
    String? sessionId,
  }) {
    return AuditEntity(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      extraInfo: extraInfo ?? this.extraInfo,
      ipAddress: ipAddress ?? this.ipAddress,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  DateTime? get createAtDate => createAt != 0
      ? DateTime.fromMillisecondsSinceEpoch(createAt).toLocal()
      : null;
}
