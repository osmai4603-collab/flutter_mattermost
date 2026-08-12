import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/access_control_policy_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/policy_simulation_user_result_model.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_with_team_data_model.dart';

abstract class AdminAccessControlDataSource {
  Future<List<AccessControlPolicyModel>> getPolicies({
    int page = 0,
    int perPage = 60,
  });
  Future<List<AccessControlPolicyModel>> searchPolicies(
    Map<String, dynamic> query,
  );
  Future<Map<String, dynamic>> getPolicy(String policyId);
  Future<Map<String, dynamic>> createPolicy(Map<String, dynamic> policy);
  Future<void> deletePolicy(String policyId);
  Future<Map<String, dynamic>> activatePolicy(Map<String, dynamic> data);
  Future<Map<String, dynamic>> activatePolicyById(
    String policyId,
    Map<String, dynamic> data,
  );
  Future<Map<String, dynamic>> assignPolicy(
    String policyId,
    Map<String, dynamic> data,
  );
  Future<Map<String, dynamic>> unassignPolicy(
    String policyId,
    Map<String, dynamic> data,
  );
  Future<List<ChannelWithTeamDataModel>> getPolicyChannels(
    String policyId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<ChannelWithTeamDataModel>> searchPolicyChannels(
    String policyId,
    Map<String, dynamic> query,
  );
  Future<Map<String, dynamic>> celCheck(Map<String, dynamic> data);
  Future<Map<String, dynamic>> celTest(Map<String, dynamic> data);
  Future<List<PolicySimulationUserResultModel>> celSimulateUsers(
    Map<String, dynamic> data,
  );
  Future<List<Map<String, dynamic>>> celAutocompleteFields();
  Future<Map<String, dynamic>> celVisualAst(Map<String, dynamic> data);
  Future<Map<String, dynamic>> celValidateRequester(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getTeamAccessControlAttributes(String teamId);
  Future<Map<String, dynamic>> getTeamAccessControlPolicy(String teamId);
  Future<Map<String, dynamic>> getChannelAccessControlAttributes(
    String channelId,
  );
}

@LazySingleton(as: AdminAccessControlDataSource)
class AdminAccessControlDataSourceImpl implements AdminAccessControlDataSource {
  final ApiClient _apiClient;

  AdminAccessControlDataSourceImpl(this._apiClient);

  @override
  Future<List<AccessControlPolicyModel>> getPolicies({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient
        .get<List<AccessControlPolicyModel>>(
          AccessControlPoliciesEndPoint.root,
          queryParameters: {'page': page, 'per_page': perPage},
          fromJson: (json) => (json as List<dynamic>)
              .map(
                (e) => AccessControlPolicyModel.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
    if (result is ApiSuccess<List<AccessControlPolicyModel>>) {
      return result.data;
    }
    throw Exception('Failed to get access control policies');
  }

  @override
  Future<List<AccessControlPolicyModel>> searchPolicies(
    Map<String, dynamic> query,
  ) async {
    final result = await _apiClient
        .post<List<AccessControlPolicyModel>>(
          AccessControlPoliciesEndPoint.search,
          data: query,
          fromJson: (json) => (json as List<dynamic>)
              .map(
                (e) => AccessControlPolicyModel.fromMap(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
    if (result is ApiSuccess<List<AccessControlPolicyModel>>) {
      return result.data;
    }
    throw Exception('Failed to search access control policies');
  }

  @override
  Future<Map<String, dynamic>> getPolicy(String policyId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.byPolicyId(policyId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get access control policy $policyId');
  }

  @override
  Future<Map<String, dynamic>> createPolicy(Map<String, dynamic> policy) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.root,
      data: policy,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to create access control policy');
  }

  @override
  Future<void> deletePolicy(String policyId) async {
    final result = await _apiClient.delete(
      AccessControlPoliciesEndPoint.byPolicyId(policyId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete access control policy $policyId');
    }
  }

  @override
  Future<Map<String, dynamic>> activatePolicy(Map<String, dynamic> data) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.activate,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to activate access control policy');
  }

  @override
  Future<Map<String, dynamic>> activatePolicyById(
    String policyId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.activate2(policyId),
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to activate access control policy $policyId');
  }

  @override
  Future<Map<String, dynamic>> assignPolicy(
    String policyId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.assign(policyId),
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to assign access control policy $policyId');
  }

  @override
  Future<Map<String, dynamic>> unassignPolicy(
    String policyId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.unassign(policyId),
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to unassign access control policy $policyId');
  }

  @override
  Future<List<ChannelWithTeamDataModel>> getPolicyChannels(
    String policyId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ChannelWithTeamDataModel>>(
      AccessControlPoliciesEndPoint.resourcesChannels(policyId),
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
      AccessControlPoliciesEndPoint.resourcesChannelsSearch(policyId),
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
  Future<Map<String, dynamic>> celCheck(Map<String, dynamic> data) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.celCheck,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to run CEL check');
  }

  @override
  Future<Map<String, dynamic>> celTest(Map<String, dynamic> data) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.celTest,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to run CEL test');
  }

  @override
  Future<List<PolicySimulationUserResultModel>> celSimulateUsers(
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<List<PolicySimulationUserResultModel>>(
      AccessControlPoliciesEndPoint.celSimulateUsers,
      data: data,
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => PolicySimulationUserResultModel.fromMap(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<PolicySimulationUserResultModel>>) {
      return result.data;
    }
    throw Exception('Failed to simulate users for CEL');
  }

  @override
  Future<List<Map<String, dynamic>>> celAutocompleteFields() async {
    final result = await _apiClient.get<List<Map<String, dynamic>>>(
      AccessControlPoliciesEndPoint.celAutocompleteFields,
      fromJson: (json) => (json as List<dynamic>).cast<Map<String, dynamic>>(),
    );
    if (result is ApiSuccess<List<Map<String, dynamic>>>) {
      return result.data;
    }
    throw Exception('Failed to autocomplete CEL fields');
  }

  @override
  Future<Map<String, dynamic>> celVisualAst(Map<String, dynamic> data) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.celVisualAst,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get CEL visual AST');
  }

  @override
  Future<Map<String, dynamic>> celValidateRequester(
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      AccessControlPoliciesEndPoint.celValidateRequester,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to validate CEL requester');
  }

  @override
  Future<Map<String, dynamic>> getTeamAccessControlAttributes(
    String teamId,
  ) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      TeamsEndPoint.accessControlAttributes(teamId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get access control attributes for team $teamId');
  }

  @override
  Future<Map<String, dynamic>> getTeamAccessControlPolicy(String teamId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      TeamsEndPoint.accessControlPolicy(teamId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get access control policy for team $teamId');
  }

  @override
  Future<Map<String, dynamic>> getChannelAccessControlAttributes(
    String channelId,
  ) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ChannelsEndPoint.accessControlAttributes(channelId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception(
      'Failed to get access control attributes for channel $channelId',
    );
  }
}
