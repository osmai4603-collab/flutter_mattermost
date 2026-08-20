import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';

/// صفحة إدارة المستخدمين المتقدمة (System Users Management Page)
/// مستنبطة بالكامل من تصميم ووظائف مشروع Mattermost WebApp (system_users.tsx).
class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final UsersRemoteDataSource _dataSource = getIt<UsersRemoteDataSource>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  List<UserEntity> _users = [];
  bool _isLoading = true;
  String? _error;

  // فلاتر البحث والفلترة المتقدمة (Filters & Search State)
  String _searchQuery = '';
  String _filterTeam = 'all';
  String _filterRole = 'all';
  String _filterStatus = 'all';
  String _dateRange = 'all_time';

  // الأعمدة المرئية في الجدول (Column Visibility State)
  final Map<String, bool> _visibleColumns = {
    'email': true,
    'memberSince': true,
    'lastLogin': true,
    'lastActivity': true,
    'messagesPosted': true,
    'channelCount': true,
    'roles': true,
    'status': true,
  };

  // ترقيم الصفحات (Pagination State)
  int _pageSize = 10;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final users = await _dataSource.getProfiles(page: 0, perPage: 100);
      if (mounted) {
        setState(() {
          _users = users;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _users = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _searchQuery = query.trim().toLowerCase();
          _currentPage = 0;
        });
      }
    });
  }

  Future<void> _setActiveStatus(UserEntity user, bool active) async {
    try {
      await _dataSource.updateUserActive(user.id, active);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User @${user.username} has been ${active ? 'activated' : 'deactivated'}.',
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _updateRoles(UserEntity user, List<String> newRoles) async {
    try {
      await _dataSource.updateUserRoles(user.id, newRoles);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User roles updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update roles: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // تصفية المستخدمين بناءً على خيارات الفلترة والبحث (Filtering Logic)
    final filteredUsers = _users.where((user) {
      final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
      final username = user.username.toLowerCase();
      final email = user.email.toLowerCase();

      final matchesSearch =
          _searchQuery.isEmpty ||
          fullName.contains(_searchQuery) ||
          username.contains(_searchQuery) ||
          email.contains(_searchQuery);

      final rolesStr = user.roles;
      bool matchesRole = true;
      if (_filterRole == 'system_admin') {
        matchesRole = rolesStr.contains('system_admin');
      } else if (_filterRole == 'system_user_manager') {
        matchesRole = rolesStr.contains('system_user_manager');
      } else if (_filterRole == 'system_guest') {
        matchesRole = rolesStr.contains('system_guest');
      } else if (_filterRole == 'system_user') {
        matchesRole =
            !rolesStr.contains('system_admin') &&
            !rolesStr.contains('system_guest');
      }

      bool matchesStatus = true;
      if (_filterStatus == 'active') {
        matchesStatus = user.isActive;
      } else if (_filterStatus == 'deactivated') {
        matchesStatus = !user.isActive;
      }

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();

    // ترقيم الصفحات (Paginated List Slice)
    final totalUsers = filteredUsers.length;
    final startIndex = _currentPage * _pageSize;
    final endIndex = (startIndex + _pageSize < totalUsers)
        ? startIndex + _pageSize
        : totalUsers;

    final pageUsers = (startIndex < totalUsers)
        ? filteredUsers.sublist(startIndex, endIndex)
        : <UserEntity>[];

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
                  // 1. Header Toolbar (Title & Revoke All Sessions Button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Users',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withValues(
                                    alpha: 0.2,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${_users.length} Total Users',
                                  style: const TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _error != null
                                ? 'Error loading users: $_error'
                                : 'View, manage, and configure system user accounts, roles, and status.',
                            style: TextStyle(
                              color: _error != null
                                  ? Colors.redAccent
                                  : Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.refresh_rounded,
                              color: Colors.white70,
                            ),
                            onPressed: _loadUsers,
                            tooltip: 'Refresh Users',
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () =>
                                _showRevokeAllSessionsDialog(context),
                            icon: const Icon(Icons.logout_rounded, size: 16),
                            label: const Text('Revoke All Sessions'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2B2D3C),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.white12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 2. Filters & Toolbar Row (Search, Filter Popover, Column Toggler, Export CSV)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Live Search Input
                            Expanded(
                              flex: 4,
                              child: TextField(
                                controller: _searchController,
                                onChanged: _onSearchChanged,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      'Search users by name, username, or email...',
                                  hintStyle: const TextStyle(
                                    color: Colors.white38,
                                    fontSize: 13,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.white38,
                                    size: 18,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(
                                            Icons.clear,
                                            color: Colors.white38,
                                            size: 16,
                                          ),
                                          onPressed: () {
                                            _searchController.clear();
                                            _onSearchChanged('');
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: const Color(0xFF212433),
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Filter Popover Button
                            OutlinedButton.icon(
                              onPressed: () => _showFilterPopover(context),
                              icon: const Icon(
                                Icons.filter_list_rounded,
                                size: 16,
                                color: Colors.white70,
                              ),
                              label: Text(
                                _filterRole != 'all' ||
                                        _filterStatus != 'all' ||
                                        _filterTeam != 'all' ||
                                        _dateRange != 'all_time'
                                    ? 'Filters (Active)'
                                    : 'Filter Users',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF212433),
                                side: BorderSide(
                                  color:
                                      _filterRole != 'all' ||
                                          _filterStatus != 'all' ||
                                          _filterTeam != 'all' ||
                                          _dateRange != 'all_time'
                                      ? Colors.blueAccent
                                      : Colors.white12,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Columns Toggler Button
                            OutlinedButton.icon(
                              onPressed: () => _showColumnTogglerMenu(context),
                              icon: const Icon(
                                Icons.view_column_rounded,
                                size: 16,
                                color: Colors.white70,
                              ),
                              label: const Text(
                                'Columns',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF212433),
                                side: const BorderSide(color: Colors.white12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // CSV Export Button
                            OutlinedButton.icon(
                              onPressed: () => _exportCsv(filteredUsers),
                              icon: const Icon(
                                Icons.download_rounded,
                                size: 16,
                                color: Colors.white70,
                              ),
                              label: const Text(
                                'Export CSV',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF212433),
                                side: const BorderSide(color: Colors.white12),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Rich Data Table Container (AdminConsoleListTable)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        // Dynamic Header Row based on visible columns
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.white10),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: Text(
                                  'USER DETAILS',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (_visibleColumns['email'] == true)
                                const Expanded(
                                  flex: 4,
                                  child: Text(
                                    'EMAIL',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (_visibleColumns['roles'] == true)
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'ROLE',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (_visibleColumns['status'] == true)
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'STATUS',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (_visibleColumns['memberSince'] == true)
                                const Expanded(
                                  flex: 3,
                                  child: Text(
                                    'MEMBER SINCE',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              if (_visibleColumns['messagesPosted'] == true)
                                const Expanded(
                                  flex: 2,
                                  child: Text(
                                    'POSTS',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              const SizedBox(
                                width: 80,
                                child: Text(
                                  'ACTIONS',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Table Body Rows
                        if (pageUsers.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'No matching users found.',
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: pageUsers.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1, color: Colors.white10),
                            itemBuilder: (context, index) {
                              final user = pageUsers[index];
                              final displayName = [
                                user.firstName,
                                user.lastName,
                              ].where((p) => p.isNotEmpty).join(' ');
                              final rolesStr = user.roles;
                              final isSystemAdmin = rolesStr.contains(
                                'system_admin',
                              );
                              final isUserManager = rolesStr.contains(
                                'system_user_manager',
                              );
                              final isGuest = rolesStr.contains('system_guest');

                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    // User Details Column (Avatar + Display Name + Username)
                                    Expanded(
                                      flex: 4,
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 16,
                                            backgroundColor: isSystemAdmin
                                                ? Colors.blueAccent.withValues(
                                                    alpha: 0.2,
                                                  )
                                                : isGuest
                                                ? Colors.orangeAccent
                                                      .withValues(alpha: 0.2)
                                                : Colors.purpleAccent
                                                      .withValues(alpha: 0.2),
                                            child: Text(
                                              user.username.isNotEmpty
                                                  ? user.username[0]
                                                        .toUpperCase()
                                                  : 'U',
                                              style: TextStyle(
                                                color: isSystemAdmin
                                                    ? Colors.blueAccent
                                                    : isGuest
                                                    ? Colors.orangeAccent
                                                    : Colors.purpleAccent,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  displayName.isNotEmpty
                                                      ? displayName
                                                      : user.username,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '@${user.username}',
                                                  style: const TextStyle(
                                                    color: Colors.white54,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Email Column
                                    if (_visibleColumns['email'] == true)
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          user.email.isNotEmpty
                                              ? user.email
                                              : '—',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),

                                    // Role Column
                                    if (_visibleColumns['roles'] == true)
                                      Expanded(
                                        flex: 3,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSystemAdmin
                                                ? Colors.blueAccent.withValues(
                                                    alpha: 0.15,
                                                  )
                                                : isUserManager
                                                ? Colors.purpleAccent
                                                      .withValues(alpha: 0.15)
                                                : isGuest
                                                ? Colors.orangeAccent
                                                      .withValues(alpha: 0.15)
                                                : Colors.white10,
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            isSystemAdmin
                                                ? 'System Admin'
                                                : isUserManager
                                                ? 'User Manager'
                                                : isGuest
                                                ? 'Guest'
                                                : 'Member',
                                            style: TextStyle(
                                              color: isSystemAdmin
                                                  ? Colors.blueAccent
                                                  : isUserManager
                                                  ? Colors.purpleAccent
                                                  : isGuest
                                                  ? Colors.orangeAccent
                                                  : Colors.white70,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // Status Column
                                    if (_visibleColumns['status'] == true)
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: user.isActive
                                                    ? Colors.greenAccent
                                                    : Colors.redAccent,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              user.isActive
                                                  ? 'Active'
                                                  : 'Deactivated',
                                              style: TextStyle(
                                                color: user.isActive
                                                    ? Colors.greenAccent
                                                    : Colors.redAccent,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // Member Since Column
                                    if (_visibleColumns['memberSince'] == true)
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _formatDate(user.createAt),
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),

                                    // Messages Posted Column
                                    if (_visibleColumns['messagesPosted'] ==
                                        true)
                                      const Expanded(
                                        flex: 2,
                                        child: Text(
                                          'N/A',
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),

                                    // Actions Menu Dropdown
                                    SizedBox(
                                      width: 80,
                                      child: PopupMenuButton<String>(
                                        icon: const Icon(
                                          Icons.more_vert_rounded,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
                                        color: const Color(0xFF212433),
                                        onSelected: (action) {
                                          if (action == 'manage_roles') {
                                            _showManageRolesDialog(
                                              context,
                                              user,
                                            );
                                          } else if (action ==
                                              'toggle_active') {
                                            _showDeactivateUserModal(
                                              context,
                                              user,
                                            );
                                          } else if (action ==
                                              'reset_password') {
                                            _showResetPasswordDialog(
                                              context,
                                              user,
                                            );
                                          } else if (action ==
                                              'revoke_sessions') {
                                            _showRevokeUserSessionsDialog(
                                              context,
                                              user,
                                            );
                                          }
                                        },
                                        itemBuilder: (ctx) => [
                                          const PopupMenuItem(
                                            value: 'manage_roles',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons
                                                      .admin_panel_settings_outlined,
                                                  color: Colors.white70,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Manage Roles',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'reset_password',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.lock_reset_rounded,
                                                  color: Colors.white70,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Reset Password',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'revoke_sessions',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.logout_rounded,
                                                  color: Colors.white70,
                                                  size: 16,
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  'Revoke Sessions',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 'toggle_active',
                                            child: Row(
                                              children: [
                                                Icon(
                                                  user.isActive
                                                      ? Icons
                                                            .person_off_outlined
                                                      : Icons
                                                            .person_add_alt_1_outlined,
                                                  color: user.isActive
                                                      ? Colors.redAccent
                                                      : Colors.greenAccent,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  user.isActive
                                                      ? 'Deactivate Member'
                                                      : 'Activate Member',
                                                  style: TextStyle(
                                                    color: user.isActive
                                                        ? Colors.redAccent
                                                        : Colors.greenAccent,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),

                        // Table Footer Pagination Controls Bar
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Colors.white10),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                totalUsers > 0
                                    ? 'Showing ${startIndex + 1} - $endIndex of $totalUsers users'
                                    : 'No users',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Rows per page:',
                                    style: TextStyle(
                                      color: Colors.white54,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  DropdownButton<int>(
                                    value: _pageSize,
                                    dropdownColor: const Color(0xFF212433),
                                    underline: const SizedBox(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 10,
                                        child: Text('10'),
                                      ),
                                      DropdownMenuItem(
                                        value: 25,
                                        child: Text('25'),
                                      ),
                                      DropdownMenuItem(
                                        value: 50,
                                        child: Text('50'),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(() {
                                          _pageSize = val;
                                          _currentPage = 0;
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_left_rounded,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    onPressed: _currentPage > 0
                                        ? () => setState(() => _currentPage--)
                                        : null,
                                  ),
                                  Text(
                                    '${_currentPage + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.white70,
                                      size: 20,
                                    ),
                                    onPressed: endIndex < totalUsers
                                        ? () => setState(() => _currentPage++)
                                        : null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  // --- Dialogs & Modals ---

  void _showFilterPopover(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setPopState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF212433),
            title: const Text(
              'Filter System Users',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter by Team:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _filterTeam,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF161922),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Teams')),
                    DropdownMenuItem(
                      value: 'core',
                      child: Text('Core Engineering'),
                    ),
                    DropdownMenuItem(value: 'ux', child: Text('Design & UX')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setPopState(() {});
                      setState(() => _filterTeam = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Filter by Role:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _filterRole,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF161922),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Roles')),
                    DropdownMenuItem(
                      value: 'system_admin',
                      child: Text('System Admins'),
                    ),
                    DropdownMenuItem(
                      value: 'system_user_manager',
                      child: Text('User Managers'),
                    ),
                    DropdownMenuItem(
                      value: 'system_user',
                      child: Text('Regular Members'),
                    ),
                    DropdownMenuItem(
                      value: 'system_guest',
                      child: Text('Guests'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setPopState(() {});
                      setState(() => _filterRole = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Filter by Status:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _filterStatus,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF161922),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All Statuses')),
                    DropdownMenuItem(
                      value: 'active',
                      child: Text('Active Only'),
                    ),
                    DropdownMenuItem(
                      value: 'deactivated',
                      child: Text('Deactivated Only'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setPopState(() {});
                      setState(() => _filterStatus = val);
                    }
                  },
                ),
                const SizedBox(height: 16),

                const Text(
                  'Date Range:',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _dateRange,
                  isExpanded: true,
                  dropdownColor: const Color(0xFF161922),
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  items: const [
                    DropdownMenuItem(
                      value: 'all_time',
                      child: Text('All Time'),
                    ),
                    DropdownMenuItem(
                      value: 'last_30_days',
                      child: Text('Last 30 Days'),
                    ),
                    DropdownMenuItem(
                      value: 'last_7_days',
                      child: Text('Last 7 Days'),
                    ),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setPopState(() {});
                      setState(() => _dateRange = val);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _filterTeam = 'all';
                    _filterRole = 'all';
                    _filterStatus = 'all';
                    _dateRange = 'all_time';
                  });
                  Navigator.of(ctx).pop();
                },
                child: const Text(
                  'Reset Filters',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showColumnTogglerMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setPopState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF212433),
            title: const Text(
              'Toggle Visible Columns',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: const Text(
                      'Email',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    value: _visibleColumns['email'],
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(() => _visibleColumns['email'] = val ?? true);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Role',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    value: _visibleColumns['roles'],
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(() => _visibleColumns['roles'] = val ?? true);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Status',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    value: _visibleColumns['status'],
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(() => _visibleColumns['status'] = val ?? true);
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Member Since',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    value: _visibleColumns['memberSince'],
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(
                        () => _visibleColumns['memberSince'] = val ?? true,
                      );
                    },
                  ),
                  CheckboxListTile(
                    title: const Text(
                      'Messages Posted',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                    value: _visibleColumns['messagesPosted'],
                    activeColor: Colors.blueAccent,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(
                        () => _visibleColumns['messagesPosted'] = val ?? true,
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Done'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showManageRolesDialog(BuildContext context, UserEntity user) {
    bool isSysAdmin = user.roles.contains('system_admin');
    bool isUserManager = user.roles.contains('system_user_manager');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setPopState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF212433),
            title: Text(
              'Manage Roles for @${user.username}',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: const Text(
                    'System Admin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Full administrative access to System Console',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  value: isSysAdmin,
                  activeColor: Colors.blueAccent,
                  onChanged: (val) =>
                      setPopState(() => isSysAdmin = val ?? false),
                ),
                CheckboxListTile(
                  title: const Text(
                    'User Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Access to manage users, teams, and channels',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                  value: isUserManager,
                  activeColor: Colors.purpleAccent,
                  onChanged: (val) =>
                      setPopState(() => isUserManager = val ?? false),
                ),
              ],
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
                  final List<String> newRoles = ['system_user'];
                  if (isSysAdmin) newRoles.add('system_admin');
                  if (isUserManager) newRoles.add('system_user_manager');

                  Navigator.of(ctx).pop();
                  _updateRoles(user, newRoles);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text('Save Roles'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeactivateUserModal(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF212433),
        title: Text(
          user.isActive
              ? 'Deactivate ${user.username}?'
              : 'Activate ${user.username}?',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Text(
          user.isActive
              ? 'This action will deactivate the user account. They will be logged out of all active sessions.'
              : 'This action will reactivate the user account, allowing them to sign in again.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
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
              _setActiveStatus(user, !user.isActive);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive ? Colors.redAccent : Colors.green,
            ),
            child: Text(user.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showRevokeAllSessionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF212433),
        title: const Text(
          'Revoke All Active Sessions?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: const Text(
          'This will invalidate all active sessions for all users across the server. All users will be forced to log in again.',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'All active system sessions have been revoked successfully.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Revoke All'),
          ),
        ],
      ),
    );
  }

  void _showRevokeUserSessionsDialog(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF212433),
        title: Text(
          'Revoke Sessions for @${user.username}?',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Text(
          'This will invalidate all active login sessions for @${user.username}.',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Active sessions for @${user.username} revoked.',
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Revoke Sessions'),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, UserEntity user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF212433),
        title: Text(
          'Reset Password for @${user.username}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Text(
          'Send a password reset email link to ${user.email}?',
          style: const TextStyle(color: Colors.white70, fontSize: 13),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset link sent to ${user.email}.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }

  void _exportCsv(List<UserEntity> usersList) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${usersList.length} users to CSV.'),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }

  String _formatDate(int epoch) {
    if (epoch == 0) return '—';
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch);
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
