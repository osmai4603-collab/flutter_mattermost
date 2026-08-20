import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mattermost/app/routes/admin_console_route.dart';
import 'package:flutter_mattermost/app/routes/app_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/scheme_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_roles_schemes_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/pages/users_management/team_override_scheme_page.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:go_router/go_router.dart';

class AdminConsolePermissionsPage extends StatefulWidget {
  const AdminConsolePermissionsPage({super.key});

  @override
  State<AdminConsolePermissionsPage> createState() =>
      _AdminConsolePermissionsPageState();
}

class _AdminConsolePermissionsPageState
    extends State<AdminConsolePermissionsPage> {
  final AdminRolesSchemesRepository _repository =
      getIt<AdminRolesSchemesRepository>();

  List<RoleEntity> _roles = [];
  List<SchemeEntity> _schemes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        _repository.getRoles(),
        _repository.getSchemes(scope: 'team'),
      ]);
      if (!mounted) return;
      setState(() {
        _roles = results[0] as List<RoleEntity>;
        _schemes = results[1] as List<SchemeEntity>;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteScheme(SchemeEntity scheme) async {
    try {
      await _repository.deleteScheme(scheme.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Scheme "${scheme.name}" deleted.'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _createScheme(
    String name,
    String displayName,
    String description,
  ) async {
    try {
      await _repository.createScheme(
        name: name,
        displayName: displayName,
        description: description,
        scope: 'team',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scheme created successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void _navigateToSystemScheme() {
    // appRouter.go(AdminConsoleRoutes.systemScheme);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            SystemSchemePage(repository: _repository, roles: _roles),
      ),
    );
  }

  void _navigateToSchemeDetail(SchemeEntity scheme) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _SchemeDetailPage(
          repository: _repository,
          scheme: scheme,
          roles: _roles,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: .centerStart,
            child: Text(
              'Permission Schemes',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : _error != null
          ? _buildErrorWidget()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: 870,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(thickness: 0.5, height: 0),
                    noticeWidget(),
                    const SizedBox(height: 24),
                    _buildSystemSchemePanel(),
                    const SizedBox(height: 20),
                    _buildTeamOverrideSchemesPanel(),
                  ],
                ),
              ),
            ),
    );
  }

  Center _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
          const SizedBox(height: 12),
          Text(
            'Error: $_error',
            style: const TextStyle(color: Colors.redAccent, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _load,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          ),
        ],
      ),
    );
  }

  Widget noticeWidget() {
    final colors = AppTheme.of(context);
    return Container(
      padding: .all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.30,
          color: colors.centerChannelColor.withValues(alpha: 0.20),
        ),
        color: colors.centerChannelBg,
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: colors.linkColor, fontSize: 13, height: 1.50),

          text:
              'Permission Schemes set the default permissions for Team Admins, Channel Admins and everyone else. Learn more about permission schemes in our. ',
          children: [TextSpan(text: 'documentation')],
        ),
      ),
    );
  }

  Widget _buildSystemSchemePanel() {
    final colors = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.20),
          width: 0.30,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Scheme',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.centerChannelColor,
                    ),
                    text:
                        'Set the default permissions inherited by all teams unless a ',
                    children: [
                      TextSpan(
                        text: 'Team Override Scheme',
                        style: TextStyle(color: colors.buttonBg, fontSize: 13),
                      ),
                      TextSpan(text: ' is applied.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: .circular(2)),
              padding: .all(16),
            ),
            onPressed: _navigateToSystemScheme,
            child: Text('Edit Scheme'),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamOverrideSchemesPanel() {
    final colors = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.20),
          width: 0.30,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'Team Override Schemes',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.centerChannelColor,
                        ),
                        text:
                            'Use when specific teams need permission exceptions to the ',
                        children: [
                          TextSpan(
                            text: 'System Scheme.',
                            style: TextStyle(
                              color: colors.buttonBg,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: .circular(2)),
                  padding: .all(16),
                ),
                onPressed: _showCreateSchemeDialog,
                child: Text('New Team Override Scheme'),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Team override schemes allow you to customize permissions for specific teams.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 12),
          if (_schemes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white10),
              ),
              child: Center(
                child: Text(
                  'No team override schemes defined.',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            ..._schemes.map(
              (scheme) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF161922),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: InkWell(
                  onTap: () => _navigateToSchemeDetail(scheme),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.purpleAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_tree_outlined,
                          color: Colors.purpleAccent,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              scheme.name.isNotEmpty ? scheme.name : '—',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Scope: ${scheme.scope}',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'Delete Scheme',
                        onPressed: () => _showDeleteConfirm(scheme),
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white38,
                          size: 18,
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white38,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirm(SchemeEntity scheme) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF212433),
        title: Text(
          'Delete "${scheme.name}"?',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: const Text(
          'This action cannot be undone. Teams using this scheme will revert to the system scheme.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteScheme(scheme);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showCreateSchemeDialog() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TeamOverrideSchemePage()),
    );
    // final nameCtrl = TextEditingController();
    // final displayNameCtrl = TextEditingController();
    // final descCtrl = TextEditingController();

    // showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     backgroundColor: const Color(0xFF212433),
    //     title: const Text(
    //       'Create Team Override Scheme',
    //       style: TextStyle(color: Colors.white, fontSize: 16),
    //     ),
    //     content: SingleChildScrollView(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           TextField(
    //             controller: displayNameCtrl,
    //             style: const TextStyle(color: Colors.white),
    //             decoration: const InputDecoration(
    //               labelText: 'Display Name',
    //               labelStyle: TextStyle(color: Colors.white70),
    //               enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.white38),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 12),
    //           TextField(
    //             controller: nameCtrl,
    //             style: const TextStyle(color: Colors.white),
    //             decoration: const InputDecoration(
    //               labelText: 'Name (URL-safe)',
    //               labelStyle: TextStyle(color: Colors.white70),
    //               enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.white38),
    //               ),
    //             ),
    //           ),
    //           const SizedBox(height: 12),
    //           TextField(
    //             controller: descCtrl,
    //             style: const TextStyle(color: Colors.white),
    //             decoration: const InputDecoration(
    //               labelText: 'Description',
    //               labelStyle: TextStyle(color: Colors.white70),
    //               enabledBorder: UnderlineInputBorder(
    //                 borderSide: BorderSide(color: Colors.white38),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.of(ctx).pop(),
    //         child: const Text(
    //           'Cancel',
    //           style: TextStyle(color: Colors.white54),
    //         ),
    //       ),
    //       ElevatedButton(
    //         onPressed: () {
    //           final name = nameCtrl.text.trim();
    //           final displayName = displayNameCtrl.text.trim();
    //           if (name.isEmpty || displayName.isEmpty) {
    //             ScaffoldMessenger.of(context).showSnackBar(
    //               const SnackBar(
    //                 content: Text('Name and Display Name are required.'),
    //                 backgroundColor: Colors.redAccent,
    //               ),
    //             );
    //             return;
    //           }
    //           Navigator.of(ctx).pop();
    //           _createScheme(name, displayName, descCtrl.text.trim());
    //         },
    //         style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
    //         child: const Text('Create'),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class SystemSchemePage extends StatefulWidget {
  final AdminRolesSchemesRepository repository;
  final List<RoleEntity> roles;

  const SystemSchemePage({
    super.key,
    required this.repository,
    required this.roles,
  });

  @override
  State<SystemSchemePage> createState() => _SystemSchemePageState();
}

class _SystemSchemePageState extends State<SystemSchemePage> {
  bool _loading = true;
  List<RoleEntity> _roles = [];
  List<SchemeEntity> _schemes = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRoles();
  }

  Future<void> _loadRoles() async {
    final repository = getIt<AdminRolesSchemesRepository>();
    // setState(() => _loading = true);
    // try {
    //   final roles = await widget.repository.getRoles();
    //   if (mounted) setState(() => _roles = roles);
    // } catch (e) {
    //   if (mounted) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       SnackBar(
    //         content: Text('Failed to load roles: $e'),
    //         backgroundColor: Colors.redAccent,
    //       ),
    //     );
    //   }
    // } finally {
    //   if (mounted) setState(() => _loading = false);
    // }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        repository.getRoles(),
        repository.getSchemes(scope: 'team'),
      ]);
      if (!mounted) return;
      setState(() {
        _roles = results[0] as List<RoleEntity>;
        _schemes = results[1] as List<SchemeEntity>;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final guests = _roles.where((r) => r.name == 'system_guest').toList();
    final allUsers = _roles
        .where(
          (r) =>
              r.name == 'system_user' ||
              r.name == 'team_user' ||
              r.name == 'channel_user',
        )
        .toList();
    final channelAdmins = _roles
        .where((r) => r.name == 'channel_admin')
        .toList();
    const teamAdmins = <RoleEntity>[];
    final sysAdmins = _roles.where((r) => r.name == 'system_admin').toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_rounded,
                        color: Colors.blueAccent,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'System Scheme',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'The system scheme applies to all teams unless a team override scheme is used.',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  if (guests.isNotEmpty)
                    _buildPermissionSection(
                      'Guests',
                      'Permissions granted to guest users.',
                      guests.first,
                    ),
                  if (allUsers.isNotEmpty)
                    _buildPermissionSection(
                      'All Members',
                      'Permissions granted to all registered users.',
                      allUsers.first,
                    ),
                  if (channelAdmins.isNotEmpty)
                    _buildPermissionSection(
                      'Channel Administrators',
                      'Additional permissions for channel admins.',
                      channelAdmins.first,
                    ),
                  _buildPermissionSection(
                    'Team Administrators',
                    'Additional permissions for team admins.',
                    teamAdmins.isNotEmpty ? teamAdmins.first : _roles.first,
                  ),
                  if (sysAdmins.isNotEmpty)
                    _buildPermissionSection(
                      'System Administrators',
                      'Full administrative access.',
                      sysAdmins.first,
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildPermissionSection(
    String title,
    String subtitle,
    RoleEntity role,
  ) {
    final permissions = role.permissions;
    final groupedPermissions = _groupPermissions(permissions);

    return AdminSettingSection(
      title: title,
      subtitle: subtitle,
      children: [
        Text(
          '${role.name} — ${permissions.length} permissions',
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
        const SizedBox(height: 12),
        ...groupedPermissions.entries.map(
          (entry) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF181825),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: entry.value
                      .map(
                        (perm) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            perm,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
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
    final map = {
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

class _SchemeDetailPage extends StatefulWidget {
  final AdminRolesSchemesRepository repository;
  final SchemeEntity scheme;
  final List<RoleEntity> roles;

  const _SchemeDetailPage({
    required this.repository,
    required this.scheme,
    required this.roles,
  });

  @override
  State<_SchemeDetailPage> createState() => _SchemeDetailPageState();
}

class _SchemeDetailPageState extends State<_SchemeDetailPage> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.scheme.name);
    _descCtrl = TextEditingController(text: widget.scheme.description);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    try {
      await widget.repository.patchScheme(
        widget.scheme.id,
        name: _nameCtrl.text.trim(),
        description: _descCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Scheme saved.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    const Icon(
                      Icons.account_tree_outlined,
                      color: Colors.purpleAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.scheme.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Scope: ${widget.scheme.scope}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 24),
                AdminSettingSection(
                  title: 'Scheme Details',
                  subtitle: 'Edit the scheme name and description',
                  children: [
                    AdminSettingField(
                      label: 'Name',
                      child: TextField(
                        controller: _nameCtrl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        onChanged: (_) => setState(() => _hasChanges = true),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF181825),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    AdminSettingField(
                      label: 'Description',
                      child: TextField(
                        controller: _descCtrl,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        onChanged: (_) => setState(() => _hasChanges = true),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF181825),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white12),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.white12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                AdminSettingSection(
                  title: 'Assigned Teams',
                  subtitle: 'Teams using this override scheme',
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'No teams currently assigned to this scheme.',
                        style: TextStyle(color: Colors.white38, fontSize: 13),
                      ),
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
                decoration: const BoxDecoration(
                  color: Color(0xFF161922),
                  border: Border(top: BorderSide(color: Colors.white10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _nameCtrl.text = widget.scheme.name;
                          _descCtrl.text = widget.scheme.description;
                          _hasChanges = false;
                        });
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
