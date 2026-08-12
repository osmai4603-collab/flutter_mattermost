import 'package:flutter_mattermost/core/entities/entity.dart';

class ChannelJoinRequestEntity extends Entity {
  const ChannelJoinRequestEntity({
    required this.id,
    required this.channelId,
    required this.userId,
    required this.status,
    required this.createdAt,
    this.message = '',
    this.invitationId = '',
    this.joinUrlId = '',
    this.updatedAt = 0,
  });

  final String id;
  final String channelId;
  final String userId;
  final String status;
  final String message;
  final String invitationId;
  final String joinUrlId;
  final int createdAt;
  final int updatedAt;

  @override
  List<Object?> get props => [
    id,
    channelId,
    userId,
    status,
    message,
    invitationId,
    joinUrlId,
    createdAt,
    updatedAt,
  ];

  @override
  ChannelJoinRequestEntity copyWith({
    String? id,
    String? channelId,
    String? userId,
    String? status,
    String? message,
    String? invitationId,
    String? joinUrlId,
    int? createdAt,
    int? updatedAt,
  }) {
    return ChannelJoinRequestEntity(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      message: message ?? this.message,
      invitationId: invitationId ?? this.invitationId,
      joinUrlId: joinUrlId ?? this.joinUrlId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}