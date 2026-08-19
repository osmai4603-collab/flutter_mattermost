import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_member_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_stats_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_unread_entity.dart';

abstract class TeamRepository {
  Future<List<TeamEntity>> getMyTeams({int page = 0, int perPage = 60});
  Future<List<TeamEntity>> getTeamsForUser(
    String userId, {
    int page = 0,
    int perPage = 60,
  });
  Future<TeamEntity> getTeamById(String teamId);
  Future<TeamEntity> getTeamByName(String teamName);
  Future<List<TeamMemberEntity>> getTeamMembers(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<TeamMemberEntity> getTeamMember(String teamId, String userId);
  Future<List<TeamUnreadEntity>> getTeamsUnreadForUser(String userId);
  Future<TeamUnreadEntity> getTeamUnreadForUser(
    String userId,
    String teamId,
  );
  Future<bool> checkIfTeamExists(String teamName);
  Future<TeamStatsEntity> getTeamStats(String teamId);
  Future<TeamEntity> createTeam(Map<String, dynamic> team);
  Future<void> inviteMembersByEmail(String teamId, List<String> emails);
  Future<void> inviteGuestsToChannels(
    String teamId, {
    required List<String> emails,
    required List<String> channelIds,
  });
  Future<TeamMemberEntity> addToTeam(String teamId, String userId);
  Future<List<TeamMemberEntity>> addUsersToTeam(
    String teamId,
    List<String> userIds,
  );
}
