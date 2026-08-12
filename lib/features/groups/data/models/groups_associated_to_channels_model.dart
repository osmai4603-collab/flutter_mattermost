import 'package:flutter_mattermost/features/groups/domain/entities/groups_associated_to_channels_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';
import 'package:flutter_mattermost/features/groups/data/models/group_model.dart';

final class GroupsAssociatedToChannelsModel extends GroupsAssociatedToChannelsEntity {
  const GroupsAssociatedToChannelsModel({
    required super.groups,
  });

  factory GroupsAssociatedToChannelsModel.fromMap(Map<String, dynamic> map) {
    return GroupsAssociatedToChannelsModel(
      groups: map.entries.fold<Map<String, List<GroupEntity>>>(
        {},
        (acc, entry) {
          acc[entry.key] = (entry.value as List<dynamic>? ?? [])
              .map((e) => GroupModel.fromMap(
                    Map<String, dynamic>.from(e as Map<String, dynamic>),
                  ))
              .toList();
          return acc;
        },
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return groups.map(
      (key, value) => MapEntry(
        key,
        value.map((e) => GroupModel.fromEntity(e).toMap()).toList(),
      ),
    );
  }

  factory GroupsAssociatedToChannelsModel.fromEntity(
    GroupsAssociatedToChannelsEntity entity,
  ) {
    return GroupsAssociatedToChannelsModel(
      groups: entity.groups,
    );
  }

  @override
  GroupsAssociatedToChannelsModel copyWith({
    Map<String, List<GroupEntity>>? groups,
  }) {
    return GroupsAssociatedToChannelsModel(
      groups: groups ?? this.groups,
    );
  }

  GroupsAssociatedToChannelsEntity toEntity() => GroupsAssociatedToChannelsEntity(
        groups: groups,
      );
}
