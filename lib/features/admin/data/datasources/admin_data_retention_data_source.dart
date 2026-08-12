import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/global_data_retention_policy_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_for_channel_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_for_team_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_with_team_and_channel_counts_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_with_team_data_model.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_model.dart';

abstract class AdminDataRetentionDataSource {
  Future<List<DataRetentionPolicyWithTeamAndChannelCountsModel>> getPolicies({
    int page = 0,
    int perPage = 60,
  });
  Future<DataRetentionPolicyModel> getPolicy(String policyId);
  Future<DataRetentionPolicyModel> createPolicy(Map<String, dynamic> policy);
  Future<DataRetentionPolicyModel> updatePolicy(
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

  // Missing operations from docs
  Future<void> addTeamsToRetentionPolicy(String policyId, List<String> teamIds);
  Future<void> removeTeamsFromRetentionPolicy(String policyId, List<String> teamIds);
  Future<void> addChannelsToRetentionPolicy(String policyId, List<String> channelIds);
  Future<void> removeChannelsFromRetentionPolicy(String policyId, List<String> channelIds);
  Future<DataRetentionPolicyModel> patchDataRetentionPolicy(String policyId, Map<String, dynamic> patch);
}

@LazySingleton(as: AdminDataRetentionDataSource)
class AdminDataRetentionDataSourceImpl implements AdminDataRetentionDataSource {
  final ApiClient _apiClient;

  AdminDataRetentionDataSourceImpl(this._apiClient);

