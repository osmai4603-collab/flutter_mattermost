import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_for_channel_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_for_team_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_with_team_and_channel_counts_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/global_data_retention_policy_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/data_retention_policy_entity.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_with_team_data_model.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_model.dart';

abstract class AdminDataRetentionRepository {
  Future<List<DataRetentionPolicyWithTeamAndChannelCountsModel>> getPolicies({
    int page = 0,
    int perPage = 60,
  });
  Future<DataRetentionPolicyEntity> getPolicy(String policyId);
  Future<DataRetentionPolicyEntity> createPolicy(Map<String, dynamic> policy);
  Future<DataRetentionPolicyEntity> updatePolicy(
    String policyId,
    Map<String, dynamic> policy,
  );
  Future<void> deletePolicy(String policyId);
  Future<List<ChannelWithTeamDataModel>> getPolicyChannels(
    String policyId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelWithTeamDataModel>> searchPolicyChannels(
    String policyId,
    Map<String, dynamic> query,
  );
  Future<List<TeamModel>> getPolicyTeams(
    String policyId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<TeamModel>> searchPolicyTeams(
    String policyId,
    Map<String, dynamic> query,
  );
  Future<int> getPoliciesCount();
  Future<GlobalDataRetentionPolicyModel> getGlobalPolicy();
  Future<GlobalDataRetentionPolicyModel> updateGlobalPolicy(Map<String, dynamic> policy);
  Future<void> deleteGlobalPolicy();
  Future<List<DataRetentionPolicyForChannelModel>> getUserChannelPolicies(
    String userId,
  );
  Future<List<DataRetentionPolicyForTeamModel>> getUserTeamPolicies(
    String userId,
  );
}
