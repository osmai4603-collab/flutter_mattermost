import 'package:flutter_mattermost/features/admin/data/models/data_retention_policy_with_team_and_channel_counts_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/policy_simulation_user_result_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/access_control_policy_entity.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_with_team_data_model.dart';

abstract class AdminAccessControlRepository {
  Future<List<AccessControlPolicyEntity>> getPolicies({
    int page = 0,
    int perPage = 60,
  });
  Future<List<AccessControlPolicyEntity>>
  searchPolicies(Map<String, dynamic> query);
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
