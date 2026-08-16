import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';

final class GroupModel extends GroupEntity {
  const GroupModel({
    super.id,
    super.name,
    super.displayName,
    super.description,
    super.source,
    super.remoteId,
    super.createAt,
    super.updateAt,
    super.deleteAt,
    super.hasSyncables,
    super.memberCount,
    super.allowReference,
  });

  factory GroupModel.fromMap(Map<String, dynamic> data) {
    return GroupModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      displayName: data['display_name'] ?? '',
      description: data['description'] ?? '',
      source: data['source'] ?? 'custom',
      remoteId: data['remote_id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
      hasSyncables: data['has_syncables'] ?? false,
      memberCount: (data['member_count'] ?? 0).toInt(),
      allowReference: data['allow_reference'] ?? false,
    );
  }

  factory GroupModel.fromEntity(GroupEntity entity) {
    return GroupModel(
      id: entity.id,
      name: entity.name,
      displayName: entity.displayName,
      description: entity.description,
      source: entity.source,
      remoteId: entity.remoteId,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
      hasSyncables: entity.hasSyncables,
      memberCount: entity.memberCount,
      allowReference: entity.allowReference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'display_name': displayName,
      'description': description,
      'source': source,
      'remote_id': remoteId,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
      'has_syncables': hasSyncables,
      'member_count': memberCount,
      'allow_reference': allowReference,
    };
  }

  @override
  GroupModel copyWith({
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
    return GroupModel(
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

  GroupEntity toEntity() {
    return GroupEntity(
      id: id,
      name: name,
      displayName: displayName,
      description: description,
      source: source,
      remoteId: remoteId,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
      hasSyncables: hasSyncables,
      memberCount: memberCount,
      allowReference: allowReference,
    );
  }
}
