import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/scheme_entity.dart';

abstract class AdminRolesSchemesRepository {
  Future<List<RoleEntity>> getRoles();
  Future<RoleEntity> patchRole(
    String roleId, {
    String? displayName,
    String? description,
    List<String>? permissions,
    bool? schemeManaged,
  });
  Future<List<SchemeEntity>> getSchemes({String? scope});
  Future<SchemeEntity> createScheme({
    required String name,
    String? displayName,
    String? description,
    String? scope,
  });
  Future<SchemeEntity> patchScheme(
    String schemeId, {
    String? name,
    String? displayName,
    String? description,
    String? scope,
  });
  Future<void> deleteScheme(String schemeId);
}