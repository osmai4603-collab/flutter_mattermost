import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/role_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/scheme_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_roles_schemes_repository.dart';

/// صفحة الأدوار والمخططات (Roles & Schemes).
class AdminConsoleRolesSchemesPage extends StatefulWidget {
  const AdminConsoleRolesSchemesPage({super.key});

  @override
  State<AdminConsoleRolesSchemesPage> createState() => _AdminConsoleRolesSchemesPageState();
}

class _AdminConsoleRolesSchemesPageState extends State<AdminConsoleRolesSchemesPage> {
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
        _repository.getSchemes(),
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
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load roles: $_error',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                )
              : _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.admin_panel_settings_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          SizedBox(width: 10),
          Text(
            'Roles & Schemes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Roles (${_roles.length})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_roles.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'No roles returned by the server',
                style: TextStyle(color: Colors.white38),
              ),
            )
          else
            for (final role in _roles)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF181825),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.workspace_premium_outlined,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.name.isNotEmpty ? role.name : '—',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          if (role.description.isNotEmpty)
                            Text(
                              role.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                    Text(
                      '${role.permissions.length} permissions',
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 20),
          Text(
            'Schemes (${_schemes.length})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_schemes.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'No schemes defined',
                style: TextStyle(color: Colors.white38),
              ),
            )
          else
            for (final scheme in _schemes)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF181825),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_tree_outlined,
                      color: Colors.lightBlueAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            scheme.name.isNotEmpty ? scheme.name : '—',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Scope: ${scheme.scope.isNotEmpty ? scheme.scope : '—'}',
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete Scheme',
                      onPressed: () => _deleteScheme(scheme),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.white38,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
