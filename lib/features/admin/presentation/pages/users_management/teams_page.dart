import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/team_type.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/entities/team_stats_entity.dart';
import 'package:flutter_mattermost/features/teams/domain/repositories/team_repository.dart';

/// صفحة إدارة الفرق (Teams Management Page)
/// تتيح للمسؤولين استعراض وإدارة جميع الفرق من خادم Mattermost باستخدام كائنات TeamEntity.
class TeamsPage extends StatefulWidget {
  const TeamsPage({super.key});

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  final TextEditingController _searchController = TextEditingController();
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

  Future<void> _loadTeams() async {
    setState(() => _isLoading = true);
    try {
      final repo = getIt<TeamRepository>();
      final repoTeams = await repo.getMyTeams();
      if (mounted) {
        setState(() {
          _teams = repoTeams;
        });
      }

      // Load stats for all teams
      for (final team in repoTeams) {
        try {
          final stats = await repo.getTeamStats(team.id);
          if (mounted) {
            setState(() {
              _teamStats[team.id] = stats;
            });
          }
        } catch (_) {
          // Ignore stats error for individual team
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _teams = [];
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
    final filteredTeams = _teams.where((team) {
      final matchesSearch =
          team.displayName.toLowerCase().contains(_searchQuery) ||
          team.name.toLowerCase().contains(_searchQuery);

      final isPublic = team.type == TeamType.open || team.allowOpenInvite;
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
                            'Teams Management',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'View, configure, and manage all teams across your workspace.',
                            style: TextStyle(
                              color: Colors.white54,
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
                            onPressed: _loadTeams,
                            tooltip: 'Refresh Teams List',
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => _showCreateTeamDialog(context),
                            icon: const Icon(Icons.add_rounded, size: 18),
                            label: const Text('Create Team'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
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
                            onChanged: (val) => setState(
                              () => _searchQuery = val.trim().toLowerCase(),
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search teams by name or handle...',
                              hintStyle: const TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Colors.white38,
                                size: 18,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.white38,
                                        size: 16,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
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
                        const SizedBox(width: 16),
                        DropdownButton<String>(
                          value: _filterType,
                          dropdownColor: const Color(0xFF212433),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text('All Types'),
                            ),
                            DropdownMenuItem(
                              value: 'public',
                              child: Text('Public Teams'),
                            ),
                            DropdownMenuItem(
                              value: 'private',
                              child: Text('Private Teams'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _filterType = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 3. Teams Table
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
                            children: const [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'TEAM NAME',
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
                                  'HANDLE',
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
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'CHANNELS',
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

                        // Table Body
                        if (filteredTeams.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(40),
                            child: Center(
                              child: Text(
                                'No matching teams found.',
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
                            itemCount: filteredTeams.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1, color: Colors.white10),
                            itemBuilder: (context, index) {
                              final team = filteredTeams[index];
                              final isPublic =
                                  team.type == TeamType.open ||
                                  team.allowOpenInvite;
                              final displayName = team.displayName.isNotEmpty
                                  ? team.displayName
                                  : team.name;

                              return Container(
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
                                            backgroundColor: isPublic
                                                ? Colors.blueAccent.withValues(
                                                    alpha: 0.2,
                                                  )
                                                : Colors.purpleAccent
                                                      .withValues(alpha: 0.2),
                                            child: Text(
                                              displayName.isNotEmpty
                                                  ? displayName[0].toUpperCase()
                                                  : 'T',
                                              style: TextStyle(
                                                color: isPublic
                                                    ? Colors.blueAccent
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
                                                  displayName,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                if (team.description.isNotEmpty)
                                                  Text(
                                                    team.description,
                                                    style: const TextStyle(
                                                      color: Colors.white54,
                                                      fontSize: 11,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                        style: const TextStyle(
                                          color: Colors.white70,
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
                                          color: isPublic
                                              ? Colors.blueAccent.withValues(
                                                  alpha: 0.15,
                                                )
                                              : Colors.purpleAccent.withValues(
                                                  alpha: 0.15,
                                                ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          isPublic ? 'Public' : 'Private',
                                          style: TextStyle(
                                            color: isPublic
                                                ? Colors.blueAccent
                                                : Colors.purpleAccent,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${_teamStats[team.id]?.total_member_count ?? 0} members',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
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
                                    SizedBox(
                                      width: 80,
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.more_vert_rounded,
                                          color: Colors.white54,
                                          size: 18,
                                        ),
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

  void _showCreateTeamDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF212433),
        title: const Text(
          'Create New Team',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Team Name',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Team Handle / URL',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white38),
                ),
              ),
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
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
