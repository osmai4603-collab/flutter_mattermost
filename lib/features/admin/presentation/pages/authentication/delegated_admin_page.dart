import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_roles_schemes_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';

class AdminConsoleDelegatedAdminPage extends StatefulWidget {
  const AdminConsoleDelegatedAdminPage({super.key});

  @override
  State<AdminConsoleDelegatedAdminPage> createState() => _AdminConsoleDelegatedAdminPageState();
}

class _AdminConsoleDelegatedAdminPageState extends State<AdminConsoleDelegatedAdminPage> {
  bool _isLoading = true;
  String? _error;
  List<RoleEntity> _systemRoles = [];

  final List<RoleEntity> _defaultSystemRoles = const [
    RoleEntity(id: 'system_admin', name: 'system_admin', displayName: 'System Admin', description: 'Full administrative access to system console settings, security, integrations, and server logs.', builtIn: true),
    RoleEntity(id: 'system_manager', name: 'system_manager', displayName: 'System Manager', description: 'Read and write access to system configuration, integrations, web server, and developer settings.', builtIn: false),
    RoleEntity(id: 'system_user_manager', name: 'system_user_manager', displayName: 'User Manager', description: 'Access to manage system users, teams, public/private channels, custom user groups, and guest access.', builtIn: false),
    RoleEntity(id: 'system_custom_group_admin', name: 'system_custom_group_admin', displayName: 'Custom Group Admin', description: 'Access to manage custom user groups, group sync, and group LDAP mappings.', builtIn: false),
    RoleEntity(id: 'system_shared_channel_manager', name: 'system_shared_channel_manager', displayName: 'Shared Channel Manager', description: 'Access to manage shared channel invites, cross-cluster connections, and remote cluster settings.', builtIn: false),
    RoleEntity(id: 'system_read_only_admin', name: 'system_read_only_admin', displayName: 'Read Only Admin', description: 'Read-only view of system console settings and statistics without permission to modify configuration.', builtIn: false),
  ];

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    setState(() { _isLoading = true; _error = null; });
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToRoleDetail(RoleEntity role) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _RoleDetailPage(role: role),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
                      const SizedBox(height: 12),
                      Text('Error: $_error', style: const TextStyle(color: Colors.redAccent)),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(onPressed: _loadRoles, icon: const Icon(Icons.refresh, size: 16), label: const Text('Retry'), style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      _buildInfoBanner(),
                      const SizedBox(height: 24),
                      _buildRolesTable(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Delegated Granular Administration', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4)),
                  ),
                  child: const Text('Enterprise Feature', style: TextStyle(color: Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Text('Manage different levels of administrative access to the System Console.', style: TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
        Row(
          children: [
            IconButton(icon: const Icon(Icons.refresh_rounded, color: Colors.white70), onPressed: _loadRoles, tooltip: 'Refresh'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoBanner() {
    return Container(
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
    );
  }

  Widget _buildRolesTable() {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF161922), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('System Administrative Roles', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_systemRoles.length} roles', style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
          const Divider(height: 1, color: Colors.white10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: const Color(0xFF1B1E2B),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('ROLE NAME', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 5, child: Text('DESCRIPTION', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('TYPE', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('PERMISSIONS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                SizedBox(width: 80, child: Text('ACTIONS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _systemRoles.length,
            separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.white10),
            itemBuilder: (context, index) {
              final role = _systemRoles[index];
              final isSystemAdmin = role.name == 'system_admin';
              final displayName = role.displayName.isNotEmpty ? role.displayName : role.name;

              return InkWell(
                onTap: () => _navigateToRoleDetail(role),
                child: Container(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(displayName, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  Text('@${role.name}', style: const TextStyle(color: Colors.white54, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Text(
                          role.description.isNotEmpty ? role.description : 'System administrative role privileges.',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSystemAdmin ? Colors.blueAccent.withValues(alpha: 0.15) : Colors.purpleAccent.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isSystemAdmin ? 'System Role' : (role.builtIn ? 'Built-in' : 'Delegated'),
                            style: TextStyle(color: isSystemAdmin ? Colors.blueAccent : Colors.purpleAccent, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text('${role.permissions.length} perms', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      ),
                      SizedBox(
                        width: 80,
                        child: IconButton(
                          icon: const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 20),
                          onPressed: () => _navigateToRoleDetail(role),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RoleDetailPage extends StatefulWidget {
  final RoleEntity role;

  const _RoleDetailPage({required this.role});

  @override
  State<_RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends State<_RoleDetailPage> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  late List<String> _permissions;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.role.displayName);
    _descCtrl = TextEditingController(text: widget.role.description);
    _permissions = List.from(widget.role.permissions);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _togglePermission(String perm) {
    setState(() {
      if (_permissions.contains(perm)) {
        _permissions.remove(perm);
      } else {
        _permissions.add(perm);
      }
      _hasChanges = true;
    });
  }

  Future<void> _saveRole() async {
    if (!getIt.isRegistered<AdminRolesSchemesRepository>()) return;
    try {
      final repo = getIt<AdminRolesSchemesRepository>();
      await repo.patchRole(
        widget.role.id,
        displayName: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        permissions: _permissions,
      );
      if (!mounted) return;
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Role updated successfully.'), backgroundColor: Colors.green),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedPermissions = _groupPermissions(_permissions);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(widget.role.name == 'system_admin' ? Icons.shield_rounded : Icons.verified_user_outlined, color: widget.role.name == 'system_admin' ? Colors.blueAccent : Colors.purpleAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.role.displayName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('@${widget.role.name}', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                AdminSettingSection(
                  title: 'Role Details',
                  subtitle: 'Edit the role name and description',
                  children: [
                    AdminSettingField(
                      label: 'Display Name',
                      child: TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        onChanged: (_) => setState(() => _hasChanges = true),
                        decoration: InputDecoration(
                          filled: true, fillColor: const Color(0xFF181825),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                    AdminSettingField(
                      label: 'Description',
                      child: TextField(
                        controller: _descCtrl,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                        maxLines: 2,
                        onChanged: (_) => setState(() => _hasChanges = true),
                        decoration: InputDecoration(
                          filled: true, fillColor: const Color(0xFF181825),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AdminSettingSection(
                  title: 'Permissions',
                  subtitle: '${_permissions.length} permissions assigned',
                  children: [
                    ...groupedPermissions.entries.map((entry) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFF181825), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry.key, style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          ...entry.value.map((perm) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 32,
                                  height: 20,
                                  child: Switch(
                                    value: _permissions.contains(perm),
                                    activeTrackColor: Colors.blueAccent.withValues(alpha: 0.5),
                                    onChanged: (_) => _togglePermission(perm),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(perm, style: const TextStyle(color: Colors.white70, fontSize: 11)),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    )),
                    if (_permissions.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('No permissions assigned to this role.', style: TextStyle(color: Colors.white38, fontSize: 13)),
                      ),
                  ],
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
          if (_hasChanges)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Color(0xFF161922), border: Border(top: BorderSide(color: Colors.white10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _nameCtrl.text = widget.role.displayName;
                          _descCtrl.text = widget.role.description;
                          _permissions = List.from(widget.role.permissions);
                          _hasChanges = false;
                        });
                      },
                      child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _saveRole, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent), child: const Text('Save')),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Map<String, List<String>> _groupPermissions(List<String> permissions) {
    final Map<String, List<String>> grouped = {};
    for (final perm in permissions) {
      final parts = perm.split('.');
      final category = parts.isNotEmpty ? parts[0] : 'other';
      final displayName = _formatCategoryName(category);
      grouped.putIfAbsent(displayName, () => []).add(perm);
    }
    return grouped;
  }

  String _formatCategoryName(String key) {
    const map = {
      'system': 'System',
      'team': 'Team',
      'channel': 'Channel',
      'user': 'User',
      'plugin': 'Plugin',
      'playbook': 'Playbook',
      'post': 'Posts',
    };
    return map[key] ?? key.toUpperCase();
  }
}
