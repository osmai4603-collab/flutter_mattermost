import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_roles_schemes_repository.dart';

/// صفحة الإدارة المفوضة والأدوار الإدارية (Delegated Granular Administration Page)
/// تتيح للمسؤولين تعيين وإدارة الأدوار الإدارية باستخدام كائنات RoleEntity.
class AdminConsoleDelegatedAdminPage extends StatefulWidget {
  const AdminConsoleDelegatedAdminPage({super.key});

  @override
  State<AdminConsoleDelegatedAdminPage> createState() =>
      _AdminConsoleDelegatedAdminPageState();
}

class _AdminConsoleDelegatedAdminPageState
    extends State<AdminConsoleDelegatedAdminPage> {
  bool _isLoading = true;
  List<RoleEntity> _systemRoles = [];

  final List<RoleEntity> _defaultSystemRoles = const [
    RoleEntity(
      id: 'system_admin',
      name: 'system_admin',
      displayName: 'System Admin',
      description: 'Full administrative access to system console settings, security, integrations, and server logs.',
      builtIn: true,
    ),
    RoleEntity(
      id: 'system_manager',
      name: 'system_manager',
      displayName: 'System Manager',
      description: 'Read and write access to system configuration, integrations, web server, and developer settings.',
      builtIn: false,
    ),
    RoleEntity(
      id: 'system_user_manager',
      name: 'system_user_manager',
      displayName: 'User Manager',
      description: 'Access to manage system users, teams, public/private channels, custom user groups, and guest access.',
      builtIn: false,
    ),
    RoleEntity(
      id: 'system_custom_group_admin',
      name: 'system_custom_group_admin',
      displayName: 'Custom Group Admin',
      description: 'Access to manage custom user groups, group sync, and group LDAP mappings.',
      builtIn: false,
    ),
    RoleEntity(
      id: 'system_shared_channel_manager',
      name: 'system_shared_channel_manager',
      displayName: 'Shared Channel Manager',
      description: 'Access to manage shared channel invites, cross-cluster connections, and remote cluster settings.',
      builtIn: false,
    ),
    RoleEntity(
      id: 'system_read_only_admin',
      name: 'system_read_only_admin',
      displayName: 'Read Only Admin',
      description: 'Read-only view of system console settings and statistics without permission to modify configuration.',
      builtIn: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() => _isLoading = true);
    try {
      if (getIt.isRegistered<AdminRolesSchemesRepository>()) {
        final rolesRepo = getIt<AdminRolesSchemesRepository>();
        final rolesList = await rolesRepo.getRoles();
        if (rolesList.isNotEmpty) {
          _systemRoles = rolesList;
        } else {
          _systemRoles = List.from(_defaultSystemRoles);
        }
      } else {
        _systemRoles = List.from(_defaultSystemRoles);
      }
    } catch (_) {
      _systemRoles = List.from(_defaultSystemRoles);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Header & Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Delegated Granular Administration',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Manage different levels of administrative access to the System Console.',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                            onPressed: _loadRoles,
                            tooltip: 'Refresh System Roles',
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4)),
                            ),
                            child: const Text(
                              'Enterprise Feature',
                              style: TextStyle(
                                color: Colors.purpleAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Info Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.admin_panel_settings_rounded, color: Colors.blueAccent, size: 24),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Delegated Administration allows you to assign targeted management privileges to specific team leads without granting full System Admin access.',
                            style: TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. Roles Data Grid / Table
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Table Title Header
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'System Administrative Roles',
                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${_systemRoles.length} System Roles Defined',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1, color: Colors.white10),

                        // Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          color: const Color(0xFF1B1E2B),
                          child: Row(
                            children: const [
                              Expanded(flex: 3, child: Text('ROLE NAME', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(flex: 5, child: Text('DESCRIPTION', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('TYPE', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('ASSIGNED USERS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              SizedBox(width: 80, child: Text('ACTIONS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),

                        // Data Rows
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _systemRoles.length,
                          separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.white10),
                          itemBuilder: (context, index) {
                            final role = _systemRoles[index];
                            final isSystemAdmin = role.name == 'system_admin';
                            final displayName = role.displayName.isNotEmpty ? role.displayName : role.name;

                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      children: [
                                        Icon(
                                          isSystemAdmin ? Icons.shield_rounded : Icons.verified_user_outlined,
                                          color: isSystemAdmin ? Colors.blueAccent : Colors.purpleAccent,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            displayName,
                                            style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      role.description.isNotEmpty
                                          ? role.description
                                          : 'System administrative role privileges.',
                                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isSystemAdmin
                                            ? Colors.blueAccent.withValues(alpha: 0.15)
                                            : Colors.purpleAccent.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        isSystemAdmin ? 'System Role' : 'Delegated Role',
                                        style: TextStyle(
                                          color: isSystemAdmin ? Colors.blueAccent : Colors.purpleAccent,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 2,
                                    child: Text(
                                      '4 users assigned',
                                      style: TextStyle(color: Colors.white70, fontSize: 12),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 80,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
