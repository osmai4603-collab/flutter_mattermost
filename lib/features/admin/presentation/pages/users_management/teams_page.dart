import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/team_type.dart';
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

  Future<void> _createTeam(String name, String displayName, String description, bool allowOpenInvite) async {
    try {
      await _repository.createTeam({
        'name': name,
        'display_name': displayName,
        'description': description,
        'allow_open_invite': allowOpenInvite,
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team created successfully.'), backgroundColor: Colors.green),
      );
      _loadTeams();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create team: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _archiveTeam(TeamEntity team) async {
    try {
      await _repository.deleteTeam(team.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team "${team.displayName}" archived.'), backgroundColor: Colors.green.shade700),
      );
      _loadTeams();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to archive: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  Future<void> _restoreTeam(TeamEntity team) async {
    try {
      await _repository.unarchiveTeam(team.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team "${team.displayName}" restored.'), backgroundColor: Colors.green.shade700),
      );
      _loadTeams();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to restore: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  void _navigateToTeamDetail(TeamEntity team) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => _TeamDetailPage(repository: _repository, team: team)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredTeams = _teams.where((team) {
      final matchesSearch = team.displayName.toLowerCase().contains(_searchQuery) || team.name.toLowerCase().contains(_searchQuery);
      final isPublic = team.type == TeamType.open || team.allowOpenInvite;
      final isArchived = team.deleteAt > 0;
      if (_filterType == 'public') return matchesSearch && isPublic;
      if (_filterType == 'private') return matchesSearch && !isPublic;
      if (_filterType == 'archived') return matchesSearch && isArchived;
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildFiltersBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTable(filteredTeams)),
              ],
            ),
    );
  }

  Widget _buildHeader() {
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
                  const Text('Teams', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.blueAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                    child: Text('${_teams.length} Total', style: const TextStyle(color: Colors.blueAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text('View, configure, and manage all teams across your workspace.', style: TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.refresh_rounded, color: Colors.white70), onPressed: _loadTeams, tooltip: 'Refresh'),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showCreateTeamDialog(context),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Create Team'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: const Color(0xFF161922), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search teams by name or handle...',
                  hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 18),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(icon: const Icon(Icons.clear, color: Colors.white38, size: 16), onPressed: () { _searchController.clear(); _onSearchChanged(''); })
                      : null,
                  filled: true, fillColor: const Color(0xFF212433), isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 16),
            DropdownButton<String>(
              value: _filterType,
              dropdownColor: const Color(0xFF212433),
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Teams')),
                DropdownMenuItem(value: 'public', child: Text('Public Teams')),
                DropdownMenuItem(value: 'private', child: Text('Private Teams')),
                DropdownMenuItem(value: 'archived', child: Text('Archived')),
              ],
              onChanged: (val) { if (val != null) setState(() => _filterType = val); },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<TeamEntity> filteredTeams) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFF161922), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
              child: const Row(
                children: [
                  Expanded(flex: 3, child: Text('TEAM NAME', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('HANDLE', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('TYPE', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                  Expanded(flex: 2, child: Text('MEMBERS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                  SizedBox(width: 140, child: Text('ACTIONS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            if (filteredTeams.isEmpty)
              const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('No matching teams found.', style: TextStyle(color: Colors.white38, fontSize: 14))))
            else
              Expanded(
                child: ListView.separated(
                  itemCount: filteredTeams.length,
                  separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (context, index) {
                    final team = filteredTeams[index];
                    final isPublic = team.type == TeamType.open || team.allowOpenInvite;
                    final isArchived = team.deleteAt > 0;
                    final displayName = team.displayName.isNotEmpty ? team.displayName : team.name;
                    final memberCount = _teamStats[team.id]?.total_member_count ?? 0;

                    return InkWell(
                      onTap: () => _navigateToTeamDetail(team),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    backgroundColor: isArchived
                                        ? Colors.white10
                                        : isPublic ? Colors.blueAccent.withValues(alpha: 0.2) : Colors.purpleAccent.withValues(alpha: 0.2),
                                    child: Text(
                                      displayName.isNotEmpty ? displayName[0].toUpperCase() : 'T',
                                      style: TextStyle(color: isArchived ? Colors.white38 : isPublic ? Colors.blueAccent : Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(displayName, style: TextStyle(color: isArchived ? Colors.white54 : Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                        if (team.description.isNotEmpty)
                                          Text(team.description, style: const TextStyle(color: Colors.white54, fontSize: 11), overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(flex: 2, child: Text('@${team.name}', style: TextStyle(color: isArchived ? Colors.white38 : Colors.white70, fontSize: 12))),
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isArchived
                                      ? Colors.redAccent.withValues(alpha: 0.15)
                                      : isPublic ? Colors.blueAccent.withValues(alpha: 0.15) : Colors.purpleAccent.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isArchived ? 'Archived' : (isPublic ? 'Public' : 'Private'),
                                  style: TextStyle(
                                    color: isArchived ? Colors.redAccent : isPublic ? Colors.blueAccent : Colors.purpleAccent,
                                    fontSize: 11, fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(flex: 2, child: Text('$memberCount members', style: TextStyle(color: isArchived ? Colors.white38 : Colors.white70, fontSize: 12))),
                            SizedBox(
                              width: 140,
                              child: Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    onPressed: () => _navigateToTeamDetail(team),
                                    icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent, size: 18),
                                  ),
                                  IconButton(
                                    tooltip: isArchived ? 'Restore' : 'Archive',
                                    onPressed: () => isArchived ? _restoreTeam(team) : _showArchiveConfirm(team),
                                    icon: Icon(
                                      isArchived ? Icons.unarchive_outlined : Icons.archive_outlined,
                                      color: isArchived ? Colors.greenAccent : Colors.redAccent,
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
    final nameCtrl = TextEditingController();
    final displayNameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    bool allowOpen = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF212433),
          title: const Text('Create New Team', style: TextStyle(color: Colors.white, fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: displayNameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Display Name', labelStyle: TextStyle(color: Colors.white70), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38))),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Team Handle (URL)', labelStyle: TextStyle(color: Colors.white70), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38))),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(labelText: 'Description', labelStyle: TextStyle(color: Colors.white70), enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38))),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: const Text('Allow anyone to join', style: TextStyle(color: Colors.white, fontSize: 13)),
                  value: allowOpen,
                  activeTrackColor: Colors.blueAccent.withValues(alpha: 0.5),
                  onChanged: (v) => setDialogState(() => allowOpen = v),
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
            ElevatedButton(
              onPressed: () {
                final name = nameCtrl.text.trim();
                final displayName = displayNameCtrl.text.trim();
                if (name.isEmpty || displayName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Name and Display Name are required.'), backgroundColor: Colors.redAccent),
                  );
                  return;
                }
                Navigator.of(ctx).pop();
                _createTeam(name, displayName, descCtrl.text.trim(), allowOpen);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showArchiveConfirm(TeamEntity team) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF212433),
        title: Text('Archive "${team.displayName}"?', style: const TextStyle(color: Colors.white, fontSize: 16)),
        content: const Text('This will archive the team. Team members will lose access. You can restore it later.', style: TextStyle(color: Colors.white70, fontSize: 13)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () { Navigator.of(ctx).pop(); _archiveTeam(team); },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
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
    setState(() { _loading = true; _error = null; });
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
      final members = await widget.repository.getTeamMembers(_team.id, page: _memberPage, perPage: 20);
      if (!mounted) return;
      setState(() => _members = members);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load members: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  Future<void> _saveSettings() async {
    try {
      await widget.repository.updateTeam(_team.copyWith(
        displayName: _displayNameCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        allowOpenInvite: _allowOpenInvite,
        allowedDomains: _allowedDomainsCtrl.text.trim(),
      ));
      if (!mounted) return;
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Team settings saved.'), backgroundColor: Colors.green),
      );
      _loadDetail();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
          : _error != null
              ? Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.redAccent)))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.group_outlined, color: Colors.blueAccent, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(_team.displayName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
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
                          decoration: const BoxDecoration(color: Color(0xFF161922), border: Border(top: BorderSide(color: Colors.white10))),
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
                                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: _saveSettings,
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
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
    return AdminSettingSection(
      title: 'Team Profile',
      subtitle: 'Basic information about this team',
      children: [
        AdminSettingField(
          label: 'Display Name',
          child: TextField(
            controller: _displayNameCtrl,
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
            controller: _descriptionCtrl,
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
        AdminSettingField(
          label: 'Team Handle',
          child: Text('@${_team.name}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return AdminSettingSection(
      title: 'Team Privacy',
      subtitle: 'Control who can join this team',
      children: [
        SwitchListTile(
          title: const Text('Allow anyone to join this team', style: TextStyle(color: Colors.white, fontSize: 13)),
          subtitle: Text(
            _allowOpenInvite ? 'Anyone with a registered account can join this team.' : 'Only users with an invite can join this team.',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          value: _allowOpenInvite,
          activeTrackColor: Colors.blueAccent.withValues(alpha: 0.5),
          onChanged: (v) => setState(() { _allowOpenInvite = v; _hasChanges = true; }),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildAllowedDomainsSection() {
    return AdminSettingSection(
      title: 'Allowed Domains',
      subtitle: 'Restrict team membership to specific email domains',
      children: [
        AdminSettingField(
          label: 'Allowed Email Domains',
          description: 'Comma-separated list of allowed email domains. Leave empty to allow all.',
          child: TextField(
            controller: _allowedDomainsCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            onChanged: (_) => setState(() => _hasChanges = true),
            decoration: InputDecoration(
              hintText: 'e.g. mattermost.com, example.org',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
              filled: true, fillColor: const Color(0xFF181825),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    return AdminSettingSection(
      title: 'Team Members',
      subtitle: '$_memberTotalCount total members',
      children: [
        if (_loadingMembers)
          const Padding(padding: EdgeInsets.all(20), child: Center(child: CircularProgressIndicator(color: Colors.blueAccent, strokeWidth: 2)))
        else if (_members.isEmpty)
          const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Text('No members found.', style: TextStyle(color: Colors.white38, fontSize: 13)))
        else
          Column(
            children: [
              ..._members.map((member) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(color: const Color(0xFF181825), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                        child: Text(member.userId.isNotEmpty ? member.userId[0].toUpperCase() : '?', style: const TextStyle(color: Colors.blueAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(member.userId, style: const TextStyle(color: Colors.white, fontSize: 13), overflow: TextOverflow.ellipsis)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: member.schemeAdmin == true ? Colors.blueAccent.withValues(alpha: 0.15) : Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          member.schemeAdmin == true ? 'Team Admin' : 'Member',
                          style: TextStyle(
                            color: member.schemeAdmin == true ? Colors.blueAccent : Colors.white54,
                            fontSize: 11, fontWeight: FontWeight.bold,
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
                      icon: const Icon(Icons.chevron_left_rounded, color: Colors.white70, size: 20),
                      onPressed: _memberPage > 0 ? () { setState(() => _memberPage--); _loadMembers(); } : null,
                    ),
                    Text('Page ${_memberPage + 1}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 20),
                      onPressed: (_memberPage + 1) * 20 < _memberTotalCount ? () { setState(() => _memberPage++); _loadMembers(); } : null,
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
