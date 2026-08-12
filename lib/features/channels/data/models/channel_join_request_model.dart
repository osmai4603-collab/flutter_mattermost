import 'package:flutter_mattermost/features/channels/domain/entities/channel_join_request_entity.dart';

final class ChannelJoinRequestModel extends ChannelJoinRequestEntity {
  const ChannelJoinRequestModel({
    required super.id,
    required super.channelId,
    required super.userId,
    required super.status,
    required super.createdAt,
    super.message,
    super.invitationId,
    super.joinUrlId,
    super.updatedAt,
  });

  factory ChannelJoinRequestModel.fromMap(Map<String, dynamic> data) {
    return ChannelJoinRequestModel(
      id: (data['id'] ?? '').toString(),
      channelId: (data['channel_id'] ?? '').toString(),
      userId: (data['user_id'] ?? '').toString(),
      status: (data['status'] ?? '').toString(),
      message: (data['message'] ?? '').toString(),
      invitationId: (data['invitation_id'] ?? '').toString(),
      joinUrlId: (data['join_url_id'] ?? '').toString(),
      createdAt: (data['create_at'] ?? 0).toInt(),
      updatedAt: (data['update_at'] ?? 0).toInt(),
    );
  }

  factory ChannelJoinRequestModel.fromEntity(
    ChannelJoinRequestEntity entity,
  ) {
    return ChannelJoinRequestModel(
      id: entity.id,
      channelId: entity.channelId,
      userId: entity.userId,
      status: entity.status,
      message: entity.message,
      invitationId: entity.invitationId,
      joinUrlId: entity.joinUrlId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'channel_id': channelId,
      'user_id': userId,
      'status': status,
      'message': message,
      'invitation_id': invitationId,
      'join_url_id': joinUrlId,
      'create_at': createdAt,
      'update_at': updatedAt,
    };
  }

  @override
  ChannelJoinRequestModel copyWith({
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
    return ChannelJoinRequestModel(
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

  ChannelJoinRequestEntity toEntity() => ChannelJoinRequestEntity(
    id: id,
    channelId: channelId,
    userId: userId,
    status: status,
    message: message,
    invitationId: invitationId,
    joinUrlId: joinUrlId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}