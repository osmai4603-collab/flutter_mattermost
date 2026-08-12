import 'package:flutter_mattermost/features/chat/domain/entities/recap_entity.dart';

final class RecapModel extends RecapEntity {
  const RecapModel({
    super.id,
    super.channelId,
    super.ownerId,
    super.postId,
    super.period,
    super.periodMonth,
    super.periodDay,
    super.message,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.readAt,
    super.viewedAt,
  });

  factory RecapModel.fromMap(Map<String, dynamic> data) {
    return RecapModel(
      id: data['id'] ?? '',
      channelId: data['channel_id'] ?? '',
      ownerId: data['owner_id'] ?? '',
      postId: data['post_id'] ?? '',
      period: data['period'] ?? '',
      periodMonth: (data['period_month'] ?? 0).toInt(),
      periodDay: (data['period_day'] ?? 0).toInt(),
      message: data['message'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      readAt: (data['read_at'] ?? 0).toInt(),
      viewedAt: (data['viewed_at'] ?? 0).toInt(),
    );
  }

  factory RecapModel.fromEntity(RecapEntity entity) {
    return RecapModel(
      id: entity.id,
      channelId: entity.channelId,
      ownerId: entity.ownerId,
      postId: entity.postId,
      period: entity.period,
      periodMonth: entity.periodMonth,
      periodDay: entity.periodDay,
      message: entity.message,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      readAt: entity.readAt,
      viewedAt: entity.viewedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'channel_id': channelId,
      'owner_id': ownerId,
      'post_id': postId,
      'period': period,
      'period_month': periodMonth,
      'period_day': periodDay,
      'message': message,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'read_at': readAt,
      'viewed_at': viewedAt,
    };
  }

  @override
  RecapModel copyWith({
    String? id,
    String? channelId,
    String? ownerId,
    String? postId,
    String? period,
    int? periodMonth,
    int? periodDay,
    String? message,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    int? readAt,
    int? viewedAt,
  }) {
    return RecapModel(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      ownerId: ownerId ?? this.ownerId,
      postId: postId ?? this.postId,
      period: period ?? this.period,
      periodMonth: periodMonth ?? this.periodMonth,
      periodDay: periodDay ?? this.periodDay,
      message: message ?? this.message,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      readAt: readAt ?? this.readAt,
      viewedAt: viewedAt ?? this.viewedAt,
    );
  }

  RecapEntity toEntity() {
    return RecapEntity(
      id: id,
      channelId: channelId,
      ownerId: ownerId,
      postId: postId,
      period: period,
      periodMonth: periodMonth,
      periodDay: periodDay,
      message: message,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      readAt: readAt,
      viewedAt: viewedAt,
    );
  }
}
