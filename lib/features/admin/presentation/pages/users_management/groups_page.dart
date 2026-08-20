import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/entities/group_syncable_entity.dart';
import 'package:flutter_mattermost/features/groups/domain/repositories/groups_repository.dart';

class AdminConsoleGroupsPage extends StatefulWidget {
  const AdminConsoleGroupsPage({super.key});

  @override
  State<AdminConsoleGroupsPage> createState() => _AdminConsoleGroupsPageState();
}

class _AdminConsoleGroupsPageState extends State<AdminConsoleGroupsPage> {
  final GroupsRepository _repository = getIt<GroupsRepository>();

  List<GroupEntity> _groups = [];
  bool _loading = true;
  String? _error;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  String _filterLinkStatus = 'all';
  int _currentPage = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({String? query}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final groups = await _repository.getGroups(
        q: query,
        perPage: 200,
        includeMemberCount: true,
      );
      if (!mounted) return;
      setState(() => _groups = groups);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _load(query: query.trim().isEmpty ? null : query.trim());
    });
  }

  Future<void> _linkGroup(GroupEntity group) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.linkGroupSyncable(group.id, 'team', '');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group "${group.displayName}" linked successfully.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to link group: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _unlinkGroup(GroupEntity group) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.unlinkGroupSyncable(group.id, 'team', '');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group "${group.displayName}" unlinked.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to unlink group: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  void _navigateToGroupDetail(GroupEntity group) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _GroupDetailPage(repository: _repository, group: group),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    final filteredGroups = _groups.where((g) {
      if (_filterLinkStatus == 'linked') return g.hasSyncables;
      if (_filterLinkStatus == 'not_linked') return !g.hasSyncables;
      return true;
    }).toList();

    final totalPages = (filteredGroups.length / _pageSize).ceil();
    final startIdx = _currentPage * _pageSize;
    final endIdx = (startIdx + _pageSize < filteredGroups.length)
        ? startIdx + _pageSize
        : filteredGroups.length;
    final pageGroups = (startIdx < filteredGroups.length)
        ? filteredGroups.sublist(startIdx, endIdx)
        : <GroupEntity>[];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Groups',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: colors.buttonBg))
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: colors.errorTextColor,
                    size: 48,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Could not load groups: $_error',
                    style: TextStyle(
                      color: colors.errorTextColor,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _load,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.buttonBg,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                _buildFiltersBar(),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildTable(
                    pageGroups,
                    filteredGroups.length,
                    totalPages,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFiltersBar() {
    final colors = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.centerChannelBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.centerChannelColor.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: TextStyle(
                  color: colors.centerChannelColor,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: 'Search groups by name...',
                  hintStyle: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.38),
                    fontSize: 13,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colors.centerChannelColor.withValues(alpha: 0.38),
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
                  filled: true,
                  fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
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
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: _filterLinkStatus,
              dropdownColor: colors.centerChannelBg.withValues(alpha: 0.60),
              underline: const SizedBox(),
              style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Groups')),
                DropdownMenuItem(value: 'linked', child: Text('Linked Only')),
                DropdownMenuItem(
                  value: 'not_linked',
                  child: Text('Not Linked'),
                ),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _filterLinkStatus = val;
                    _currentPage = 0;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(
    List<GroupEntity> pageGroups,
    int totalFiltered,
    int totalPages,
  ) {
    final colors = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: colors.centerChannelBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colors.centerChannelColor.withValues(alpha: 0.10),
          ),
        ),
        child: Column(
          children: [
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
                    flex: 3,
                    child: Text(
                      'GROUP NAME',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'SOURCE',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'MEMBERS',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'LINKING',
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
                    width: 120,
                    child: Text(
                      'ACTIONS',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (pageGroups.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'No groups found.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pageGroups.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: colors.centerChannelColor.withValues(alpha: 0.10),
                ),
                itemBuilder: (context, index) {
                  final colors = AppTheme.of(context);
                  final group = pageGroups[index];
                  final displayName = group.displayName.isNotEmpty
                      ? group.displayName
                      : (group.name.isNotEmpty ? group.name : '—');
                  final isLinked = group.hasSyncables;

                  return InkWell(
                    onTap: () => _navigateToGroupDetail(group),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 15,
                                  backgroundColor: isLinked
                                      ? colors.onlineIndicator.withValues(
                                          alpha: 0.2,
                                        )
                                      : colors.centerChannelColor.withValues(
                                          alpha: 0.10,
                                        ),
                                  child: Icon(
                                    Icons.group_outlined,
                                    color: isLinked
                                        ? colors.onlineIndicator
                                        : colors.centerChannelColor.withValues(
                                            alpha: 0.38,
                                          ),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        displayName,
                                        style: TextStyle(
                                          color: colors.centerChannelColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '@${group.name}',
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
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: group.source == 'ldap'
                                    ? colors.mentionBg.withValues(alpha: 0.15)
                                    : colors.awayIndicator.withValues(
                                        alpha: 0.15,
                                      ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                group.source.toUpperCase(),
                                style: TextStyle(
                                  color: group.source == 'ldap'
                                      ? colors.mentionBg
                                      : colors.awayIndicator,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${group.memberCount} members',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.70,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: isLinked
                                    ? colors.onlineIndicator.withValues(
                                        alpha: 0.15,
                                      )
                                    : colors.centerChannelColor.withValues(
                                        alpha: 0.10,
                                      ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isLinked ? 'Linked' : 'Not Linked',
                                style: TextStyle(
                                  color: isLinked
                                      ? colors.onlineIndicator
                                      : colors.centerChannelColor.withValues(
                                          alpha: 0.54,
                                        ),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 120,
                            child: Row(
                              children: [
                                IconButton(
                                  tooltip: isLinked ? 'Unlink' : 'Link',
                                  onPressed: () => isLinked
                                      ? _unlinkGroup(group)
                                      : _linkGroup(group),
                                  icon: Icon(
                                    isLinked ? Icons.link_off : Icons.link,
                                    color: isLinked
                                        ? colors.errorTextColor
                                        : colors.onlineIndicator,
                                    size: 18,
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'View Details',
                                  onPressed: () =>
                                      _navigateToGroupDetail(group),
                                  icon: Icon(
                                    Icons.chevron_right_rounded,
                                    color: colors.centerChannelColor.withValues(
                                      alpha: 0.38,
                                    ),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            if (totalFiltered > _pageSize)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
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
                      'Showing ${startIdx + 1} - $endIdx of $totalFiltered groups',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.54,
                        ),
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
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
                          '${_currentPage + 1} / $totalPages',
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
                          onPressed: _currentPage < totalPages - 1
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
    );
  }

  int get startIdx => _currentPage * _pageSize;
  int get endIdx {
    final e = startIdx + _pageSize;
    return e < _groups.length ? e : _groups.length;
  }
}

class _GroupDetailPage extends StatefulWidget {
  final GroupsRepository repository;
  final GroupEntity group;

  const _GroupDetailPage({required this.repository, required this.group});

  @override
  State<_GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<_GroupDetailPage> {
  late GroupEntity _group;
  bool _loading = true;
  String? _error;
  bool isSaving = false;

  List<GroupSyncableEntity> _linkedTeams = [];
  List<GroupSyncableEntity> _linkedChannels = [];
  List<UserEntity> _members = [];
  int _memberPage = 0;
  int _memberTotalCount = 0;
  bool _loadingMembers = false;

  bool _allowReference = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _group = widget.group;
    _allowReference = _group.allowReference;
    _loadGroupDetail();
  }

  Future<void> _loadGroupDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        widget.repository.getGroup(_group.id),
        widget.repository.getGroupSyncables(_group.id, 'team'),
        widget.repository.getGroupSyncables(_group.id, 'channel'),
        widget.repository.getGroupStats(_group.id),
      ]);

      if (!mounted) return;
      final updatedGroup = results[0] as GroupEntity;
      _linkedTeams = results[1] as List<GroupSyncableEntity>;
      _linkedChannels = results[2] as List<GroupSyncableEntity>;
      final stats = results[3] as Map<String, dynamic>;

      setState(() {
        _group = updatedGroup;
        _memberTotalCount = (stats['total_member_count'] as int?) ?? 0;
        _allowReference = updatedGroup.allowReference;
      });

      _loadMembers();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMembers() async {
    final colors = AppTheme.of(context);
    setState(() => _loadingMembers = true);
    try {
      final result = await widget.repository.getGroupUsers(
        groupId: _group.id,
        page: _memberPage,
        perPage: 20,
      );
      if (!mounted) return;
      setState(() {
        _members = result.members;
        _memberTotalCount = result.totalMemberCount;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load members: $e'),
            backgroundColor: colors.errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  Future<void> _saveGroupSettings() async {
    final colors = AppTheme.of(context);
    try {
      await widget.repository.patchGroup(
        _group.id,
        name: _group.name,
        displayName: _group.displayName,
        description: _group.description,
      );
      if (!mounted) return;
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Group settings saved.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _unlinkTeam(GroupSyncableEntity syncable) async {
    final colors = AppTheme.of(context);
    try {
      await widget.repository.unlinkGroupSyncable(
        _group.id,
        'team',
        syncable.teamId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Team unlinked from group.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadGroupDetail();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _unlinkChannel(GroupSyncableEntity syncable) async {
    final colors = AppTheme.of(context);
    try {
      await widget.repository.unlinkGroupSyncable(
        _group.id,
        'channel',
        syncable.channelId,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Channel unlinked from group.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadGroupDetail();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _toggleSyncable(
    GroupSyncableEntity syncable,
    String type,
  ) async {
    final colors = AppTheme.of(context);
    try {
      await widget.repository.patchGroupSyncable(
        _group.id,
        type,
        syncable.syncableId,
        autoAdd: !syncable.autoAdd,
      );
      if (!mounted) return;
      _loadGroupDetail();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: colors.centerChannelBg,
      body: _loading
          ? Center(child: CircularProgressIndicator(color: colors.buttonBg))
          : _error != null
          ? Center(
              child: Text(
                'Error: $_error',
                style: TextStyle(color: colors.errorTextColor),
              ),
            )
          : Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBreadcrumb(),
                      const SizedBox(height: 16),
                      _buildProfileSection(),
                      const SizedBox(height: 20),
                      _buildMentionSettings(),
                      const SizedBox(height: 20),
                      _buildTeamsSection(),
                      const SizedBox(height: 20),
                      _buildChannelsSection(),
                      const SizedBox(height: 20),
                      _buildMembersSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                if (_hasChanges)
                  SaveChangesPanel(
                    isSaving: _hasChanges,
                    onCancel: () {
                      setState(() {
                        _allowReference = _group.allowReference;
                        _hasChanges = false;
                      });
                    },
                    onSave: _saveGroupSettings,
                  ),
              ],
            ),
    );
  }

  Widget _buildBreadcrumb() {
    final colors = AppTheme.of(context);
    return Row(
      children: [
        Icon(Icons.groups_outlined, color: colors.buttonBg, size: 20),
        const SizedBox(width: 8),
        Text(
          _group.displayName.isNotEmpty ? _group.displayName : _group.name,
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Group Profile',
      subtitle: 'Basic information about this group',
      children: [
        AdminSettingField(
          label: 'Display Name',
          child: Text(
            _group.displayName.isNotEmpty ? _group.displayName : _group.name,
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          ),
        ),
        AdminSettingField(
          label: 'Group Name',
          child: Text(
            '@${_group.name}',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.70),
              fontSize: 13,
            ),
          ),
        ),
        if (_group.description.isNotEmpty)
          AdminSettingField(
            label: 'Description',
            child: Text(
              _group.description,
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.70),
                fontSize: 13,
              ),
            ),
          ),
        AdminSettingField(
          label: 'Source',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _group.source == 'ldap'
                  ? colors.mentionBg.withValues(alpha: 0.15)
                  : colors.awayIndicator.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _group.source.toUpperCase(),
              style: TextStyle(
                color: _group.source == 'ldap'
                    ? colors.mentionBg
                    : colors.awayIndicator,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        AdminSettingField(
          label: 'Members',
          child: Text(
            '$_memberTotalCount total members',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.70),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMentionSettings() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Group Mention Settings',
      subtitle: 'Configure how this group can be mentioned in channels',
      children: [
        SwitchListTile(
          title: Text(
            'Allow Reference',
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          ),
          subtitle: Text(
            'When enabled, this group can be mentioned using @group-name in channels.',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
              fontSize: 11,
            ),
          ),
          value: _allowReference,
          activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
          onChanged: (val) {
            setState(() {
              _allowReference = val;
              _hasChanges = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTeamsSection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Team Memberships',
      subtitle: 'Teams linked to this group',
      children: [
        if (_linkedTeams.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No teams linked to this group.',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.38),
                fontSize: 13,
              ),
            ),
          )
        else
          ..._linkedTeams
              .where((s) => s.teamId.isNotEmpty)
              .map(
                (syncable) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.mentionHighlightBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.group_outlined,
                        color: colors.buttonBg,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Team ID: ${syncable.teamId}',
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${syncable.userCount} synced members',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.54,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: syncable.autoAdd,
                        activeTrackColor: colors.buttonBg.withValues(
                          alpha: 0.5,
                        ),
                        onChanged: (_) => _toggleSyncable(syncable, 'team'),
                      ),
                      IconButton(
                        tooltip: 'Unlink Team',
                        onPressed: () => _unlinkTeam(syncable),
                        icon: Icon(
                          Icons.link_off,
                          color: colors.errorTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add, size: 16, color: colors.buttonBg),
          label: Text(
            'Add Team',
            style: TextStyle(color: colors.buttonBg, fontSize: 12),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colors.buttonBg),
          ),
        ),
      ],
    );
  }

  Widget _buildChannelsSection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Channel Memberships',
      subtitle: 'Channels linked to this group',
      children: [
        if (_linkedChannels.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No channels linked to this group.',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.38),
                fontSize: 13,
              ),
            ),
          )
        else
          ..._linkedChannels
              .where((s) => s.channelId.isNotEmpty)
              .map(
                (syncable) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colors.mentionHighlightBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.tag_rounded,
                        color: colors.awayIndicator,
                        size: 18,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Channel ID: ${syncable.channelId}',
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '${syncable.userCount} synced members',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.54,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: syncable.autoAdd,
                        activeTrackColor: colors.buttonBg.withValues(
                          alpha: 0.5,
                        ),
                        onChanged: (_) => _toggleSyncable(syncable, 'channel'),
                      ),
                      IconButton(
                        tooltip: 'Unlink Channel',
                        onPressed: () => _unlinkChannel(syncable),
                        icon: Icon(
                          Icons.link_off,
                          color: colors.errorTextColor,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.add, size: 16, color: colors.buttonBg),
          label: Text(
            'Add Channel',
            style: TextStyle(color: colors.buttonBg, fontSize: 12),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: colors.buttonBg),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Group Members',
      subtitle: '$_memberTotalCount total members',
      children: [
        if (_loadingMembers)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                color: colors.buttonBg,
                strokeWidth: 2,
              ),
            ),
          )
        else if (_members.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No members found.',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.38),
                fontSize: 13,
              ),
            ),
          )
        else
          Column(
            children: [
              ..._members.map((member) {
                final name = [
                  member.firstName,
                  member.lastName,
                ].where((p) => p.isNotEmpty).join(' ');
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.mentionHighlightBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colors.mentionBg.withValues(
                          alpha: 0.2,
                        ),
                        child: Text(
                          member.username.isNotEmpty
                              ? member.username[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: colors.mentionBg,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isNotEmpty ? name : member.username,
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '@${member.username}',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.54,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (_memberTotalCount > 20)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.chevron_left_rounded,
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.70,
                        ),
                        size: 20,
                      ),
                      onPressed: _memberPage > 0
                          ? () {
                              setState(() => _memberPage--);
                              _loadMembers();
                            }
                          : null,
                    ),
                    Text(
                      'Page ${_memberPage + 1}',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 12,
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
                      onPressed: (_memberPage + 1) * 20 < _memberTotalCount
                          ? () {
                              setState(() => _memberPage++);
                              _loadMembers();
                            }
                          : null,
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
