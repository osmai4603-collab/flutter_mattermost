import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';
import 'package:flutter_mattermost/features/admin/presentation/bloc/admin_config_bloc.dart';

/// صفحة "نظرة عامة / إحصاءات النظام".
class AdminConsoleSystemAnalyticsPage extends StatelessWidget {
  const AdminConsoleSystemAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AdminConfigBloc>()..add(LoadAdminOverviewEvent()),
      child: BlocConsumer<AdminConfigBloc, AdminConfigState>(
        listener: (context, state) {
          if (state is AdminConfigError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              Expanded(
                child: switch (state) {
                  AdminConfigLoading() => const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: const Row(
        children: [
          Icon(Icons.insights_outlined, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'Site Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Text(
        'Could not load analytics: $message',
        style: const TextStyle(color: Colors.white54),
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
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF181825),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blueAccent, size: 20),
            const SizedBox(height: 10),
            Text(
              '$value',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsCard(BuildContext context, AnalyticsEntity analytics) {
    final bars = [
      (
        label: 'Users',
        value: analytics.totalUsers.toDouble(),
        color: Colors.blueAccent,
      ),
      (
        label: 'Teams',
        value: analytics.totalTeams.toDouble(),
        color: Colors.lightBlueAccent,
      ),
      (
        label: 'Channels',
        value: analytics.totalChannels.toDouble(),
        color: Colors.purpleAccent,
      ),
      (
        label: 'Posts',
        value: analytics.totalPosts.toDouble(),
        color: Colors.orangeAccent,
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
        color: const Color(0xFF181825),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Server Usage',
            style: TextStyle(
              color: Colors.white,
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
                    getTooltipColor: (_) => const Color(0xFF313244),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                        BarTooltipItem(
                          '${bars[group.x.toInt()].label}: ${rod.toY.round()}',
                          const TextStyle(color: Colors.white),
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
                            style: const TextStyle(
                              color: Colors.white54,
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
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: Colors.white12),
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
    final rows = analytics.availableKeys
        .where((k) => k != 'total_users')
        .take(12)
        .toList();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF181825),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detailed Metrics',
            style: TextStyle(
              color: Colors.white,
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
                      key.replaceAll('_', ' '),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    analytics.displayValue(key),
                    style: const TextStyle(
                      color: Colors.white,
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
