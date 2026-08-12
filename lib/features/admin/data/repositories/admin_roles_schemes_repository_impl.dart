import 'package:flutter_mattermost/features/admin/data/models/role_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/scheme_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/roles_remote_data_source.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/schemes_remote_data_source.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_roles_schemes_repository.dart';

@LazySingleton(as: AdminRolesSchemesRepository)
class AdminRolesSchemesRepositoryImpl implements AdminRolesSchemesRepository {
  final RolesRemoteDataSource _rolesDataSource;
  final SchemesRemoteDataSource _schemesDataSource;

  AdminRolesSchemesRepositoryImpl(
    this._rolesDataSource,
    this._schemesDataSource,
  );

  @override
  Future<List<RoleModel>> getRoles() => _rolesDataSource.getRoles();

  @override
  Future<RoleModel> patchRole(
    String roleId, {
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? schemeManaged,
  }) =>
      _rolesDataSource.patchRole(
        roleId,
        displayName: displayName,
        description: description,
        permissions: permissions,
        schemeManaged: schemeManaged,
      );

  @override
  Future<List<SchemeModel>> getSchemes({String? scope}) =>
      _schemesDataSource.getSchemes(scope: scope);

  @override
  Future<SchemeModel> createScheme({
    required String name,
    String? displayName,
    String? description,
    String? scope,
  }) =>
      _schemesDataSource.createScheme(
        name: name,
        displayName: displayName,
        description: description,
        scope: scope,
      );

  @override
  Future<SchemeModel> patchScheme(
    String schemeId, {
    String? name,
    String? displayName,
    String? description,
    String? scope,
  }) =>
      _schemesDataSource.patchScheme(
        schemeId,
        name: name,
        displayName: displayName,
        description: description,
        scope: scope,
      );

  @override
  Future<void> deleteScheme(String schemeId) =>
      _schemesDataSource.deleteScheme(schemeId);
}
