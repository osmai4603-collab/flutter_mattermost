import 'package:flutter_mattermost/features/admin/domain/entities/license_info_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';

/// Entity representing systemic console access rights for read and write operations.
class ConsoleAccessEntity {
  final Map<String, bool> readPermissions;
  final Map<String, bool> writePermissions;

  const ConsoleAccessEntity({
    required this.readPermissions,
    required this.writePermissions,
  });

  bool canRead(String resourceKey) {
    return readPermissions[resourceKey] ?? true;
  }

  bool canWrite(String resourceKey) {
    return writePermissions[resourceKey] ?? true;
  }

  factory ConsoleAccessEntity.fromUserAndRoles(UserEntity? user, List<String> userRoles) {
    final roles = userRoles.isEmpty && user != null
        ? user.roles.split(' ').where((r) => r.isNotEmpty).toList()
        : userRoles;

    if (roles.contains('system_admin')) {
      return const ConsoleAccessEntity(
        readPermissions: {},
        writePermissions: {},
      );
    }

    if (roles.contains('system_read_only_admin')) {
      return ConsoleAccessEntity(
        readPermissions: const {},
        writePermissions: Map.fromIterable(
          [
            'about', 'reporting', 'user_management', 'environment', 'site',
            'authentication', 'plugins', 'integrations', 'compliance', 'experimental', 'billing',
          ],
          value: (_) => false,
        ),
      );
    }

    // Default system admin or fallback access:
    final readMap = <String, bool>{};
    final writeMap = <String, bool>{};

    return ConsoleAccessEntity(
      readPermissions: readMap,
      writePermissions: writeMap,
    );
  }
}

/// AdminAccessGuard checks whether an admin section should be hidden or disabled based on permissions and license.
class AdminAccessGuard {
  static bool isSectionHidden({
    required String resourceKey,
    required UserEntity? currentUser,
    required ConsoleAccessEntity access,
    LicenseInfoEntity? license,
    bool requiresEnterprise = false,
  }) {
    if (currentUser == null) return true;

    final roles = currentUser.roles.split(' ').where((r) => r.isNotEmpty).toList();
    final isSysAdmin = roles.contains('system_admin') || roles.contains('system_read_only_admin');

    if (!isSysAdmin && roles.every((r) => !r.startsWith('system_'))) {
      return true;
    }

    if (!access.canRead(resourceKey)) {
      return true;
    }

    if (requiresEnterprise && (license == null || license.skuShortName == 'starter')) {
      // Return false so we can display FeatureDiscovery indicator instead of hiding completely, unless explicitly configured
    }

    return false;
  }

  static bool isSectionDisabled({
    required String resourceKey,
    required ConsoleAccessEntity access,
  }) {
    return !access.canWrite(resourceKey);
  }
}
