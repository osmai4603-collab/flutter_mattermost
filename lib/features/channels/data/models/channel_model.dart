import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';

final class ChannelModel extends ChannelEntity {
  const ChannelModel({
    required super.id,
    required super.createAt,
    required super.updateAt,
    required super.deleteAt,
    required super.teamId,
    required super.type,
    required super.displayName,
    required super.name,
    required super.header,
    required super.purpose,
    required super.lastPostAt,
    required super.totalMsgCount,
    required super.extraUpdateAt,
    required super.creatorId,
  });

  factory ChannelModel.fromMap(Map<String, dynamic> data) {
    return ChannelModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      teamId: data['team_id'] ?? '',
      type: ChannelType.fromValue(data['type'] ?? 'O'),
      displayName: data['display_name'] ?? '',
      name: data['name'] ?? '',
      header: data['header'] ?? '',
      purpose: data['purpose'] ?? '',
      lastPostAt: (data['last_post_at'] ?? 0).toInt(),
      totalMsgCount: (data['total_msg_count'] ?? 0).toInt(),
      extraUpdateAt: (data['extra_update_at'] ?? 0).toInt(),
      creatorId: data['creator_id'] ?? '',
    );
  }

  factory ChannelModel.fromEntity(ChannelEntity entity) {
    return ChannelModel(
      id: entity.id,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      teamId: entity.teamId,
      type: entity.type,
      displayName: entity.displayName,
      name: entity.name,
      header: entity.header,
      purpose: entity.purpose,
      lastPostAt: entity.lastPostAt,
      totalMsgCount: entity.totalMsgCount,
      extraUpdateAt: entity.extraUpdateAt,
      creatorId: entity.creatorId,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'team_id': teamId,
      'type': type.value,
      'display_name': displayName,
      'name': name,
      'header': header,
      'purpose': purpose,
      'last_post_at': lastPostAt,
      'total_msg_count': totalMsgCount,
      'extra_update_at': extraUpdateAt,
      'creator_id': creatorId,
    };
  }

  @override
  ChannelModel copyWith({
    String? id,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    String? teamId,
    ChannelType? type,
    String? displayName,
    String? name,
    String? header,
    String? purpose,
    int? lastPostAt,
    int? totalMsgCount,
    int? extraUpdateAt,
    String? creatorId,
  }) {
    return ChannelModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      teamId: teamId ?? this.teamId,
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      name: name ?? this.name,
      header: header ?? this.header,
      purpose: purpose ?? this.purpose,
      lastPostAt: lastPostAt ?? this.lastPostAt,
      totalMsgCount: totalMsgCount ?? this.totalMsgCount,
      extraUpdateAt: extraUpdateAt ?? this.extraUpdateAt,
      creatorId: creatorId ?? this.creatorId,
    );
  }

  ChannelEntity toEntity() {
    return ChannelEntity(
      id: id,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      teamId: teamId,
      type: type,
      displayName: displayName,
      name: name,
      header: header,
      purpose: purpose,
      lastPostAt: lastPostAt,
      totalMsgCount: totalMsgCount,
      extraUpdateAt: extraUpdateAt,
      creatorId: creatorId,
    );
  }
}
