import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class PermissionsRemoteDataSource {
  Future<Map<String, List<String>>> getAncillaryPermissions({
    String? subsection,
    List<String>? permissions,
  });
}

@LazySingleton(as: PermissionsRemoteDataSource)
class PermissionsRemoteDataSourceImpl implements PermissionsRemoteDataSource {
  final ApiClient _apiClient;

  PermissionsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<Map<String, List<String>>> getAncillaryPermissions({
    String? subsection,
    List<String>? permissions,
  }) async {
    final result = await _apiClient.get<Map<String, List<String>>>(
      PermissionsEndPoint.ancillary,
      queryParameters: {
        'subsection': ?subsection,
        'permissions': ?permissions?.join(','),
      },
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return data.map(
          (key, value) => MapEntry(
            key,
            (value as List<dynamic>).map((e) => e.toString()).toList(),
          ),
        );
      },
    );
    if (result is ApiSuccess<Map<String, List<String>>>) {
      return result.data;
    }
    throw Exception('Failed to get ancillary permissions');
  }
}
