import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';

/// خريطة من معرف القناة إلى مجموعة الفرق المقيدة لها (GroupsAssociatedToChannels).
class GroupsAssociatedToChannelsEntity extends Equatable {
  final Map<String, List<GroupEntity>> groups;

  const GroupsAssociatedToChannelsEntity({
    this.groups = const {},
  });

  @override
  List<Object?> get props => [groups];

  GroupsAssociatedToChannelsEntity copyWith({
    Map<String, List<GroupEntity>>? groups,
  }) {
    return GroupsAssociatedToChannelsEntity(
      groups: groups ?? this.groups,
    );
  }
}
