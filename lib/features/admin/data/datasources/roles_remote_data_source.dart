import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/features/admin/data/models/role_model.dart';

abstract class RolesRemoteDataSource {
  Future<List<RoleModel>> getRoles({int page = 0, int perPage = 200});
  Future<RoleModel> getRoleByName(String roleName);
  Future<List<RoleModel>> getRolesByNames(List<String> roleNames);
  Future<RoleModel> getRole(String roleId);
  Future<RoleModel> patchRole(
    String roleId, {
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? schemeManaged,
  });
}

@LazySingleton(as: RolesRemoteDataSource)
class RolesRemoteDataSourceImpl implements RolesRemoteDataSource {
  final ApiClient _apiClient;

  RolesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<RoleModel>> getRoles({int page = 0, int perPage = 200}) async {
    final result = await _apiClient.get<List<RoleModel>>(
      RolesEndPoint.root,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => RoleModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<RoleModel>>) {
      return result.data;
    }
    throw Exception('Failed to get roles');
  }

  @override
  Future<RoleModel> getRoleByName(String roleName) async {
    final result = await _apiClient.get<RoleModel>(
      RolesEndPoint.name(roleName),
      fromJson: (json) => RoleModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<RoleModel>) {
      return result.data;
    }
    throw Exception('Failed to get role by name');
  }

  @override
  Future<List<RoleModel>> getRolesByNames(List<String> roleNames) async {
    final result = await _apiClient.post<List<RoleModel>>(
      RolesEndPoint.names,
      data: roleNames,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => RoleModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<RoleModel>>) {
      return result.data;
    }
    throw Exception('Failed to get roles by names');
  }

  @override
  Future<RoleModel> getRole(String roleId) async {
    final result = await _apiClient.get<RoleModel>(
      RolesEndPoint.byRoleId(roleId),
      fromJson: (json) => RoleModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<RoleModel>) {
      return result.data;
    }
    throw Exception('Failed to get role');
  }

  @override
  Future<RoleModel> patchRole(
    String roleId, {
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? schemeManaged,
  }) async {
    final result = await _apiClient.put<RoleModel>(
      RolesEndPoint.patch(roleId),
      data: {
        if (displayName != null) 'display_name': displayName,
        if (description != null) 'description': description,
        if (permissions != null) 'permissions': permissions,
        if (schemeManaged != null) 'scheme_managed': schemeManaged,
      },
      fromJson: (json) => RoleModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<RoleModel>) {
      return result.data;
    }
    throw Exception('Failed to patch role');
  }
}