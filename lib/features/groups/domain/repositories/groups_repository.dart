import 'package:flutter_mattermost/features/groups/data/models/group_users_model.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_member_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_syncable_entity.dart';

abstract class GroupsRepository {
  Future<List<GroupEntity>> getGroups({
    int page = 0,
    int perPage = 60,
    String? q,
    bool includeMemberCount = false,
    bool filterAllowReference = false,
  });

  Future<List<GroupEntity>> getGroupsByNames(List<String> names);
  Future<GroupEntity> getGroup(String groupId);
  Future<void> archiveGroup(String groupId);
  Future<void> restoreGroup(String groupId);
  Future<GroupEntity> patchGroup(
    String groupId, {
    String? name,
    String? displayName,
    String? description,
    String? source,
    String? remoteId,
  });
  Future<Map<String, dynamic>> getGroupStats(String groupId);
  Future<GroupUsersModel> getGroupUsers({
    required String groupId,
    int page = 0,
    int perPage = 60,
  });
  Future<List<GroupMemberEntity>> addUsersToGroup(
    String groupId,
    List<String> userIds,
  );
  Future<void> removeUsersFromGroup(String groupId, List<String> userIds);
  Future<List<GroupSyncableEntity>> getGroupSyncables(
    String groupId,
    String syncableType,
  );
  Future<GroupSyncableEntity> linkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  );
  Future<void> unlinkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  );
  Future<GroupSyncableEntity> patchGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId, {
    bool? autoAdd,
  });
  Future<List<GroupEntity>> getGroupsAssociatedToTeam({
    required String teamId,
    int page = 0,
    int perPage = 60,
  });
  Future<List<GroupEntity>> getGroupsAssociatedToChannel({
    required String channelId,
    int page = 0,
    int perPage = 60,
  });
  Future<List<GroupEntity>> getGroupsByUserId(String userId);
  Future<void> createGroupTeamsAndChannels(String userId);
}
