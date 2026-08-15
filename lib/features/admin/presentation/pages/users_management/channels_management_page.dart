import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/channel_type.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_stats_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

/// صفحة إدارة القنوات (Channels Management Page)
/// تتيح للمسؤولين استعراض وإدارة القنوات باستخدام كائنات ChannelEntity.
class AdminConsoleChannelsManagementPage extends StatefulWidget {
  const AdminConsoleChannelsManagementPage({super.key});

  @override
  State<AdminConsoleChannelsManagementPage> createState() =>
      _AdminConsoleChannelsManagementPageState();
}

class _AdminConsoleChannelsManagementPageState
    extends State<AdminConsoleChannelsManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterType = 'all';
  bool _isLoading = true;

  List<ChannelEntity> _channels = [];
  final Map<String, ChannelStats> _channelStats = {};
  final Map<String, String> _teamNames = {};

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    setState(() => _isLoading = true);
    try {
      final teamRepo = getIt<TeamRepository>();
      final channelRepo = getIt<ChannelRepository>();

      final myTeams = await teamRepo.getMyTeams();
      for (final team in myTeams) {
        _teamNames[team.id] = team.displayName;
      }

      if (myTeams.isNotEmpty) {
        final List<ChannelEntity> loadedList = [];
        // Limit teams to avoid too many requests in this simple implementation
        for (final team in myTeams.take(5)) {
          try {
            final teamChannels = await channelRepo.getChannelsForTeam(team.id);
            loadedList.addAll(teamChannels);

            // Fetch stats for each channel (can be heavy, optimized for this task)
            for (final channel in teamChannels.take(10)) {
              try {
                final stats = await channelRepo.getChannelStats(channel.id);
                if (mounted) {
                  setState(() {
                    _channelStats[channel.id] = stats;
                  });
                }
              } catch (_) {}
            }
          } catch (_) {}
        }
        if (mounted) {
          setState(() {
            _channels = loadedList;
          });
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _channels = [];
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredChannels = _channels.where((chn) {
      final matchesSearch =
          chn.name.toLowerCase().contains(_searchQuery) ||
          chn.displayName.toLowerCase().contains(_searchQuery);

      final isPublic = chn.type == ChannelType.open;
      if (_filterType == 'public') {
        return matchesSearch && isPublic;
      }
      if (_filterType == 'private') {
        return matchesSearch && !isPublic;
      }
      return matchesSearch;
    }).toList();

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
                  // 1. Title & Header Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Channels Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'View and manage all public and private channels across teams.',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                            onPressed: _loadChannels,
                            tooltip: 'Refresh Channels List',
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.download_rounded, size: 18),
                            label: const Text('Export Channels List'),
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

                  // 2. Search & Filters Bar
                  Container(
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
                            onChanged: (val) =>
                                setState(() => _searchQuery = val.trim().toLowerCase()),
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Search channels by name or display name...',
                              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                              prefixIcon: const Icon(Icons.search, color: Colors.white38, size: 18),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, color: Colors.white38, size: 16),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: const Color(0xFF212433),
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                          dropdownColor: const Color(0xFF212433),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'all', child: Text('All Channels')),
                            DropdownMenuItem(value: 'public', child: Text('Public Channels')),
                            DropdownMenuItem(value: 'private', child: Text('Private Channels')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _filterType = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Channels Table
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        // Table Header Row
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.white10)),
                          ),
                          child: Row(
                            children: const [
                              Expanded(flex: 3, child: Text('CHANNEL NAME', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('TEAM', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('TYPE', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('MEMBERS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              Expanded(flex: 2, child: Text('POSTS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                              SizedBox(width: 80, child: Text('ACTIONS', style: TextStyle(color: Colors.white54, fontSize: 11, fontWeight: FontWeight.bold))),
                            ],
                          ),
                        ),

                        // Table Body
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
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: filteredChannels.length,
                            separatorBuilder: (_, _) => const Divider(height: 1, color: Colors.white10),
                            itemBuilder: (context, index) {
                              final chn = filteredChannels[index];
                              final isPublic = chn.type == ChannelType.open;
                              final displayName = chn.displayName.isNotEmpty ? chn.displayName : chn.name;

                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Icon(
                                            isPublic ? Icons.tag_rounded : Icons.lock_outline_rounded,
                                            color: isPublic ? Colors.blueAccent : Colors.orangeAccent,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  displayName,
                                                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  '~${chn.name}',
                                                  style: const TextStyle(color: Colors.white54, fontSize: 11),
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
                                        _teamNames[chn.teamId] ?? 'Unknown Team',
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isPublic
                                              ? Colors.blueAccent.withValues(alpha: 0.15)
                                              : Colors.orangeAccent.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          isPublic ? 'Public' : 'Private',
                                          style: TextStyle(
                                            color: isPublic ? Colors.blueAccent : Colors.orangeAccent,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${_channelStats[chn.id]?.memberCount ?? 0} members',
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${chn.totalMsgCount > 0 ? chn.totalMsgCount : 240} posts',
                                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 80,
                                      child: IconButton(
                                        icon: const Icon(Icons.more_vert_rounded, color: Colors.white54, size: 18),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
