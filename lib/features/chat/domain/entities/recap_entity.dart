import 'package:flutter_mattermost/core/entities/entity.dart';

class RecapEntity extends Entity {
  final String id;
  final String channelId;
  final String ownerId;
  final String postId;
  final String period;
  final int periodMonth;
  final int periodDay;
  final String message;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final int readAt;
  final int viewedAt;

  const RecapEntity({
    this.id = '',
    this.channelId = '',
    this.ownerId = '',
    this.postId = '',
    this.period = '',
    this.periodMonth = 0,
    this.periodDay = 0,
    this.message = '',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.readAt = 0,
    this.viewedAt = 0,
  });

  @override
  List<Object?> get props => [
        id,
        channelId,
        ownerId,
        postId,
        period,
        periodMonth,
        periodDay,
        message,
        createAt,
        updateAt,
        deleteAt,
        readAt,
        viewedAt,
      ];

  @override
  RecapEntity copyWith({
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
    return RecapEntity(
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

  bool get isRead => readAt > 0;

  DateTime? get createAtDate => createAt != 0
      ? DateTime.fromMillisecondsSinceEpoch(createAt).toLocal()
      : null;
}
