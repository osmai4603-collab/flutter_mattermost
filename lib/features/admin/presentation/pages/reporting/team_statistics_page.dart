import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/teams/data/datasources/teams_remote_data_source.dart';
import 'package:flutter_mattermost/features/teams/data/models/team_model.dart';

class TeamStatisticsPage extends StatefulWidget {
  const TeamStatisticsPage({super.key});

  @override
  State<TeamStatisticsPage> createState() => _TeamStatisticsPageState();
}

class _TeamStatisticsPageState extends State<TeamStatisticsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();
  final TeamsRemoteDataSource _teamsDataSource = getIt<TeamsRemoteDataSource>();

  bool _loading = true;
  String? _error;

  List<TeamModel> _teams = [];
  TeamModel? _selectedTeam;
  AnalyticsEntity? _analytics;
  bool _postsDisabled = false;

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _loadTeams() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _teams = await _teamsDataSource.getTeams(perPage: 1000);
      _teams.sort((a, b) => a.displayName.compareTo(b.displayName));
      if (_teams.isNotEmpty) {
        _selectedTeam = _teams.first;
        await _loadTeamStats(_selectedTeam!.id);
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      _error = e.toString();
      setState(() => _loading = false);
    }
  }

  Future<void> _loadTeamStats(String teamId) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _analytics = await _repository.getAnalytics(teamId: teamId);
      _postsDisabled = (_analytics?.totalPosts ?? 0) == -1;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onTeamChanged(TeamModel? team) {
    if (team != null && team.id != _selectedTeam?.id) {
      setState(() => _selectedTeam = team);
      _loadTeamStats(team.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Team Statistics',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        spacing: 24,
        children: [
          Expanded(
            child: _loading && _selectedTeam == null
                ? Center(
                    child: CircularProgressIndicator(color: colors.buttonBg),
                  )
                : _teams.isEmpty
                ? _buildNoTeams(colors)
                : _buildContent(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSelector(MattermostColors colors) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.15),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<TeamModel>(
          value: _selectedTeam,
          isDense: true,
          dropdownColor: colors.centerChannelBg,
          style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          items: _teams.map((team) {
            return DropdownMenuItem(
              value: team,
              child: Text(team.displayName, overflow: TextOverflow.ellipsis),
            );
          }).toList(),
          onChanged: _onTeamChanged,
        ),
      ),
    );
  }

  Widget _buildNoTeams(MattermostColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.groups_outlined,
            color: colors.centerChannelColor.withValues(alpha: 0.20),
            size: 64,
          ),
          SizedBox(height: 16),
          Text(
            'No Teams Available',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'This server has no teams for which to view statistics.',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(MattermostColors colors) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: colors.errorTextColor, size: 48),
            SizedBox(height: 12),
            Text(
              'Failed to load team statistics',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _error ?? '',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _loadTeamStats(_selectedTeam!.id),
              icon: Icon(Icons.refresh, size: 16),
              label: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.buttonBg,
                foregroundColor: colors.buttonColor,
              ),
            ),
          ],
        ),
      );
    }

    if (_analytics == null) return SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner(colors),
          SizedBox(height: 16),
          if (_postsDisabled) ...[
            _buildPerformanceBanner(colors),
            SizedBox(height: 16),
          ],
          _buildStatsRow(colors),
          SizedBox(height: 20),
          _buildLineChartCard(
            colors,
            'Total Posts',
            'Posts per day for ${_selectedTeam?.displayName ?? ''}',
            _generatePlaceholderLineData(),
            colors.buttonBg,
          ),
          SizedBox(height: 16),
          _buildLineChartCard(
            colors,
            'Active Users With Posts',
            'Users with posts per day for ${_selectedTeam?.displayName ?? ''}',
            _generatePlaceholderLineData(),
            colors.awayIndicator,
          ),
          SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildUserTable(
                  colors,
                  'Recent Active Users',
                  _generatePlaceholderUsers(colors, 'last_activity_at'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildUserTable(
                  colors,
                  'Newly Created Users',
                  _generatePlaceholderUsers(colors, 'create_at'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(MattermostColors colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.buttonBg.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.buttonBg.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.buttonBg, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Use data for only the chosen team. Exclude posts in direct message channels that are not tied to a team.',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.70),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceBanner(MattermostColors colors) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: Colors.amber.shade700,
            size: 18,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'To maximize performance, some statistics are disabled. You can re-enable them in config.json.',
              style: TextStyle(color: Colors.amber.shade900, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(MattermostColors colors) {
    final analytics = _analytics!;
    return Row(
      children: [
        _statCard(
          colors,
          'Total Users',
          '${analytics.totalUsers}',
          Icons.people_outline,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Total Channels',
          '${analytics.totalChannels}',
          Icons.forum_outlined,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Total Posts',
          '${analytics.totalPosts}',
          Icons.chat_bubble_outline,
        ),
      ],
    );
  }

  Widget _statCard(
    MattermostColors colors,
    String label,
    String value,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.centerChannelBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colors.centerChannelColor.withValues(alpha: 0.10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.buttonBg, size: 20),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generatePlaceholderLineData() {
    return List.generate(
      14,
      (i) => FlSpot(i.toDouble(), (Random().nextDouble() * 30 + 5)),
    );
  }

  Widget _buildLineChartCard(
    MattermostColors colors,
    String title,
    String subtitle,
    List<FlSpot> spots,
    Color lineColor,
  ) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
              fontSize: 12,
            ),
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: colors.centerChannelColor.withValues(alpha: 0.08),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.38,
                          ),
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() % 3 != 0) return SizedBox.shrink();
                        return Padding(
                          padding: EdgeInsets.only(top: 6),
                          child: Text(
                            '${value.toInt()}d',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.38,
                              ),
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withValues(alpha: 0.10),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_UserEntry> _generatePlaceholderUsers(
    MattermostColors colors,
    String sortField,
  ) {
    final names = ['alice', 'bob', 'charlie', 'diana', 'eve'];
    return List.generate(5, (i) {
      return _UserEntry(
        username: names[i],
        email: '${names[i]}@example.com',
        lastActivity: '2024-01-${(10 + i).toString().padLeft(2, '0')}',
      );
    });
  }

  Widget _buildUserTable(
    MattermostColors colors,
    String title,
    List<_UserEntry> users,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          if (users.isEmpty)
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No users found',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                  fontSize: 13,
                ),
              ),
            )
          else
            for (var i = 0; i < users.length; i++) ...[
              if (i > 0)
                Divider(
                  color: colors.centerChannelColor.withValues(alpha: 0.06),
                  height: 1,
                ),
              _buildUserRow(colors, users[i]),
            ],
        ],
      ),
    );
  }

  Widget _buildUserRow(MattermostColors colors, _UserEntry user) {
    return Tooltip(
      message: user.email,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: colors.buttonBg.withValues(alpha: 0.15),
              child: Text(
                user.username[0].toUpperCase(),
                style: TextStyle(
                  color: colors.buttonBg,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    user.lastActivity,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 11,
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
}

class _UserEntry {
  final String username;
  final String email;
  final String lastActivity;

  const _UserEntry({
    required this.username,
    required this.email,
    required this.lastActivity,
  });
}
