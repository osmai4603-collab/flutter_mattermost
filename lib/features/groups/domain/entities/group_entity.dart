import 'package:flutter_mattermost/core/entities/entity.dart';

class GroupEntity extends Entity {
  final String id;
  final String name;
  final String displayName;
  final String description;
  final String source;
  final String remoteId;
  final int createAt;
  final int updateAt;
  final int deleteAt;
  final bool hasSyncables;
  final int memberCount;

  /// هل يمكن الإشارة إلى المجموعة بمنشن `@group-name`؟
  /// (نظير `allow_reference` في webapp — مطلوب لتفعيل Group Mentions.)
  final bool allowReference;

  const GroupEntity({
    this.id = '',
    this.name = '',
    this.displayName = '',
    this.description = '',
    this.source = 'custom',
    this.remoteId = '',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
    this.hasSyncables = false,
    this.memberCount = 0,
    this.allowReference = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        displayName,
        description,
        source,
        remoteId,
        createAt,
        updateAt,
        deleteAt,
        hasSyncables,
        memberCount,
        allowReference,
      ];

  @override
  GroupEntity copyWith({
    String? id,
    String? name,
    String? displayName,
    String? description,
    String? source,
    String? remoteId,
    int? createAt,
    int? updateAt,
    int? deleteAt,
    bool? hasSyncables,
    int? memberCount,
    bool? allowReference,
  }) {
    return GroupEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      source: source ?? this.source,
      remoteId: remoteId ?? this.remoteId,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
      hasSyncables: hasSyncables ?? this.hasSyncables,
      memberCount: memberCount ?? this.memberCount,
      allowReference: allowReference ?? this.allowReference,
    );
  }

  bool get isArchived => deleteAt > 0;
}