  @override
  Future<List<DataRetentionPolicyWithTeamAndChannelCountsModel>> getPolicies({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient
        .get<List<DataRetentionPolicyWithTeamAndChannelCountsModel>>(
          DataRetentionEndPoint.policies,
          queryParameters: {'page': page, 'per_page': perPage},
          fromJson: (json) => (json as List<dynamic>)
              .map(
                (e) => DataRetentionPolicyWithTeamAndChannelCountsModel.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
    if (result is ApiSuccess<List<DataRetentionPolicyWithTeamAndChannelCountsModel>>) {
      return result.data;
    }
    throw Exception('Failed to get data retention policies');
  }

  @override
  Future<DataRetentionPolicyModel> getPolicy(String policyId) async {
    final result = await _apiClient.get<DataRetentionPolicyModel>(
      DataRetentionEndPoint.policies2(policyId),
      fromJson: (json) => DataRetentionPolicyModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<DataRetentionPolicyModel>) {
      return result.data;
    }
    throw Exception('Failed to get data retention policy $policyId');
  }

  @override
  Future<DataRetentionPolicyModel> createPolicy(Map<String, dynamic> policy) async {
    final result = await _apiClient.post<DataRetentionPolicyModel>(
      DataRetentionEndPoint.policies,
      data: policy,
      fromJson: (json) => DataRetentionPolicyModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<DataRetentionPolicyModel>) {
      return result.data;
    }
    throw Exception('Failed to create data retention policy');
  }

  @override
  Future<DataRetentionPolicyModel> updatePolicy(
    String policyId,
    Map<String, dynamic> policy,
  ) async {
    final result = await _apiClient.patch<DataRetentionPolicyModel>(
      DataRetentionEndPoint.policies2(policyId),
      data: policy,
      fromJson: (json) => DataRetentionPolicyModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<DataRetentionPolicyModel>) {
      return result.data;
    }
    throw Exception('Failed to update data retention policy $policyId');
  }

  @override
  Future<void> deletePolicy(String policyId) async {
    final result = await _apiClient.delete(
      DataRetentionEndPoint.policies2(policyId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete data retention policy $policyId');
    }
  }

  @override
  Future<List<ChannelWithTeamDataModel>> getPolicyChannels(
    String policyId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelWithTeamDataModel>>(
      DataRetentionEndPoint.policiesChannels(policyId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelWithTeamDataModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelWithTeamDataModel>>) {
      return result.data;
    }
    throw Exception('Failed to get channels for policy $policyId');
  }

  @override
  Future<List<ChannelWithTeamDataModel>> searchPolicyChannels(
    String policyId,
    Map<String, dynamic> query,
  ) async {
    final result = await _apiClient.post<List<ChannelWithTeamDataModel>>(
      DataRetentionEndPoint.policiesChannelsSearch(policyId),
      data: query,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelWithTeamDataModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelWithTeamDataModel>>) {
      return result.data;
    }
    throw Exception('Failed to search channels for policy $policyId');
  }

  @override
  Future<List<TeamModel>> getPolicyTeams(
    String policyId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<TeamModel>>(
      DataRetentionEndPoint.policiesTeams(policyId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to get teams for policy $policyId');
  }

  @override
  Future<List<TeamModel>> searchPolicyTeams(
    String policyId,
    Map<String, dynamic> query,
  ) async {
    final result = await _apiClient.post<List<TeamModel>>(
      DataRetentionEndPoint.policiesTeamsSearch(policyId),
      data: query,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => TeamModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<TeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to search teams for policy $policyId');
  }

  @override
  Future<int> getPoliciesCount() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      DataRetentionEndPoint.policiesCount,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['total_count'] as num?)?.toInt() ?? 0;
    }
    throw Exception('Failed to get data retention policies count');
  }

  @override
  Future<GlobalDataRetentionPolicyModel> getGlobalPolicy() async {
    final result = await _apiClient.get<GlobalDataRetentionPolicyModel>(
      DataRetentionEndPoint.policy,
      fromJson: (json) => GlobalDataRetentionPolicyModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GlobalDataRetentionPolicyModel>) {
      return result.data;
    }
    throw Exception('Failed to get global data retention policy');
  }

  @override
  Future<GlobalDataRetentionPolicyModel> updateGlobalPolicy(
    Map<String, dynamic> policy,
  ) async {
    final result = await _apiClient.put<GlobalDataRetentionPolicyModel>(
      DataRetentionEndPoint.policy,
      data: policy,
      fromJson: (json) => GlobalDataRetentionPolicyModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<GlobalDataRetentionPolicyModel>) {
      return result.data;
    }
    throw Exception('Failed to update global data retention policy');
  }

  @override
  Future<void> deleteGlobalPolicy() async {
    final result = await _apiClient.delete(DataRetentionEndPoint.policy);
    if (result is ApiFailure) {
      throw Exception('Failed to delete global data retention policy');
    }
  }

  @override
  Future<void> addTeamsToRetentionPolicy(String policyId, List<String> teamIds) async {
    await _apiClient.post<void>(
      DataRetentionEndPoint.policiesTeams(policyId),
      data: teamIds,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> removeTeamsFromRetentionPolicy(String policyId, List<String> teamIds) async {
    await _apiClient.delete(
      DataRetentionEndPoint.policiesTeams(policyId),
      data: teamIds,
    );
  }

  @override
  Future<void> addChannelsToRetentionPolicy(String policyId, List<String> channelIds) async {
    await _apiClient.post<void>(
      DataRetentionEndPoint.policiesChannels(policyId),
      data: channelIds,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> removeChannelsFromRetentionPolicy(String policyId, List<String> channelIds) async {
    await _apiClient.delete(
      DataRetentionEndPoint.policiesChannels(policyId),
      data: channelIds,
    );
  }

  @override
  Future<DataRetentionPolicyModel> patchDataRetentionPolicy(String policyId, Map<String, dynamic> patch) async {
    final result = await _apiClient.patch<DataRetentionPolicyModel>(
      DataRetentionEndPoint.policies2(policyId),
      data: patch,
      fromJson: (json) => DataRetentionPolicyModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<DataRetentionPolicyModel>) {
      return result.data;
    }
    throw Exception('Failed to patch data retention policy $policyId');
  }

  @override
  Future<List<DataRetentionPolicyForChannelModel>> getUserChannelPolicies(
    String userId,
  ) async {
    final result =
        await _apiClient.get<List<DataRetentionPolicyForChannelModel>>(
          UsersEndPoint.dataRetentionChannelPolicies(userId),
          fromJson: (json) => (json as List<dynamic>)
              .map(
                (e) => DataRetentionPolicyForChannelModel.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
    if (result is ApiSuccess<List<DataRetentionPolicyForChannelModel>>) {
      return result.data;
    }
    throw Exception(
      'Failed to get data retention channel policies for $userId',
    );
  }

  @override
  Future<List<DataRetentionPolicyForTeamModel>> getUserTeamPolicies(
    String userId,
  ) async {
    final result = await _apiClient.get<List<DataRetentionPolicyForTeamModel>>(
      UsersEndPoint.dataRetentionTeamPolicies(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => DataRetentionPolicyForTeamModel.fromMap(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<DataRetentionPolicyForTeamModel>>) {
      return result.data;
    }
    throw Exception('Failed to get data retention team policies for $userId');
  }
}
