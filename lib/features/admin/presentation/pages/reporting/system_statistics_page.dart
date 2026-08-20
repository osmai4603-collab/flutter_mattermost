import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class SystemStatisticsPage extends StatefulWidget {
  const SystemStatisticsPage({super.key});

  @override
  State<SystemStatisticsPage> createState() => _SystemStatisticsPageState();
}

class _SystemStatisticsPageState extends State<SystemStatisticsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();
  bool _loading = true;
  String? _error;

  AnalyticsEntity? _analytics;
  Map<String, dynamic> _serverLimits = {};
  Map<String, dynamic> _config = {};
  bool _showAdvanced = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _repository.getAnalytics(),
        _repository.getServerLimits(),
        _repository.getConfig(),
      ]);
      _analytics = results[0] as AnalyticsEntity;
      _serverLimits = results[1] as Map<String, dynamic>;
      _config = results[2] as Map<String, dynamic>;
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _activeUserCount => (_serverLimits['activeUserCount'] as int?) ?? 0;

  int get _licenseUsers {
    final license = (_config['License'] as Map<String, dynamic>?) ?? {};
    return (license['Users'] as int?) ?? 0;
  }

  bool get _isLicensed => _licenseUsers > 0;

  bool get _postsDisabled => (_analytics?.totalPosts ?? 0) == -1;

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
              'System Statistics',
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
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: colors.buttonBg),
                  )
                : _error != null
                ? _buildError(colors)
                : _buildContent(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildError(MattermostColors colors) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: colors.errorTextColor, size: 48),
          SizedBox(height: 12),
          Text(
            'Failed to load statistics',
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
            onPressed: _loadData,
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

  Widget _buildContent(MattermostColors colors) {
    if (_analytics == null) return SizedBox.shrink();

    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_postsDisabled) ...[
            _buildPerformanceBanner(colors),
            SizedBox(height: 16),
          ],
          _buildPrimaryStatsRow(colors),
          SizedBox(height: 16),
          _buildSecondaryStatsRow(colors),
          if (_isLicensed) ...[
            SizedBox(height: 16),
            _buildTertiaryStatsRow(colors),
          ],
          if (_isLicensed) ...[
            SizedBox(height: 20),
            _buildChannelTypesChart(colors),
          ],
          SizedBox(height: 20),
          _buildAdvancedToggle(colors),
          if (_showAdvanced && _isLicensed) ...[
            SizedBox(height: 16),
            _buildAdvancedCharts(colors),
          ],
          SizedBox(height: 20),
          _buildDetailedMetricsTable(colors),
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

  Widget _buildPrimaryStatsRow(MattermostColors colors) {
    final analytics = _analytics!;
    return Row(
      children: [
        _statCard(
          colors,
          'Total Users',
          _activeUserCount > 0
              ? '$_activeUserCount'
              : '${analytics.totalUsers}',
          Icons.people_outline,
          subtitle: _activeUserCount > 0 ? 'Active users' : null,
        ),
        SizedBox(width: 12),
        if (_isLicensed)
          _statCard(
            colors,
            'Licensed Seats',
            '$_licenseUsers',
            Icons.badge_outlined,
          ),
        if (_isLicensed) SizedBox(width: 12),
        _statCard(
          colors,
          'Total Teams',
          '${analytics.totalTeams}',
          Icons.groups_outlined,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Total Channels',
          '${analytics.totalChannels}',
          Icons.forum_outlined,
        ),
      ],
    );
  }

  Widget _buildSecondaryStatsRow(MattermostColors colors) {
    final analytics = _analytics!;
    return Row(
      children: [
        _statCard(
          colors,
          'Daily Active Users',
          '${analytics.activeUsers}',
          Icons.today_outlined,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Monthly Active Users',
          '${analytics.activeUsers}',
          Icons.date_range_outlined,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Total Posts',
          '${analytics.totalPosts}',
          Icons.chat_bubble_outline,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Total Sessions',
          '${analytics.totalSessions}',
          Icons.signal_cellular_alt_outlined,
        ),
      ],
    );
  }

  Widget _buildTertiaryStatsRow(MattermostColors colors) {
    final analytics = _analytics!;
    return Row(
      children: [
        _statCard(
          colors,
          'Total Commands',
          '${analytics.totalCommands}',
          Icons.terminal_outlined,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Incoming Webhooks',
          '${analytics.totalIncomingWebhooks}',
          Icons.arrow_downward_outlined,
        ),
        SizedBox(width: 12),
        _statCard(
          colors,
          'Outgoing Webhooks',
          '${analytics.totalOutgoingWebhooks}',
          Icons.arrow_upward_outlined,
        ),
      ],
    );
  }

  Widget _statCard(
    MattermostColors colors,
    String label,
    String value,
    IconData icon, {
    String? subtitle,
  }) {
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),

                if (subtitle != null) ...[
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelTypesChart(MattermostColors colors) {
    final totalPublic = _analytics!.items
        .where((i) => i.name == 'total_public_channels')
        .fold<int>(0, (s, i) => s + i.value);
    final totalPrivate = _analytics!.items
        .where((i) => i.name == 'total_private_groups')
        .fold<int>(0, (s, i) => s + i.value);
    final total = totalPublic + totalPrivate;

    if (total == 0) return SizedBox.shrink();

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
            'Channel Types',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        PieChartSectionData(
                          value: totalPublic.toDouble(),
                          title: '$totalPublic',
                          color: colors.buttonBg,
                          radius: 50,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PieChartSectionData(
                          value: totalPrivate.toDouble(),
                          title: '$totalPrivate',
                          color: colors.linkColor,
                          radius: 50,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 24),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _legendItem(
                      colors,
                      'Public',
                      colors.buttonBg,
                      totalPublic,
                      total,
                    ),
                    SizedBox(height: 12),
                    _legendItem(
                      colors,
                      'Private',
                      colors.linkColor,
                      totalPrivate,
                      total,
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

  Widget _legendItem(
    MattermostColors colors,
    String label,
    Color color,
    int count,
    int total,
  ) {
    final pct = total > 0 ? ((count / total) * 100).round() : 0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 8),
        Text(
          '$label: $count ($pct%)',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.70),
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildAdvancedToggle(MattermostColors colors) {
    return InkWell(
      onTap: () => setState(() => _showAdvanced = !_showAdvanced),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.centerChannelBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: colors.centerChannelColor.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _showAdvanced ? Icons.expand_less : Icons.expand_more,
              color: colors.buttonBg,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              _showAdvanced
                  ? 'Hide Advanced Statistics'
                  : 'Load Advanced Statistics',
              style: TextStyle(
                color: colors.buttonBg,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedCharts(MattermostColors colors) {
    return Column(
      children: [
        _buildLineChartCard(
          colors,
          'Total Posts',
          'Posts per day',
          _generatePlaceholderLineData(),
          colors.buttonBg,
        ),
        SizedBox(height: 16),
        _buildLineChartCard(
          colors,
          'Total Posts from Bots',
          'Bot posts per day',
          _generatePlaceholderLineData(),
          colors.linkColor,
        ),
        SizedBox(height: 16),
        _buildLineChartCard(
          colors,
          'Active Users With Posts',
          'Users with posts per day',
          _generatePlaceholderLineData(),
          colors.awayIndicator,
        ),
      ],
    );
  }

  List<FlSpot> _generatePlaceholderLineData() {
    return List.generate(
      14,
      (i) => FlSpot(i.toDouble(), (Random().nextDouble() * 50 + 10)),
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

  Widget _buildDetailedMetricsTable(MattermostColors colors) {
    final analytics = _analytics!;
    final rows = <(String label, String value)>[
      ('Total Users', '${analytics.totalUsers}'),
      ('Total Teams', '${analytics.totalTeams}'),
      ('Total Channels', '${analytics.totalChannels}'),
      ('Total Posts', '${analytics.totalPosts}'),
      ('Total Sessions', '${analytics.totalSessions}'),
      ('Total Commands', '${analytics.totalCommands}'),
      ('Incoming Webhooks', '${analytics.totalIncomingWebhooks}'),
      ('Outgoing Webhooks', '${analytics.totalOutgoingWebhooks}'),
    ];

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
            'Detailed Metrics',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              Divider(
                color: colors.centerChannelColor.withValues(alpha: 0.06),
                height: 1,
              ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      rows[i].$1,
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.70,
                        ),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    rows[i].$2,
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
