import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/agent_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/agent_status_model.dart';

abstract class AdminAgentsDataSource {
  Future<List<AgentModel>> getAgents();
  Future<AgentStatusModel> getAgentsStatus();
}

@LazySingleton(as: AdminAgentsDataSource)
class AdminAgentsDataSourceImpl implements AdminAgentsDataSource {
  final ApiClient _apiClient;

  AdminAgentsDataSourceImpl(this._apiClient);

  @override
  Future<List<AgentModel>> getAgents() async {
    final result = await _apiClient.get<List<AgentModel>>(
      AgentsEndPoint.root,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AgentModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AgentModel>>) {
      return result.data;
    }
    throw Exception('Failed to get agents');
  }

  @override
  Future<AgentStatusModel> getAgentsStatus() async {
    final result = await _apiClient.get<AgentStatusModel>(
      AgentsEndPoint.status,
      fromJson: (json) => AgentStatusModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<AgentStatusModel>) {
      return result.data;
    }
    throw Exception('Failed to get agents status');
  }
}
