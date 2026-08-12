import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';

class ChannelEntity extends Entity {
  final String id;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final String teamId;
  final ChannelType type;
  final String displayName;
  final String name;
  final String header;
  final String purpose;
  final int lastPostAt;
  final int totalMsgCount;
  final int extraUpdateAt;
  final String creatorId;

  const ChannelEntity({
    required this.id,
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.teamId = '',
    this.type = ChannelType.open,
    this.displayName = '',
    this.name = '',
    this.header = '',
    this.purpose = '',
    this.lastPostAt = 0,
    this.totalMsgCount = 0,
    this.extraUpdateAt = 0,
    this.creatorId = '',
  });

  @override
  List<Object?> get props => [
        id,
        createAt,
        updateAt,
        deleteAt,
        teamId,
        type,
        displayName,
        name,
        header,
        purpose,
        lastPostAt,
        totalMsgCount,
        extraUpdateAt,
        creatorId,
      ];

  @override
  ChannelEntity copyWith({
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
    return ChannelEntity(
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
}
