import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_access_control_data_source.dart';
import 'package:flutter_mattermost/features/admin/data/models/policy_simulation_user_result_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_access_control_repository.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_with_team_data_model.dart';

@LazySingleton(as: AdminAccessControlRepository)
class AdminAccessControlRepositoryImpl implements AdminAccessControlRepository {
  final AdminAccessControlDataSource _dataSource;

  AdminAccessControlRepositoryImpl(this._dataSource);

  @override
  Future<List<AccessControlPolicyEntity>> getPolicies({
    int page = 0,
    int perPage = 60,
  }) => _dataSource
      .getPolicies(page: page, perPage: perPage)
      .then((list) => list.map((e) => e.toEntity()).toList());

  @override
  Future<List<AccessControlPolicyEntity>>
  searchPolicies(Map<String, dynamic> query) => _dataSource
      .searchPolicies(query)
      .then((list) => list.map((e) => e.toEntity()).toList());

  @override
  Future<Map<String, dynamic>> getPolicy(String policyId) =>
      _dataSource.getPolicy(policyId);

  @override
  Future<Map<String, dynamic>> createPolicy(Map<String, dynamic> policy) =>
      _dataSource.createPolicy(policy);

  @override
  Future<void> deletePolicy(String policyId) =>
      _dataSource.deletePolicy(policyId);

  @override
  Future<Map<String, dynamic>> activatePolicy(Map<String, dynamic> data) =>
      _dataSource.activatePolicy(data);

  @override
  Future<Map<String, dynamic>> activatePolicyById(
    String policyId,
    Map<String, dynamic> data,
  ) => _dataSource.activatePolicyById(policyId, data);

  @override
  Future<Map<String, dynamic>> assignPolicy(
    String policyId,
    Map<String, dynamic> data,
  ) => _dataSource.assignPolicy(policyId, data);

  @override
  Future<Map<String, dynamic>> unassignPolicy(
    String policyId,
    Map<String, dynamic> data,
  ) => _dataSource.unassignPolicy(policyId, data);

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
  Future<Map<String, dynamic>> celCheck(Map<String, dynamic> data) =>
      _dataSource.celCheck(data);

  @override
  Future<Map<String, dynamic>> celTest(Map<String, dynamic> data) =>
      _dataSource.celTest(data);

  @override
  Future<List<PolicySimulationUserResultModel>> celSimulateUsers(
    Map<String, dynamic> data,
  ) => _dataSource.celSimulateUsers(data);

  @override
  Future<List<Map<String, dynamic>>> celAutocompleteFields() =>
      _dataSource.celAutocompleteFields();

  @override
  Future<Map<String, dynamic>> celVisualAst(Map<String, dynamic> data) =>
      _dataSource.celVisualAst(data);

  @override
  Future<Map<String, dynamic>> celValidateRequester(
    Map<String, dynamic> data,
  ) => _dataSource.celValidateRequester(data);

  @override
  Future<Map<String, dynamic>> getTeamAccessControlAttributes(String teamId) =>
      _dataSource.getTeamAccessControlAttributes(teamId);

  @override
  Future<Map<String, dynamic>> getTeamAccessControlPolicy(String teamId) =>
      _dataSource.getTeamAccessControlPolicy(teamId);

  @override
  Future<Map<String, dynamic>> getChannelAccessControlAttributes(
    String channelId,
  ) => _dataSource.getChannelAccessControlAttributes(channelId);
}
