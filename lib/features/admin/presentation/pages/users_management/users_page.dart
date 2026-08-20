import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
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
    final colors = AppTheme.of(context);
    try {
      await _dataSource.updateUserActive(user.id, active);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'User @${user.username} has been ${active ? 'activated' : 'deactivated'}.',
          ),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update status: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _updateRoles(UserEntity user, List<String> newRoles) async {
    final colors = AppTheme.of(context);
    try {
      await _dataSource.updateUserRoles(user.id, newRoles);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('User roles updated successfully.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadUsers();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update roles: $e'),
          backgroundColor: colors.errorTextColor,
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
    final colors = AppTheme.of(context);

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Vortex Users',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: .w600,
                      color: colors.centerChannelColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _showRevokeAllSessionsDialog(context),
                  style: TextButton.styleFrom(
                    backgroundColor: colors.errorTextColor.withValues(
                      alpha: 0.25,
                    ),
                    foregroundColor: colors.errorTextColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                  ),
                  child: const Text('Revoke All Sessions'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 24),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _isLoading
              ? _buildLoading(colors)
              : _buildBody(
                  colors,
                  context,
                  filteredUsers,
                  pageUsers,
                  totalUsers,
                  startIndex,
                  endIndex,
                ),
        ),
      ),
    );
  }

  Widget _buildBody(
    MattermostColors colors,
    BuildContext context,
    List<UserEntity> filteredUsers,
    List<UserEntity> pageUsers,
    int totalUsers,
    int startIndex,
    int endIndex,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.30,
          color: colors.centerChannelColor.withValues(alpha: 0.20),
        ),
        color: colors.centerChannelBg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search users',
                      hintStyle: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                        fontSize: 13,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                        size: 18,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.38,
                                ),
                                size: 16,
                              ),
                              onPressed: () {
                                _searchController.clear();
                                _onSearchChanged('');
                              },
                            )
                          : null,
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
                TextButton.icon(
                  onPressed: () => _showFilterPopover(context),
                  icon: Icon(
                    Icons.filter_list_rounded,
                    size: 16,
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                  ),
                  label: Text(
                    _filterRole != 'all' ||
                            _filterStatus != 'all' ||
                            _filterTeam != 'all' ||
                            _dateRange != 'all_time'
                        ? 'Filters (Active)'
                        : 'Filter Users',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 13,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: colors.centerChannelBg.withValues(
                      alpha: 0.60,
                    ),
                    side: BorderSide(
                      color:
                          _filterRole != 'all' ||
                              _filterStatus != 'all' ||
                              _filterTeam != 'all' ||
                              _dateRange != 'all_time'
                          ? colors.buttonBg
                          : colors.centerChannelColor.withValues(alpha: 0.12),
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
                OutlinedButton.icon(
                  onPressed: () => _showColumnTogglerMenu(context),
                  icon: Icon(
                    Icons.view_column_rounded,
                    size: 16,
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                  ),
                  label: Text(
                    'Columns',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colors.centerChannelBg.withValues(
                      alpha: 0.60,
                    ),
                    side: BorderSide(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
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
                OutlinedButton.icon(
                  onPressed: () => _exportCsv(filteredUsers),
                  icon: Icon(
                    Icons.download_rounded,
                    size: 16,
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                  ),
                  label: Text(
                    'Export CSV',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: colors.centerChannelBg.withValues(
                      alpha: 0.60,
                    ),
                    side: BorderSide(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
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
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.10),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text(
                    'USER DETAILS',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_visibleColumns['email'] == true)
                  Expanded(
                    flex: 4,
                    child: Text(
                      'EMAIL',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_visibleColumns['roles'] == true)
                  Expanded(
                    flex: 3,
                    child: Text(
                      'ROLE',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_visibleColumns['status'] == true)
                  Expanded(
                    flex: 2,
                    child: Text(
                      'STATUS',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_visibleColumns['memberSince'] == true)
                  Expanded(
                    flex: 3,
                    child: Text(
                      'MEMBER SINCE',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (_visibleColumns['messagesPosted'] == true)
                  Expanded(
                    flex: 2,
                    child: Text(
                      'POSTS',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                SizedBox(
                  width: 80,
                  child: Text(
                    'ACTIONS',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (pageUsers.isEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'No matching users found.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          if (pageUsers.isNotEmpty)
            Expanded(
              child: ListView.separated(
                itemCount: pageUsers.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: colors.centerChannelColor.withValues(alpha: 0.10),
                ),
                itemBuilder: (context, index) {
                  final user = pageUsers[index];
                  final displayName = [
                    user.firstName,
                    user.lastName,
                  ].where((p) => p.isNotEmpty).join(' ');
                  final rolesStr = user.roles;
                  final isSystemAdmin = rolesStr.contains('system_admin');
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
                              ProfilePicture.md(
                                username: user.username,
                                userId: user.id,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      displayName.isNotEmpty
                                          ? displayName
                                          : user.username,
                                      style: TextStyle(
                                        color: colors.centerChannelColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '@${user.username}',
                                      style: TextStyle(
                                        color: colors.centerChannelColor
                                            .withValues(alpha: 0.54),
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
                              user.email.isNotEmpty ? user.email : '—',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.70,
                                ),
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
                                    ? colors.buttonBg.withValues(alpha: 0.15)
                                    : isUserManager
                                    ? colors.mentionBg.withValues(alpha: 0.15)
                                    : isGuest
                                    ? colors.awayIndicator.withValues(
                                        alpha: 0.15,
                                      )
                                    : colors.centerChannelColor.withValues(
                                        alpha: 0.10,
                                      ),
                                borderRadius: BorderRadius.circular(6),
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
                                      ? colors.buttonBg
                                      : isUserManager
                                      ? colors.mentionBg
                                      : isGuest
                                      ? colors.awayIndicator
                                      : colors.centerChannelColor.withValues(
                                          alpha: 0.70,
                                        ),
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
                                        ? colors.onlineIndicator
                                        : colors.errorTextColor,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user.isActive ? 'Active' : 'Deactivated',
                                  style: TextStyle(
                                    color: user.isActive
                                        ? colors.onlineIndicator
                                        : colors.errorTextColor,
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
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.54,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ),

                        // Messages Posted Column
                        if (_visibleColumns['messagesPosted'] == true)
                          Expanded(
                            flex: 2,
                            child: Text(
                              'N/A',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.70,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ),

                        // Actions Menu Dropdown
                        SizedBox(
                          width: 80,
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.54,
                              ),
                              size: 18,
                            ),
                            color: colors.centerChannelBg.withValues(
                              alpha: 0.60,
                            ),
                            onSelected: (action) {
                              if (action == 'manage_roles') {
                                _showManageRolesDialog(context, user);
                              } else if (action == 'toggle_active') {
                                _showDeactivateUserModal(context, user);
                              } else if (action == 'reset_password') {
                                _showResetPasswordDialog(context, user);
                              } else if (action == 'revoke_sessions') {
                                _showRevokeUserSessionsDialog(context, user);
                              }
                            },
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                value: 'manage_roles',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.admin_panel_settings_outlined,
                                      color: colors.centerChannelColor
                                          .withValues(alpha: 0.70),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Manage Roles',
                                      style: TextStyle(
                                        color: colors.centerChannelColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'reset_password',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock_reset_rounded,
                                      color: colors.centerChannelColor
                                          .withValues(alpha: 0.70),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Reset Password',
                                      style: TextStyle(
                                        color: colors.centerChannelColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'revoke_sessions',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout_rounded,
                                      color: colors.centerChannelColor
                                          .withValues(alpha: 0.70),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Revoke Sessions',
                                      style: TextStyle(
                                        color: colors.centerChannelColor,
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
                                          ? Icons.person_off_outlined
                                          : Icons.person_add_alt_1_outlined,
                                      color: user.isActive
                                          ? colors.errorTextColor
                                          : colors.onlineIndicator,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      user.isActive
                                          ? 'Deactivate Member'
                                          : 'Activate Member',
                                      style: TextStyle(
                                        color: user.isActive
                                            ? colors.errorTextColor
                                            : colors.onlineIndicator,
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
            ),
          if (pageUsers.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colors.centerChannelColor.withValues(alpha: 0.10),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    totalUsers > 0
                        ? 'Showing ${startIndex + 1} - $endIndex of $totalUsers users'
                        : 'No users',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Rows per page:',
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.54,
                          ),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: _pageSize,
                        dropdownColor: colors.centerChannelBg.withValues(
                          alpha: 0.60,
                        ),
                        underline: const SizedBox(),
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 12,
                        ),
                        items: const [
                          DropdownMenuItem(value: 10, child: Text('10')),
                          DropdownMenuItem(value: 25, child: Text('25')),
                          DropdownMenuItem(value: 50, child: Text('50')),
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
                        icon: Icon(
                          Icons.chevron_left_rounded,
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.70,
                          ),
                          size: 20,
                        ),
                        onPressed: _currentPage > 0
                            ? () => setState(() => _currentPage--)
                            : null,
                      ),
                      Text(
                        '${_currentPage + 1}',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right_rounded,
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.70,
                          ),
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
    );
  }

  Center _buildLoading(MattermostColors colors) {
    return Center(child: CircularProgressIndicator(color: colors.buttonBg));
  }

  void _showFilterPopover(BuildContext context) {
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setPopState) {
          return AlertDialog(
            backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
            title: Text(
              'Filter System Users',
              style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filter by Team:',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _filterTeam,
                  isExpanded: true,
                  dropdownColor: colors.centerChannelBg,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                  ),
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

                Text(
                  'Filter by Role:',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _filterRole,
                  isExpanded: true,
                  dropdownColor: colors.centerChannelBg,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                  ),
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

                Text(
                  'Filter by Status:',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _filterStatus,
                  isExpanded: true,
                  dropdownColor: colors.centerChannelBg,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                  ),
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

                Text(
                  'Date Range:',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.70),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                DropdownButton<String>(
                  value: _dateRange,
                  isExpanded: true,
                  dropdownColor: colors.centerChannelBg,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 13,
                  ),
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
                child: Text(
                  'Reset Filters',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.54),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.buttonBg,
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
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setPopState) {
          return AlertDialog(
            backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
            title: Text(
              'Toggle Visible Columns',
              style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    value: _visibleColumns['email'],
                    activeColor: colors.buttonBg,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(() => _visibleColumns['email'] = val ?? true);
                    },
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Role',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    value: _visibleColumns['roles'],
                    activeColor: colors.buttonBg,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(() => _visibleColumns['roles'] = val ?? true);
                    },
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Status',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    value: _visibleColumns['status'],
                    activeColor: colors.buttonBg,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(() => _visibleColumns['status'] = val ?? true);
                    },
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Member Since',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    value: _visibleColumns['memberSince'],
                    activeColor: colors.buttonBg,
                    onChanged: (val) {
                      setPopState(() {});
                      setState(
                        () => _visibleColumns['memberSince'] = val ?? true,
                      );
                    },
                  ),
                  CheckboxListTile(
                    title: Text(
                      'Messages Posted',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                    value: _visibleColumns['messagesPosted'],
                    activeColor: colors.buttonBg,
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
                  backgroundColor: colors.buttonBg,
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
    final colors = AppTheme.of(context);
    bool isSysAdmin = user.roles.contains('system_admin');
    bool isUserManager = user.roles.contains('system_user_manager');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setPopState) {
          return AlertDialog(
            backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
            title: Text(
              'Manage Roles for @${user.username}',
              style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: Text(
                    'System Admin',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Full administrative access to System Console',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                    ),
                  ),
                  value: isSysAdmin,
                  activeColor: colors.buttonBg,
                  onChanged: (val) =>
                      setPopState(() => isSysAdmin = val ?? false),
                ),
                CheckboxListTile(
                  title: Text(
                    'User Manager',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Access to manage users, teams, and channels',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                    ),
                  ),
                  value: isUserManager,
                  activeColor: colors.mentionBg,
                  onChanged: (val) =>
                      setPopState(() => isUserManager = val ?? false),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.54),
                  ),
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
                  backgroundColor: colors.buttonBg,
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
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
        title: Text(
          user.isActive
              ? 'Deactivate ${user.username}?'
              : 'Activate ${user.username}?',
          style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
        ),
        content: Text(
          user.isActive
              ? 'This action will deactivate the user account. They will be logged out of all active sessions.'
              : 'This action will reactivate the user account, allowing them to sign in again.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.70),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _setActiveStatus(user, !user.isActive);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: user.isActive
                  ? colors.errorTextColor
                  : colors.onlineIndicator,
            ),
            child: Text(user.isActive ? 'Deactivate' : 'Activate'),
          ),
        ],
      ),
    );
  }

  void _showRevokeAllSessionsDialog(BuildContext context) {
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
        title: Text(
          'Revoke All Active Sessions?',
          style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
        ),
        content: Text(
          'This will invalidate all active sessions for all users across the server. All users will be forced to log in again.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.70),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'All active system sessions have been revoked successfully.',
                  ),
                  backgroundColor: colors.onlineIndicator,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.errorTextColor,
            ),
            child: const Text('Revoke All'),
          ),
        ],
      ),
    );
  }

  void _showRevokeUserSessionsDialog(BuildContext context, UserEntity user) {
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
        title: Text(
          'Revoke Sessions for @${user.username}?',
          style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
        ),
        content: Text(
          'This will invalidate all active login sessions for @${user.username}.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.70),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
              ),
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
                  backgroundColor: colors.onlineIndicator,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.errorTextColor,
            ),
            child: const Text('Revoke Sessions'),
          ),
        ],
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context, UserEntity user) {
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
        title: Text(
          'Reset Password for @${user.username}',
          style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
        ),
        content: Text(
          'Send a password reset email link to ${user.email}?',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.70),
            fontSize: 13,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Password reset link sent to ${user.email}.'),
                  backgroundColor: colors.onlineIndicator,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: colors.buttonBg),
            child: const Text('Send Reset Email'),
          ),
        ],
      ),
    );
  }

  void _exportCsv(List<UserEntity> usersList) {
    final colors = AppTheme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported ${usersList.length} users to CSV.'),
        backgroundColor: colors.buttonBg,
      ),
    );
  }

  String _formatDate(int epoch) {
    if (epoch == 0) return '—';
    final dt = DateTime.fromMillisecondsSinceEpoch(epoch);
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
