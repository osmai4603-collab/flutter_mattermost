import 'package:flutter_mattermost/features/chat/domain/entities/draft_upsert_request_entity.dart';

final class DraftUpsertRequestModel extends DraftUpsertRequestEntity {
  const DraftUpsertRequestModel({
    required super.channel_id,
    required super.root_id,
    required super.message,
    required super.type,
    required super.props,
    required super.file_ids,
    required super.priority,
  });

  factory DraftUpsertRequestModel.fromMap(Map<String, dynamic> map) {
    return DraftUpsertRequestModel(
      channel_id: map["channel_id"] as String?,
      root_id: map["root_id"] as String?,
      message: map["message"] as String?,
      type: map["type"] as String?,
      props: map["props"] as Map<String, dynamic>?,
      file_ids: List<String>.from(map["file_ids"] as List<dynamic>? ?? []),
      priority: map["priority"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel_id": channel_id,
      "root_id": root_id,
      "message": message,
      "type": type,
      "props": props,
      "file_ids": file_ids,
      "priority": priority,
    };
  }

  factory DraftUpsertRequestModel.fromEntity(DraftUpsertRequestEntity entity) {
    return DraftUpsertRequestModel(
      channel_id: entity.channel_id,
      root_id: entity.root_id,
      message: entity.message,
      type: entity.type,
      props: entity.props,
      file_ids: entity.file_ids,
      priority: entity.priority,
    );
  }

  @override
  DraftUpsertRequestModel copyWith({
    String? channel_id,
    String? root_id,
    String? message,
    String? type,
    Map<String, dynamic>? props,
    List<String>? file_ids,
    Map<String, dynamic>? priority,
  }) {
    return DraftUpsertRequestModel(
      channel_id: channel_id ?? this.channel_id,
      root_id: root_id ?? this.root_id,
      message: message ?? this.message,
      type: type ?? this.type,
      props: props ?? this.props,
      file_ids: file_ids ?? this.file_ids,
      priority: priority ?? this.priority,
    );
  }

  DraftUpsertRequestEntity toEntity() => DraftUpsertRequestEntity(
        channel_id: channel_id,
        root_id: root_id,
        message: message,
        type: type,
        props: props,
        file_ids: file_ids,
        priority: priority,
      );
}
