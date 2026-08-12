import 'package:flutter_mattermost/features/groups/data/models/group_users_model.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_member_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_syncable_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/groups/data/datasources/groups_remote_data_source.dart';
import 'package:flutter_mattermost/features/groups/domain/repositories/groups_repository.dart';

@LazySingleton(as: GroupsRepository)
class GroupsRepositoryImpl implements GroupsRepository {
  final GroupsRemoteDataSource _dataSource;

  GroupsRepositoryImpl(this._dataSource);

  @override
  Future<List<GroupEntity>> getGroups({
    int page = 0,
    int perPage = 60,
    String? q,
    bool includeMemberCount = false,
  }) => _dataSource.getGroups(
    page: page,
    perPage: perPage,
    q: q,
    includeMemberCount: includeMemberCount,
  );

  @override
  Future<List<GroupEntity>> getGroupsByNames(List<String> names) =>
      _dataSource.getGroupsByNames(names);

  @override
  Future<GroupEntity> getGroup(String groupId) => _dataSource.getGroup(groupId);

  @override
  Future<void> archiveGroup(String groupId) =>
      _dataSource.archiveGroup(groupId);

  @override
  Future<void> restoreGroup(String groupId) =>
      _dataSource.restoreGroup(groupId);

  @override
  Future<GroupEntity> patchGroup(
    String groupId, {
    String? name,
    String? displayName,
    String? description,
    String? source,
    String? remoteId,
  }) => _dataSource.patchGroup(
    groupId,
    name: name,
    displayName: displayName,
    description: description,
    source: source,
    remoteId: remoteId,
  );

  @override
  Future<Map<String, dynamic>> getGroupStats(String groupId) =>
      _dataSource.getGroupStats(groupId);

  @override
  Future<GroupUsersModel> getGroupUsers({
    required String groupId,
    int page = 0,
    int perPage = 60,
  }) =>
      _dataSource.getGroupUsers(groupId: groupId, page: page, perPage: perPage);

  @override
  Future<List<GroupMemberEntity>> addUsersToGroup(
    String groupId,
    List<String> userIds,
  ) => _dataSource.addUsersToGroup(groupId, userIds);

  @override
  Future<void> removeUsersFromGroup(String groupId, List<String> userIds) =>
      _dataSource.removeUsersFromGroup(groupId, userIds);

  @override
  Future<List<GroupSyncableEntity>> getGroupSyncables(
    String groupId,
    String syncableType,
  ) => _dataSource.getGroupSyncables(groupId, syncableType);

  @override
  Future<GroupSyncableEntity> linkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  ) => _dataSource.linkGroupSyncable(groupId, syncableType, syncableId);

  @override
  Future<void> unlinkGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId,
  ) => _dataSource.unlinkGroupSyncable(groupId, syncableType, syncableId);

  @override
  Future<GroupSyncableEntity> patchGroupSyncable(
    String groupId,
    String syncableType,
    String syncableId, {
    bool? autoAdd,
  }) => _dataSource.patchGroupSyncable(
    groupId,
    syncableType,
    syncableId,
    autoAdd: autoAdd,
  );

  @override
  Future<List<GroupEntity>> getGroupsAssociatedToTeam({
    required String teamId,
    int page = 0,
    int perPage = 60,
  }) => _dataSource.getGroupsAssociatedToTeam(
    teamId: teamId,
    page: page,
    perPage: perPage,
  );

  @override
  Future<List<GroupEntity>> getGroupsAssociatedToChannel({
    required String channelId,
    int page = 0,
    int perPage = 60,
  }) async {
    return _dataSource.getGroupsAssociatedToChannel(
      channelId: channelId,
      page: page,
      perPage: perPage,
    );
  }

  @override
  Future<List<GroupEntity>> getGroupsByUserId(String userId) =>
      _dataSource.getGroupsByUserId(userId);

  @override
  Future<void> createGroupTeamsAndChannels(String userId) =>
      _dataSource.createGroupTeamsAndChannels(userId);
}
