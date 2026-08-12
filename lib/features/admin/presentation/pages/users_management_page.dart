import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';

/// صفحة إدارة المستخدمين: بحث + عرض الأدوار + تفعيل/إلغاء تفعيل.
class AdminConsoleUsersManagementPage extends StatefulWidget {
  const AdminConsoleUsersManagementPage({super.key});

  @override
  State<AdminConsoleUsersManagementPage> createState() => _AdminConsoleUsersManagementPageState();
}

class _AdminConsoleUsersManagementPageState extends State<AdminConsoleUsersManagementPage> {
  final UsersRemoteDataSource _dataSource = getIt<UsersRemoteDataSource>();
  final _searchController = TextEditingController();
  Timer? _debounce;

  List<UserEntity> _users = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await _dataSource.getProfiles(page: 0, perPage: 60);
      if (mounted) setState(() => _users = users);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _search(String term) async {
    if (term.trim().isEmpty) {
      await _loadAll();
      return;
    }
    setState(() => _loading = true);
    try {
      final users = await _dataSource.autocompleteUsers(term);
      if (mounted) setState(() => _users = users);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () => _search(value));
  }

  Future<void> _setActive(UserEntity user, bool active) async {
    try {
      await _dataSource.updateUserActive(user.id, active);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${user.username} ${active ? 'activated' : 'deactivated'}',
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
      _loadAll();
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

  Future<void> _toggleAdmin(UserEntity user) async {
    final roles = user.roles
        .split(' ')
        .where((r) => r.isNotEmpty)
        .toList();
    try {
      if (roles.contains('system_admin')) {
        await _dataSource.updateUserRoles(
          user.id,
          roles.where((r) => r != 'system_admin').toList(),
        );
      } else {
        await _dataSource.updateUserRoles(user.id, [...roles, 'system_admin']);
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Roles updated')));
      _loadAll();
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
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(child: _buildBody()),
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
          Icon(Icons.people_outline, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'User Management',
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

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white38,
                  size: 18,
                ),
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
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
                  )
                : _error != null
                ? Center(
                    child: Text(
                      'Could not load users: $_error',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  )
                : _buildUserList(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.separated(
      itemCount: _users.length,
      separatorBuilder: (_, _) =>
          const Divider(color: Colors.white10, height: 1),
      itemBuilder: (context, index) {
        final user = _users[index];
        final roles = (user.roles ?? '')
            .split(' ')
            .where((r) => r.isNotEmpty)
            .toList();
        final isAdmin = roles.contains('system_admin');
        final name = [
          user.firstName,
          user.lastName,
        ].where((p) => p.isNotEmpty).join(' ');

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                child: Text(
                  (user.username.isNotEmpty ? user.username[0] : '?')
                      .toUpperCase(),
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty
                          ? '$name (@${user.username})'
                          : '@${user.username}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 4,
                children: [
                  for (final role in roles)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isAdmin
                            ? Colors.blueAccent.withValues(alpha: 0.15)
                            : Colors.white10,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role.replaceFirst('_', ' '),
                        style: TextStyle(
                          color: isAdmin ? Colors.blueAccent : Colors.white54,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              IconButton(
                tooltip: isAdmin ? 'Remove System Admin' : 'Make System Admin',
                onPressed: () => _toggleAdmin(user),
                icon: Icon(
                  isAdmin
                      ? Icons.admin_panel_settings
                      : Icons.admin_panel_settings_outlined,
                  color: isAdmin ? Colors.amberAccent : Colors.white38,
                  size: 18,
                ),
              ),
              Switch(
                value: user.mfaActive,
                onChanged: (value) => _setActive(user, value),
              ),
            ],
          ),
        );
      },
    );
  }
}

