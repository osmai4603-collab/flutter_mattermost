import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/team_type.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_member_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_stats_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final TeamRepository _repository = getIt<TeamRepository>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  String _searchQuery = '';
  String _filterType = 'all';
  bool _isLoading = true;
  List<TeamEntity> _teams = [];
  final Map<String, TeamStatsEntity> _teamStats = {};

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTeams() async {
    setState(() => _isLoading = true);
    try {
      final repoTeams = await _repository.getMyTeams(perPage: 200);
      if (mounted) setState(() => _teams = repoTeams);
      for (final team in repoTeams) {
        try {
          final stats = await _repository.getTeamStats(team.id);
          if (mounted) setState(() => _teamStats[team.id] = stats);
        } catch (_) {}
      }
    } catch (_) {
      if (mounted) setState(() => _teams = []);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _searchQuery = query.trim().toLowerCase());
    });
  }

  Future<void> _createTeam(
    String name,
    String displayName,
    String description,
    bool allowOpenInvite,
  ) async {
    try {
      await _repository.createTeam({
        'name': name,
        'display_name': displayName,
        'description': description,
        'allow_open_invite': allowOpenInvite,
      });
      if (!mounted) return;
      final colors = AppTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Team created successfully.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadTeams();
    } catch (e) {
      if (!mounted) return;
      final colors = AppTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create team: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _archiveTeam(TeamEntity team) async {
    try {
      await _repository.deleteTeam(team.id);
      if (!mounted) return;
      final colors = AppTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Team "${team.displayName}" archived.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadTeams();
    } catch (e) {
      if (!mounted) return;
      final colors = AppTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to archive: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _restoreTeam(TeamEntity team) async {
    try {
      await _repository.unarchiveTeam(team.id);
      if (!mounted) return;
      final colors = AppTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Team "${team.displayName}" restored.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadTeams();
    } catch (e) {
      if (!mounted) return;
      final colors = AppTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to restore: $e'),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  void _navigateToTeamDetail(TeamEntity team) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _TeamDetailPage(repository: _repository, team: team),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    final filteredTeams = _teams.where((team) {
      final matchesSearch =
          team.displayName.toLowerCase().contains(_searchQuery) ||
          team.name.toLowerCase().contains(_searchQuery);
      final isPublic = team.type == TeamType.open || team.allowOpenInvite;
      final isArchived = team.deleteAt > 0;
      if (_filterType == 'public') return matchesSearch && isPublic;
      if (_filterType == 'private') return matchesSearch && !isPublic;
      if (_filterType == 'archived') return matchesSearch && isArchived;
      return matchesSearch;
    }).toList();

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
              'Teams',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colors.buttonBg))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                _buildFiltersBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTable(filteredTeams)),
              ],
            ),
    );
  }

  Widget _buildHeader() {
    final colors = AppTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Teams',
                    style: TextStyle(
                      color: colors.centerChannelColor,
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
                      color: colors.buttonBg.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_teams.length} Total',
                      style: TextStyle(
                        color: colors.buttonBg,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'View, configure, and manage all teams across your workspace.',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.refresh_rounded,
                  color: colors.centerChannelColor.withValues(alpha: 0.70),
                ),
                onPressed: _loadTeams,
                tooltip: 'Refresh',
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showCreateTeamDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Team'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.buttonBg,
                  foregroundColor: colors.buttonColor,
                ),
              ),
            ],
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
                  hintText: 'Search teams by name or handle...',
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
              value: _filterType,
              dropdownColor: colors.centerChannelBg.withValues(alpha: 0.60),
              underline: const SizedBox(),
              style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Teams')),
                DropdownMenuItem(value: 'public', child: Text('Public Teams')),
                DropdownMenuItem(
                  value: 'private',
                  child: Text('Private Teams'),
                ),
                DropdownMenuItem(value: 'archived', child: Text('Archived')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _filterType = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<TeamEntity> filteredTeams) {
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
                      'TEAM NAME',
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
                      'HANDLE',
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
                      'TYPE',
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
                  SizedBox(
                    width: 140,
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
            if (filteredTeams.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'No matching teams found.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: filteredTeams.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: colors.centerChannelColor.withValues(alpha: 0.10),
                  ),
                  itemBuilder: (context, index) {
                    final team = filteredTeams[index];
                    final isPublic =
                        team.type == TeamType.open || team.allowOpenInvite;
                    final isArchived = team.deleteAt > 0;
                    final displayName = team.displayName.isNotEmpty
                        ? team.displayName
                        : team.name;
                    final memberCount =
                        _teamStats[team.id]?.total_member_count ?? 0;

                    return InkWell(
                      onTap: () => _navigateToTeamDetail(team),
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
                                    backgroundColor: isArchived
                                        ? colors.centerChannelColor.withValues(
                                            alpha: 0.10,
                                          )
                                        : isPublic
                                        ? colors.buttonBg.withValues(alpha: 0.2)
                                        : colors.mentionBg.withValues(
                                            alpha: 0.2,
                                          ),
                                    child: Text(
                                      displayName.isNotEmpty
                                          ? displayName[0].toUpperCase()
                                          : 'T',
                                      style: TextStyle(
                                        color: isArchived
                                            ? colors.centerChannelColor
                                                  .withValues(alpha: 0.38)
                                            : isPublic
                                            ? colors.buttonBg
                                            : colors.mentionBg,
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
                                          displayName,
                                          style: TextStyle(
                                            color: isArchived
                                                ? colors.centerChannelColor
                                                      .withValues(alpha: 0.54)
                                                : colors.centerChannelColor,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        if (team.description.isNotEmpty)
                                          Text(
                                            team.description,
                                            style: TextStyle(
                                              color: colors.centerChannelColor
                                                  .withValues(alpha: 0.54),
                                              fontSize: 11,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '@${team.name}',
                                style: TextStyle(
                                  color: isArchived
                                      ? colors.centerChannelColor.withValues(
                                          alpha: 0.38,
                                        )
                                      : colors.centerChannelColor.withValues(
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
                                  color: isArchived
                                      ? colors.errorTextColor.withValues(
                                          alpha: 0.15,
                                        )
                                      : isPublic
                                      ? colors.buttonBg.withValues(alpha: 0.15)
                                      : colors.mentionBg.withValues(
                                          alpha: 0.15,
                                        ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isArchived
                                      ? 'Archived'
                                      : (isPublic ? 'Public' : 'Private'),
                                  style: TextStyle(
                                    color: isArchived
                                        ? colors.errorTextColor
                                        : isPublic
                                        ? colors.buttonBg
                                        : colors.mentionBg,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '$memberCount members',
                                style: TextStyle(
                                  color: isArchived
                                      ? colors.centerChannelColor.withValues(
                                          alpha: 0.38,
                                        )
                                      : colors.centerChannelColor.withValues(
                                          alpha: 0.70,
                                        ),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    onPressed: () =>
                                        _navigateToTeamDetail(team),
                                    icon: Icon(
                                      Icons.edit_outlined,
                                      color: colors.buttonBg,
                                      size: 18,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: isArchived ? 'Restore' : 'Archive',
                                    onPressed: () => isArchived
                                        ? _restoreTeam(team)
                                        : _showArchiveConfirm(team),
                                    icon: Icon(
                                      isArchived
                                          ? Icons.unarchive_outlined
                                          : Icons.archive_outlined,
                                      color: isArchived
                                          ? colors.onlineIndicator
                                          : colors.errorTextColor,
                                      size: 18,
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
              ),
          ],
        ),
      ),
    );
  }

  void _showCreateTeamDialog(BuildContext context) {
    final colors = AppTheme.of(context);
    final nameCtrl = TextEditingController();
    final displayNameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool allowOpen = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
          title: Text(
            'Create New Team',
            style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: displayNameCtrl,
                  style: TextStyle(color: colors.centerChannelColor),
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    labelStyle: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: TextStyle(color: colors.centerChannelColor),
                  decoration: InputDecoration(
                    labelText: 'Team Handle (URL)',
                    labelStyle: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  style: TextStyle(color: colors.centerChannelColor),
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(
                    'Allow anyone to join',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                    ),
                  ),
                  value: allowOpen,
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                  onChanged: (v) => setDialogState(() => allowOpen = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
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
                final name = nameCtrl.text.trim();
                final displayName = displayNameCtrl.text.trim();
                if (name.isEmpty || displayName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Name and Display Name are required.',
                      ),
                      backgroundColor: colors.errorTextColor,
                    ),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                _createTeam(name, displayName, descCtrl.text.trim(), allowOpen);
              },
              style: ElevatedButton.styleFrom(backgroundColor: colors.buttonBg),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showArchiveConfirm(TeamEntity team) {
    final colors = AppTheme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.centerChannelBg.withValues(alpha: 0.60),
        title: Text(
          'Archive "${team.displayName}"?',
          style: TextStyle(color: colors.centerChannelColor, fontSize: 16),
        ),
        content: Text(
          'This will archive the team. Team members will lose access. You can restore it later.',
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
              _archiveTeam(team);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.errorTextColor,
            ),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
  }
}

class _TeamDetailPage extends StatefulWidget {
  final TeamRepository repository;
  final TeamEntity team;

  const _TeamDetailPage({required this.repository, required this.team});

  @override
  State<_TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<_TeamDetailPage> {
  late TeamEntity _team;
  bool _loading = true;
  String? _error;

  late TextEditingController _displayNameCtrl;
  late TextEditingController _descriptionCtrl;
  late TextEditingController _allowedDomainsCtrl;
  late bool _allowOpenInvite;
  bool _hasChanges = false;

  List<TeamMemberEntity> _members = [];
  bool _loadingMembers = false;
  int _memberPage = 0;
  int _memberTotalCount = 0;
  final Map<String, TeamStatsEntity> _stats = {};

  @override
  void initState() {
    super.initState();
    _team = widget.team;
    _displayNameCtrl = TextEditingController(text: _team.displayName);
    _descriptionCtrl = TextEditingController(text: _team.description);
    _allowedDomainsCtrl = TextEditingController(text: _team.allowedDomains);
    _allowOpenInvite = _team.allowOpenInvite;
    _loadDetail();
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _descriptionCtrl.dispose();
    _allowedDomainsCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        widget.repository.getTeamById(_team.id),
        widget.repository.getTeamStats(_team.id),
      ]);
      if (!mounted) return;
      _team = results[0] as TeamEntity;
      final stats = results[1] as TeamStatsEntity;
      _stats[_team.id] = stats;
      _displayNameCtrl.text = _team.displayName;
      _descriptionCtrl.text = _team.description;
      _allowedDomainsCtrl.text = _team.allowedDomains;
      _allowOpenInvite = _team.allowOpenInvite;
      _memberTotalCount = stats.total_member_count ?? 0;
      _loadMembers();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMembers() async {
    setState(() => _loadingMembers = true);
    try {
      final members = await widget.repository.getTeamMembers(
        _team.id,
        page: _memberPage,
        perPage: 20,
      );
      if (!mounted) return;
      setState(() => _members = members);
    } catch (e) {
      if (mounted) {
        final colors = AppTheme.of(context);
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

  Future<void> _saveSettings() async {
    try {
      await widget.repository.updateTeam(
        _team.copyWith(
          displayName: _displayNameCtrl.text.trim(),
          description: _descriptionCtrl.text.trim(),
          allowOpenInvite: _allowOpenInvite,
          allowedDomains: _allowedDomainsCtrl.text.trim(),
        ),
      );
      if (!mounted) return;
      final colors = AppTheme.of(context);
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Team settings saved.'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
      _loadDetail();
    } catch (e) {
      if (!mounted) return;
      final colors = AppTheme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
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
                      Row(
                        children: [
                          Icon(
                            Icons.group_outlined,
                            color: colors.buttonBg,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _team.displayName,
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildProfileSection(),
                      const SizedBox(height: 20),
                      _buildPrivacySection(),
                      const SizedBox(height: 20),
                      _buildAllowedDomainsSection(),
                      const SizedBox(height: 20),
                      _buildMembersSection(),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                if (_hasChanges)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colors.centerChannelBg,
                        border: Border(
                          top: BorderSide(
                            color: colors.centerChannelColor.withValues(
                              alpha: 0.10,
                            ),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _displayNameCtrl.text = _team.displayName;
                                _descriptionCtrl.text = _team.description;
                                _allowedDomainsCtrl.text = _team.allowedDomains;
                                _allowOpenInvite = _team.allowOpenInvite;
                                _hasChanges = false;
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.54,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: _saveSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.buttonBg,
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

  Widget _buildProfileSection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Team Profile',
      subtitle: 'Basic information about this team',
      children: [
        AdminSettingField(
          label: 'Display Name',
          child: TextField(
            controller: _displayNameCtrl,
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
            onChanged: (_) => setState(() => _hasChanges = true),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
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
            controller: _descriptionCtrl,
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
            maxLines: 2,
            onChanged: (_) => setState(() => _hasChanges = true),
            decoration: InputDecoration(
              filled: true,
              fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
        AdminSettingField(
          label: 'Team Handle',
          child: Text(
            '@${_team.name}',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.70),
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Team Privacy',
      subtitle: 'Control who can join this team',
      children: [
        SwitchListTile(
          title: Text(
            'Allow anyone to join this team',
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          ),
          subtitle: Text(
            _allowOpenInvite
                ? 'Anyone with a registered account can join this team.'
                : 'Only users with an invite can join this team.',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
              fontSize: 11,
            ),
          ),
          value: _allowOpenInvite,
          activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
          onChanged: (v) => setState(() {
            _allowOpenInvite = v;
            _hasChanges = true;
          }),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildAllowedDomainsSection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Allowed Domains',
      subtitle: 'Restrict team membership to specific email domains',
      children: [
        AdminSettingField(
          label: 'Allowed Email Domains',
          description:
              'Comma-separated list of allowed email domains. Leave empty to allow all.',
          child: TextField(
            controller: _allowedDomainsCtrl,
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
            onChanged: (_) => setState(() => _hasChanges = true),
            decoration: InputDecoration(
              hintText: 'e.g. mattermost.com, example.org',
              hintStyle: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.38),
                fontSize: 12,
              ),
              filled: true,
              fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    final colors = AppTheme.of(context);
    return AdminSettingSection(
      title: 'Team Members',
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
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: colors.centerChannelBg.withValues(alpha: 0.60),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: colors.buttonBg.withValues(alpha: 0.2),
                        child: Text(
                          member.userId.isNotEmpty
                              ? member.userId[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            color: colors.buttonBg,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          member.userId,
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: member.schemeAdmin == true
                              ? colors.buttonBg.withValues(alpha: 0.15)
                              : colors.centerChannelColor.withValues(
                                  alpha: 0.10,
                                ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          member.schemeAdmin == true ? 'Team Admin' : 'Member',
                          style: TextStyle(
                            color: member.schemeAdmin == true
                                ? colors.buttonBg
                                : colors.centerChannelColor.withValues(
                                    alpha: 0.54,
                                  ),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
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
