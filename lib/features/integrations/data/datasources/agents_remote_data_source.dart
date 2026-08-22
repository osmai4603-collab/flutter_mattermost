import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';

abstract class AgentsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAgents();
  Future<Map<String, dynamic>> getAgentsStatus();
}

@LazySingleton(as: AgentsRemoteDataSource)
class AgentsRemoteDataSourceImpl implements AgentsRemoteDataSource {
  final ApiClient _apiClient;

  AgentsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<Map<String, dynamic>>> getAgents() async {
    final result = await _apiClient.get<List<Map<String, dynamic>>>(
      AgentsEndPoint.base,
      fromJson: (json) {
        if (json is List) {
          return json.map((e) => e as Map<String, dynamic>).toList();
        }
        return <Map<String, dynamic>>[];
      },
    );
    if (result is ApiSuccess<List<Map<String, dynamic>>>) {
      return result.data;
    }
    return <Map<String, dynamic>>[];
  }

  @override
  Future<Map<String, dynamic>> getAgentsStatus() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      AgentsEndPoint.status,
      fromJson: (json) {
        if (json is Map<String, dynamic>) {
          return json;
        }
        return <String, dynamic>{};
      },
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    return <String, dynamic>{};
  }
}
