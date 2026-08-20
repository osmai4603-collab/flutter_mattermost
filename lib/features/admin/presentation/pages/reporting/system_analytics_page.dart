import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';
import 'package:flutter_mattermost/features/admin/presentation/bloc/admin_config_bloc.dart';

/// صفحة "نظرة عامة / إحصاءات النظام".
class AdminConsoleSystemAnalyticsPage extends StatelessWidget {
  const AdminConsoleSystemAnalyticsPage({super.key});

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
              'System Analytics',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (_) => getIt<AdminConfigBloc>()..add(LoadAdminOverviewEvent()),
        child: BlocConsumer<AdminConfigBloc, AdminConfigState>(
          listener: (context, state) {
            if (state is AdminConfigError) {
              final colors = AppTheme.of(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: colors.errorTextColor,
                ),
              );
            }
          },
          builder: (context, state) {
            return Column(
              spacing: 24,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: switch (state) {
                    AdminConfigLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    AdminConfigLoaded() => _buildDashboard(
                      context,
                      state.analytics,
                    ),
                    AdminConfigError() => _buildError(state.message),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Builder(
        builder: (context) {
          final colors = AppTheme.of(context);
          return Text(
            'Could not load analytics: $message',
            style: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.54),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, AnalyticsEntity analytics) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _statCard(
                context,
                'Total Users',
                analytics.totalUsers,
                Icons.people_outline,
              ),
              _statCard(
                context,
                'Total Teams',
                analytics.totalTeams,
                Icons.groups_outlined,
              ),
              _statCard(
                context,
                'Total Channels',
                analytics.totalChannels,
                Icons.forum_outlined,
              ),
              _statCard(
                context,
                'Total Posts',
                analytics.totalPosts,
                Icons.chat_bubble_outline,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildChartsCard(context, analytics),
          const SizedBox(height: 20),
          _buildMetricsTable(context, analytics),
        ],
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String label,
    int value,
    IconData icon,
  ) {
    final colors = AppTheme.of(context);
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.mentionHighlightBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: colors.buttonBg, size: 20),
            const SizedBox(height: 10),
            Text(
              '$value',
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

  Widget _buildChartsCard(BuildContext context, AnalyticsEntity analytics) {
    final colors = AppTheme.of(context);
    final bars = [
      (
        label: 'Users',
        value: analytics.totalUsers.toDouble(),
        color: colors.buttonBg,
      ),
      (
        label: 'Teams',
        value: analytics.totalTeams.toDouble(),
        color: colors.linkColor,
      ),
      (
        label: 'Channels',
        value: analytics.totalChannels.toDouble(),
        color: colors.mentionBg,
      ),
      (
        label: 'Posts',
        value: analytics.totalPosts.toDouble(),
        color: colors.awayIndicator,
      ),
    ];
    final maxY =
        (bars.map((b) => b.value).reduce((a, b) => a > b ? a : b) * 1.2).clamp(
          1,
          double.infinity,
        );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.mentionHighlightBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Server Usage',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: maxY.toDouble(),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) =>
                        colors.centerChannelColor.withValues(alpha: 0.20),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                          '${bars[group.x.toInt()].label}: ${rod.toY.round()}',
                          TextStyle(color: colors.centerChannelColor),
                        ),
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 || value.toInt() >= bars.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            bars[value.toInt()].label,
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.54,
                              ),
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: colors.centerChannelColor.withValues(alpha: 0.12),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  for (var i = 0; i < bars.length; i++)
                    BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: bars[i].value,
                          color: bars[i].color,
                          width: 32,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsTable(BuildContext context, AnalyticsEntity analytics) {
    final colors = AppTheme.of(context);
    final rows = analytics.items
        .where((k) => k.name != 'total_users')
        .take(12)
        .toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.mentionHighlightBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detailed Metrics',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final key in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      key.name.replaceAll('_', ' '),
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.70,
                        ),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    key.value.toString(),
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
      ),
    );
  }
}
