import 'package:flutter_mattermost/features/common/domain/entities/recap_entity.dart';

final class RecapModel extends RecapEntity {
  const RecapModel({
    required super.id,
    required super.user_id,
    required super.title,
    required super.create_at,
    required super.update_at,
    required super.delete_at,
    required super.read_at,
    required super.viewed_at,
    required super.total_message_count,
    required super.status,
    required super.bot_id,
    required super.channels,
  });

  factory RecapModel.fromMap(Map<String, dynamic> map) {
    return RecapModel(
      id: map["id"] as String?,
      user_id: map["user_id"] as String?,
      title: map["title"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
      update_at: (map["update_at"] as num?)?.toInt(),
      delete_at: (map["delete_at"] as num?)?.toInt(),
      read_at: (map["read_at"] as num?)?.toInt(),
      viewed_at: (map["viewed_at"] as num?)?.toInt(),
      total_message_count: (map["total_message_count"] as num?)?.toInt(),
      status: map["status"] as String?,
      bot_id: map["bot_id"] as String?,
      channels: (map["channels"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": user_id,
      "title": title,
      "create_at": create_at,
      "update_at": update_at,
      "delete_at": delete_at,
      "read_at": read_at,
      "viewed_at": viewed_at,
      "total_message_count": total_message_count,
      "status": status,
      "bot_id": bot_id,
      "channels": channels,
    };
  }

  factory RecapModel.fromEntity(RecapEntity entity) {
    return RecapModel(
      id: entity.id,
      user_id: entity.user_id,
      title: entity.title,
      create_at: entity.create_at,
      update_at: entity.update_at,
      delete_at: entity.delete_at,
      read_at: entity.read_at,
      viewed_at: entity.viewed_at,
      total_message_count: entity.total_message_count,
      status: entity.status,
      bot_id: entity.bot_id,
      channels: entity.channels,
    );
  }

  @override
  RecapModel copyWith({
    String? id,
    String? user_id,
    String? title,
    int? create_at,
    int? update_at,
    int? delete_at,
    int? read_at,
    int? viewed_at,
    int? total_message_count,
    String? status,
    String? bot_id,
    List<Map<String, dynamic>>? channels,
  }) {
    return RecapModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      title: title ?? this.title,
      create_at: create_at ?? this.create_at,
      update_at: update_at ?? this.update_at,
      delete_at: delete_at ?? this.delete_at,
      read_at: read_at ?? this.read_at,
      viewed_at: viewed_at ?? this.viewed_at,
      total_message_count: total_message_count ?? this.total_message_count,
      status: status ?? this.status,
      bot_id: bot_id ?? this.bot_id,
      channels: channels ?? this.channels,
    );
  }

  RecapEntity toEntity() => RecapEntity(
        id: id,
        user_id: user_id,
        title: title,
        create_at: create_at,
        update_at: update_at,
        delete_at: delete_at,
        read_at: read_at,
        viewed_at: viewed_at,
        total_message_count: total_message_count,
        status: status,
        bot_id: bot_id,
        channels: channels,
      );
}
