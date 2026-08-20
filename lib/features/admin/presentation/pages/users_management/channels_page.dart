import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

class AdminConsoleChannelsManagementPage extends StatefulWidget {
  const AdminConsoleChannelsManagementPage({super.key});

  @override
  State<AdminConsoleChannelsManagementPage> createState() =>
      _AdminConsoleChannelsManagementPageState();
}

class _AdminConsoleChannelsManagementPageState
    extends State<AdminConsoleChannelsManagementPage> {
  final ChannelRepository _channelRepo = getIt<ChannelRepository>();
  final TeamRepository _teamRepo = getIt<TeamRepository>();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  String _searchQuery = '';
  String _filterType = 'all';
  String _filterTeam = 'all';
  bool _isLoading = true;
  List<ChannelEntity> _channels = [];
  final Map<String, ChannelStats> _channelStats = {};
  final Map<String, String> _teamNames = {};

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadChannels() async {
    setState(() => _isLoading = true);
    try {
      final myTeams = await _teamRepo.getMyTeams(perPage: 50);
      for (final team in myTeams) {
        _teamNames[team.id] = team.displayName;
      }
      final List<ChannelEntity> allChannels = [];
      for (final team in myTeams.take(10)) {
        try {
          final teamChannels = await _channelRepo.getChannelsForTeam(
            team.id,
            perPage: 100,
          );
          allChannels.addAll(teamChannels);
          for (final ch in teamChannels.take(20)) {
            try {
              final stats = await _channelRepo.getChannelStats(ch.id);
              if (mounted) setState(() => _channelStats[ch.id] = stats);
            } catch (_) {}
          }
        } catch (_) {}
      }
      if (mounted) setState(() => _channels = allChannels);
    } catch (_) {
      if (mounted) setState(() => _channels = []);
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

  Future<void> _archiveChannel(ChannelEntity channel) async {
    try {
      await _channelRepo.deleteChannel(channel.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Channel "${channel.displayName}" archived.'),
          backgroundColor: Colors.green.shade700,
        ),
      );
      _loadChannels();
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

  void _navigateToDetail(ChannelEntity channel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ChannelDetailPage(
          channelRepo: _channelRepo,
          teamRepo: _teamRepo,
          channel: channel,
          teamName: _teamNames[channel.teamId] ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredChannels = _channels.where((chn) {
      final matchesSearch =
          chn.name.toLowerCase().contains(_searchQuery) ||
          chn.displayName.toLowerCase().contains(_searchQuery);
      final isPublic = chn.type == ChannelType.open;
      final isArchived = chn.deleteAt > 0;
      if (_filterType == 'public')
        return matchesSearch && isPublic && !isArchived;
      if (_filterType == 'private')
        return matchesSearch && !isPublic && !isArchived;
      if (_filterType == 'archived') return matchesSearch && isArchived;
      if (_filterTeam != 'all')
        return matchesSearch && chn.teamId == _filterTeam;
      return matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                _buildFiltersBar(),
                const SizedBox(height: 16),
                Expanded(child: _buildTable(filteredChannels)),
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
                  const Text(
                    'Channels',
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
                      color: Colors.blueAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_channels.length} Total',
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
              const Text(
                'View and manage all public and private channels across teams.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
            onPressed: _loadChannels,
            tooltip: 'Refresh',
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
        decoration: BoxDecoration(
          color: const Color(0xFF161922),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search channels by name or display name...',
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
            DropdownButton<String>(
              value: _filterType,
              dropdownColor: const Color(0xFF212433),
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Types')),
                DropdownMenuItem(value: 'public', child: Text('Public')),
                DropdownMenuItem(value: 'private', child: Text('Private')),
                DropdownMenuItem(value: 'archived', child: Text('Archived')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _filterType = val);
              },
            ),
            const SizedBox(width: 12),
            DropdownButton<String>(
              value: _filterTeam,
              dropdownColor: const Color(0xFF212433),
              underline: const SizedBox(),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              items: [
                const DropdownMenuItem(value: 'all', child: Text('All Teams')),
                ..._teamNames.entries.map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                ),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _filterTeam = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<ChannelEntity> filteredChannels) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF161922),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.white10)),
              ),
              child: const Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'CHANNEL NAME',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'TEAM',
                      style: TextStyle(
                        color: Colors.white54,
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
                        color: Colors.white54,
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
                        color: Colors.white54,
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
                        color: Colors.white54,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (filteredChannels.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'No matching channels found.',
                    style: TextStyle(color: Colors.white38, fontSize: 14),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  itemCount: filteredChannels.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: Colors.white10),
                  itemBuilder: (context, index) {
                    final chn = filteredChannels[index];
                    final isPublic = chn.type == ChannelType.open;
                    final isArchived = chn.deleteAt > 0;
                    final displayName = chn.displayName.isNotEmpty
                        ? chn.displayName
                        : chn.name;
                    final teamName = _teamNames[chn.teamId] ?? '—';
                    final memberCount = _channelStats[chn.id]?.memberCount ?? 0;

                    return InkWell(
                      onTap: () => _navigateToDetail(chn),
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
                                  Icon(
                                    isArchived
                                        ? Icons.archive_outlined
                                        : (isPublic
                                              ? Icons.tag_rounded
                                              : Icons.lock_outline_rounded),
                                    color: isArchived
                                        ? Colors.white38
                                        : (isPublic
                                              ? Colors.blueAccent
                                              : Colors.orangeAccent),
                                    size: 18,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayName,
                                          style: TextStyle(
                                            color: isArchived
                                                ? Colors.white54
                                                : Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '~${chn.name}',
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
                            Expanded(
                              flex: 2,
                              child: Text(
                                teamName,
                                style: TextStyle(
                                  color: isArchived
                                      ? Colors.white38
                                      : Colors.white70,
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
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
                                      ? Colors.white10
                                      : (isPublic
                                            ? Colors.blueAccent.withValues(
                                                alpha: 0.15,
                                              )
                                            : Colors.orangeAccent.withValues(
                                                alpha: 0.15,
                                              )),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isArchived
                                      ? 'Archived'
                                      : (isPublic ? 'Public' : 'Private'),
                                  style: TextStyle(
                                    color: isArchived
                                        ? Colors.white38
                                        : (isPublic
                                              ? Colors.blueAccent
                                              : Colors.orangeAccent),
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
                                      ? Colors.white38
                                      : Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: IconButton(
                                tooltip: 'Edit',
                                onPressed: () => _navigateToDetail(chn),
                                icon: const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white38,
                                  size: 20,
                                ),
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
}

class _ChannelDetailPage extends StatefulWidget {
  final ChannelRepository channelRepo;
  final TeamRepository teamRepo;
  final ChannelEntity channel;
  final String teamName;

  const _ChannelDetailPage({
    required this.channelRepo,
    required this.teamRepo,
    required this.channel,
    required this.teamName,
  });

  @override
  State<_ChannelDetailPage> createState() => _ChannelDetailPageState();
}

class _ChannelDetailPageState extends State<_ChannelDetailPage> {
  late ChannelEntity _channel;
  bool _loading = true;
  String? _error;

  late TextEditingController _displayNameCtrl;
  late TextEditingController _purposeCtrl;
  late TextEditingController _headerCtrl;
  bool _hasChanges = false;

  List<Map<String, dynamic>> _members = [];
  bool _loadingMembers = false;
  int _memberPage = 0;
  int _memberTotalCount = 0;

  @override
  void initState() {
    super.initState();
    _channel = widget.channel;
    _displayNameCtrl = TextEditingController(text: _channel.displayName);
    _purposeCtrl = TextEditingController(text: _channel.purpose);
    _headerCtrl = TextEditingController(text: _channel.header);
    _loadDetail();
  }

  @override
  void dispose() {
    _displayNameCtrl.dispose();
    _purposeCtrl.dispose();
    _headerCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        widget.channelRepo.getChannelById(_channel.id),
        widget.channelRepo.getChannelStats(_channel.id),
      ]);
      if (!mounted) return;
      _channel = results[0] as ChannelEntity;
      final stats = results[1] as ChannelStats;
      _displayNameCtrl.text = _channel.displayName;
      _purposeCtrl.text = _channel.purpose;
      _headerCtrl.text = _channel.header;
      _memberTotalCount = stats.memberCount;
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
      final members = await widget.channelRepo.getChannelMembers(
        _channel.id,
        page: _memberPage,
        perPage: 20,
      );
      if (!mounted) return;
      setState(
        () => _members = members
            .map((m) => {'userId': m.userId, 'roles': m.roles})
            .toList(),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load members: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  Future<void> _saveSettings() async {
    try {
      await widget.channelRepo.updateChannel(
        _channel.id,
        displayName: _displayNameCtrl.text.trim(),
        purpose: _purposeCtrl.text.trim(),
        header: _headerCtrl.text.trim(),
      );
      if (!mounted) return;
      setState(() => _hasChanges = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Channel settings saved.'),
          backgroundColor: Colors.green,
        ),
      );
      _loadDetail();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _togglePrivacy() async {
    final newPrivacy = _channel.type == ChannelType.open ? 'P' : 'O';
    try {
      await widget.channelRepo.updateChannelPrivacy(_channel.id, newPrivacy);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Channel is now ${newPrivacy == 'O' ? 'Public' : 'Private'}.',
          ),
          backgroundColor: Colors.green,
        ),
      );
      _loadDetail();
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

  Future<void> _archiveChannel() async {
    try {
      await widget.channelRepo.deleteChannel(_channel.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Channel archived.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
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
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : _error != null
          ? Center(
              child: Text(
                'Error: $_error',
                style: const TextStyle(color: Colors.redAccent),
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
                      const SizedBox(height: 20),
                      _buildProfileSection(),
                      const SizedBox(height: 20),
                      _buildPrivacySection(),
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
                                _displayNameCtrl.text = _channel.displayName;
                                _purposeCtrl.text = _channel.purpose;
                                _headerCtrl.text = _channel.header;
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
                            onPressed: _saveSettings,
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

  Widget _buildBreadcrumb() {
    final isPublic = _channel.type == ChannelType.open;
    return Row(
      children: [
        Icon(
          isPublic ? Icons.tag_rounded : Icons.lock_outline_rounded,
          color: isPublic ? Colors.blueAccent : Colors.orangeAccent,
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _channel.displayName.isNotEmpty
                    ? _channel.displayName
                    : _channel.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'in ${widget.teamName}',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection() {
    return AdminSettingSection(
      title: 'Channel Profile',
      subtitle: 'Basic information about this channel',
      children: [
        AdminSettingField(
          label: 'Display Name',
          child: TextField(
            controller: _displayNameCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 13),
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
          label: 'Channel Name',
          child: Text(
            '~${_channel.name}',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        AdminSettingField(
          label: 'Channel Type',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: _channel.type == ChannelType.open
                  ? Colors.blueAccent.withValues(alpha: 0.15)
                  : Colors.orangeAccent.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _channel.type == ChannelType.open ? 'Public' : 'Private',
              style: TextStyle(
                color: _channel.type == ChannelType.open
                    ? Colors.blueAccent
                    : Colors.orangeAccent,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        AdminSettingField(
          label: 'Purpose',
          child: TextField(
            controller: _purposeCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 2,
            onChanged: (_) => setState(() => _hasChanges = true),
            decoration: InputDecoration(
              hintText: 'Describe the purpose of this channel',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
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
          label: 'Header',
          child: TextField(
            controller: _headerCtrl,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            maxLines: 2,
            onChanged: (_) => setState(() => _hasChanges = true),
            decoration: InputDecoration(
              hintText: 'Channel header text',
              hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
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
          label: 'Members',
          child: Text(
            '$_memberTotalCount members',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF212433),
                title: const Text(
                  'Archive Channel?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                content: Text(
                  'This will archive #${_channel.name}. Channel members will lose access.',
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
                      _archiveChannel();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    child: const Text('Archive'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(
            Icons.archive_outlined,
            size: 16,
            color: Colors.redAccent,
          ),
          label: const Text(
            'Archive Channel',
            style: TextStyle(color: Colors.redAccent, fontSize: 12),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySection() {
    final isPublic = _channel.type == ChannelType.open;
    return AdminSettingSection(
      title: 'Channel Privacy',
      subtitle: 'Control whether this channel is public or private',
      children: [
        SwitchListTile(
          title: const Text(
            'Public Channel',
            style: TextStyle(color: Colors.white, fontSize: 13),
          ),
          subtitle: Text(
            isPublic
                ? 'Anyone in the team can find and join this channel.'
                : 'Only invited members can access this channel.',
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          value: isPublic,
          activeTrackColor: Colors.blueAccent.withValues(alpha: 0.5),
          onChanged: (v) {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: const Color(0xFF212433),
                title: Text(
                  'Change to ${v ? 'Public' : 'Private'}?',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                content: Text(
                  'This will change the channel from ${isPublic ? 'public' : 'private'} to ${v ? 'public' : 'private'}. Are you sure?',
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
                      _togglePrivacy();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            );
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildMembersSection() {
    return AdminSettingSection(
      title: 'Channel Members',
      subtitle: '$_memberTotalCount total members',
      children: [
        if (_loadingMembers)
          const Padding(
            padding: EdgeInsets.all(20),
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.blueAccent,
                strokeWidth: 2,
              ),
            ),
          )
        else if (_members.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'No members found.',
              style: TextStyle(color: Colors.white38, fontSize: 13),
            ),
          )
        else
          Column(
            children: [
              ..._members.map((m) {
                final userId = m['userId'] as String? ?? '';
                final roles = m['roles'] as String? ?? '';
                final isAdmin = roles.contains('channel_admin');
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF181825),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: isAdmin
                            ? Colors.blueAccent.withValues(alpha: 0.2)
                            : Colors.white10,
                        child: Text(
                          userId.isNotEmpty ? userId[0].toUpperCase() : '?',
                          style: TextStyle(
                            color: isAdmin ? Colors.blueAccent : Colors.white54,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          userId,
                          style: const TextStyle(
                            color: Colors.white,
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
                          color: isAdmin
                              ? Colors.blueAccent.withValues(alpha: 0.15)
                              : Colors.white10,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isAdmin ? 'Channel Admin' : 'Member',
                          style: TextStyle(
                            color: isAdmin ? Colors.blueAccent : Colors.white54,
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
                      icon: const Icon(
                        Icons.chevron_left_rounded,
                        color: Colors.white70,
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
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.white70,
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
