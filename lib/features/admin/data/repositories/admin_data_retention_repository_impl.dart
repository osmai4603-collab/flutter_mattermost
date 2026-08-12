import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/global_data_retention_policy_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_data_retention_data_source.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_for_channel_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_for_team_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_with_team_and_channel_counts_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_data_retention_repository.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_with_team_data_model.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_model.dart';

@LazySingleton(as: AdminDataRetentionRepository)
class AdminDataRetentionRepositoryImpl implements AdminDataRetentionRepository {
  final AdminDataRetentionDataSource _dataSource;

  AdminDataRetentionRepositoryImpl(this._dataSource);

  @override
  Future<List<DataRetentionPolicyWithTeamAndChannelCountsModel>> getPolicies({
    int page = 0,
    int perPage = 60,
  }) => _dataSource.getPolicies(page: page, perPage: perPage);

  @override
  Future<DataRetentionPolicyModel> getPolicy(String policyId) =>
      _dataSource.getPolicy(policyId);

  @override
  Future<DataRetentionPolicyModel> createPolicy(Map<String, dynamic> policy) =>
      _dataSource.createPolicy(policy);

  @override
  Future<DataRetentionPolicyModel> updatePolicy(
    String policyId,
    Map<String, dynamic> policy,
  ) => _dataSource.updatePolicy(policyId, policy);

  @override
  Future<void> deletePolicy(String policyId) =>
      _dataSource.deletePolicy(policyId);

  @override
  Future<List<ChannelWithTeamDataModel>> getPolicyChannels(
    String policyId, {
    int page = 0,
    int perPage = 60,
  }) => _dataSource.getPolicyChannels(policyId, page: page, perPage: perPage);

  @override
  Future<List<ChannelWithTeamDataModel>> searchPolicyChannels(
    String policyId,
    Map<String, dynamic> query,
  ) => _dataSource.searchPolicyChannels(policyId, query);

  @override
  Future<List<TeamModel>> getPolicyTeams(
    String policyId, {
    int page = 0,
    int perPage = 60,
  }) => _dataSource.getPolicyTeams(policyId, page: page, perPage: perPage);

  @override
  Future<List<TeamModel>> searchPolicyTeams(
    String policyId,
    Map<String, dynamic> query,
  ) => _dataSource.searchPolicyTeams(policyId, query);

  @override
  Future<int> getPoliciesCount() =>
      _dataSource.getPoliciesCount();

  @override
  Future<GlobalDataRetentionPolicyModel> getGlobalPolicy() =>
      _dataSource.getGlobalPolicy();

  @override
  Future<GlobalDataRetentionPolicyModel> updateGlobalPolicy(
    Map<String, dynamic> policy,
  ) => _dataSource.updateGlobalPolicy(policy);

  @override
  Future<void> deleteGlobalPolicy() => _dataSource.deleteGlobalPolicy();

  @override
  Future<List<DataRetentionPolicyForChannelModel>> getUserChannelPolicies(
    String userId,
  ) => _dataSource.getUserChannelPolicies(userId);

  @override
  Future<List<DataRetentionPolicyForTeamModel>> getUserTeamPolicies(
    String userId,
  ) => _dataSource.getUserTeamPolicies(userId);
}
