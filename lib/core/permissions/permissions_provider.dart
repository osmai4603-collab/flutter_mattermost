import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/permissions/permissions_constants.dart';
import 'package:flutter_mattermost/core/storage/app_database.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/roles_remote_data_source.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';

/// خدمة مركزية لفحص الصلاحيات.
///
/// تحمّل الأدوار من الـ API وتخزّنها محلياً في Drift ثم تفحص الصلاحيات
/// من الكاش. أدوار المستخدم الحالية تُقرأ من جدول [CachedUsers].
@lazySingleton
class PermissionsProvider {
  PermissionsProvider(
    this._rolesRemoteDataSource,
    this._database,
    this._serverManager,
  );

  final RolesRemoteDataSource _rolesRemoteDataSource;
  final AppDatabase _database;
  final ServerManager _serverManager;

  final Map<String, RoleEntity> _rolesByName = {};

  String get _serverId => _serverManager.activeServerUrl;

  /// يعيد ملء الكاش من قاعدة البيانات المحلية.
  Future<void> hydrateCache() async {
    final rows = await (_database.select(
      _database.cachedRoles,
    )..where((t) => t.serverId.equals(_serverId))).get();
    _rolesByName.clear();
    for (final row in rows) {
      _rolesByName[row.name] = _entityFromRow(row);
    }
  }

  /// يجلب الأدوار الناقصة من الـ API ويخزنها محلياً.
  Future<void> ensureRolesLoaded(List<String> roleNames) async {
    final missing = roleNames
        .where((name) => !_rolesByName.containsKey(name))
        .toSet();
    if (missing.isEmpty) {
      return;
    }
    try {
      final dtos = await _rolesRemoteDataSource.getRolesByNames(
        missing.toList(),
      );
      for (final dto in dtos) {
        final name = dto.name;
        if (name.isEmpty) {
          continue;
        }
        final entity = RoleEntity(
          id: dto.id,
          name: name,
          displayName: dto.displayName,
          description: dto.description,
          permissions: dto.permissions,
          schemeManaged: dto.schemeManaged,
          builtIn: dto.builtIn,
        );
        _rolesByName[name] = entity;
        await _storeRole(entity);
      }
    } catch (_) {
      // بدون اتصال: تبقى الأدوار كما هي في الكاش وتكون الفحوصات متحفظة.
    }
  }

  /// فحص متزامن لصلاحية على دور واحد (بدون شبكة).
  bool hasRolePermission(String roleName, String permission) {
    if (roleName == Permissions.systemAdminRole) {
      return true;
    }
    final role = _rolesByName[roleName];
    return role?.hasPermission(permission) ?? false;
  }

  /// فحص متزامن عبر قائمة أدوار (بدون شبكة).
  bool hasPermissionForRoles(List<String> roles, String permission) {
    return roles.any((role) => hasRolePermission(role, permission));
  }

  /// فحص كامل: يجلب أدوار المستخدم من الكاش المحلي ثم يفحص الصلاحية.
  ///
  /// [resourceId] محجوزة للفحص على مستوى الفريق/القناة في مرحلة لاحقة.
  Future<bool> hasPermission({
    required String userId,
    required String permission,
    String? resourceId,
  }) async {
    final roles = await _rolesForUser(userId);
    return hasPermissionForRoles(roles, permission);
  }

  /// يقرأ أدوار المستخدم من جدول [CachedUsers] (عمود roles مفصول بمسافات).
  Future<List<String>> _rolesForUser(String userId) async {
    final row =
        await (_database.select(
              _database.cachedUsers,
            )..where((t) => t.serverId.equals(_serverId) & t.id.equals(userId)))
            .getSingleOrNull();
    if (row == null) {
      return const [];
    }
    final roles = row.roles.split(' ').where((r) => r.isNotEmpty).toList();
    await ensureRolesLoaded(roles);
    return roles;
  }

  Future<void> _storeRole(RoleEntity entity) async {
    await _database.cachedRoles.insertOnConflictUpdate(
      CachedRolesCompanion.insert(
        serverId: _serverId,
        name: entity.name,
        id: entity.id,
        displayName: Value(entity.displayName),
        permissions: jsonEncode(entity.permissions),
        schemeManaged: Value(entity.schemeManaged),
      ),
    );
  }

  RoleEntity _entityFromRow(CachedRole row) => RoleEntity(
    id: row.id,
    name: row.name,
    displayName: row.displayName,
    permissions: _decodePermissions(row.permissions),
    schemeManaged: row.schemeManaged,
  );

  List<String> _decodePermissions(String raw) {
    try {
      final decoded = jsonDecode(raw);
      return (decoded as List<dynamic>).map((e) => e.toString()).toList();
    } catch (_) {
      return const [];
    }
  }
}
