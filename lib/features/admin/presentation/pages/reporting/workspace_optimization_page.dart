import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

enum CheckStatus { ok, info, warning, error }

class _CheckResult {
  final String title;
  final String description;
  final CheckStatus status;
  final int scoreImpact;
  final String? ctaLabel;

  const _CheckResult({
    required this.title,
    required this.description,
    required this.status,
    required this.scoreImpact,
    this.ctaLabel,
  });
}

class _CategoryResult {
  final String title;
  final IconData icon;
  final List<_CheckResult> checks;

  const _CategoryResult({
    required this.title,
    required this.icon,
    required this.checks,
  });

  int get score {
    if (checks.isEmpty) return 100;
    final total = checks.fold<int>(0, (sum, c) => sum + c.scoreImpact);
    final actual = checks.fold<int>(0, (sum, c) {
      switch (c.status) {
        case CheckStatus.ok:
          return sum + c.scoreImpact;
        case CheckStatus.info:
          return sum + (c.scoreImpact ~/ 2);
        case CheckStatus.warning:
          return sum + (c.scoreImpact ~/ 4);
        case CheckStatus.error:
          return sum;
      }
    });
    return total > 0 ? ((actual / total) * 100).round() : 100;
  }
}

class WorkspaceOptimizationPage extends StatefulWidget {
  const WorkspaceOptimizationPage({super.key});

  @override
  State<WorkspaceOptimizationPage> createState() =>
      _WorkspaceOptimizationPageState();
}

class _WorkspaceOptimizationPageState extends State<WorkspaceOptimizationPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();
  bool _loading = true;
  String? _error;

  List<_CategoryResult> _categories = [];
  String _currentVersion = '';
  String _latestVersion = '';
  Map<String, dynamic> _config = {};
  Map<String, dynamic> _pingResult = {};
  Map<String, dynamic> _serverLimits = {};
  bool _elasticsearchOk = false;

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
        _repository.getConfig(),
        _repository.ping(),
        _repository.getServerLimits(),
        _repository.getLatestVersion().catchError((_) => ''),
      ]);

      _config = results[0] as Map<String, dynamic>;
      _pingResult = results[1] as Map<String, dynamic>;
      _serverLimits = results[2] as Map<String, dynamic>;
      _latestVersion = results[3] as String;

      _currentVersion = (_pingResult['version'] as String?) ?? '';

      try {
        await _repository.testElasticsearch();
        _elasticsearchOk = true;
      } catch (_) {
        _elasticsearchOk = false;
      }

      _buildCategories();
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _buildCategories() {
    final serviceSettings =
        (_config['ServiceSettings'] as Map<String, dynamic>?) ?? {};
    final sessionSettings =
        (_config['SessionSettings'] as Map<String, dynamic>?) ?? {};

    final siteUrl = (serviceSettings['SiteURL'] as String?) ?? '';
    final isSSL = siteUrl.startsWith('https');
    final sessionHours =
        (sessionSettings['SessionLengthMobileInHours'] as int?) ?? 720;
    final totalUsers = (_serverLimits['activeUserCount'] as int?) ?? 0;
    final totalPosts = (_pingResult['total_posts'] as int?) ?? -1;

    final filestoreStatus =
        (_pingResult['filestore_status'] as String?) ?? 'UNKNOWN';
    final rootStatus = (_pingResult['root_status'] as String?) ?? 'UNKNOWN';

    _categories = [
      _CategoryResult(
        title: 'Server Updates',
        icon: Icons.system_update_outlined,
        checks: [
          _CheckResult(
            title: 'Server Version',
            description:
                _latestVersion.isNotEmpty && _currentVersion != _latestVersion
                ? 'A new version ($_latestVersion) is available. Current: $_currentVersion'
                : 'Server is up to date ($_currentVersion)',
            status:
                _latestVersion.isNotEmpty && _currentVersion != _latestVersion
                ? CheckStatus.warning
                : CheckStatus.ok,
            scoreImpact: 15,
            ctaLabel:
                _latestVersion.isNotEmpty && _currentVersion != _latestVersion
                ? 'Download update'
                : null,
          ),
        ],
      ),
      _CategoryResult(
        title: 'Configuration',
        icon: Icons.settings_outlined,
        checks: [
          _CheckResult(
            title: 'SSL/TLS',
            description: isSSL
                ? 'SSL is enabled. Your connection is secure.'
                : 'SSL is not enabled. Consider using HTTPS.',
            status: isSSL ? CheckStatus.ok : CheckStatus.warning,
            scoreImpact: 25,
          ),
          _CheckResult(
            title: 'Session Length',
            description: sessionHours == 720
                ? 'Using default session length (30 days).'
                : 'Session length is set to ${sessionHours}h (${(sessionHours / 24).round()} days).',
            status: sessionHours == 720 ? CheckStatus.info : CheckStatus.ok,
            scoreImpact: 8,
          ),
          _CheckResult(
            title: 'File Storage',
            description: filestoreStatus == 'OK'
                ? 'File storage is configured correctly.'
                : 'File storage status: $filestoreStatus',
            status: filestoreStatus == 'OK'
                ? CheckStatus.ok
                : CheckStatus.error,
            scoreImpact: 50,
          ),
          _CheckResult(
            title: 'Root Status',
            description: rootStatus == 'OK'
                ? 'Server root status is healthy.'
                : 'Root status: $rootStatus',
            status: rootStatus == 'OK' ? CheckStatus.ok : CheckStatus.warning,
            scoreImpact: 25,
          ),
        ],
      ),
      _CategoryResult(
        title: 'Workspace Access',
        icon: Icons.language_outlined,
        checks: [
          _CheckResult(
            title: 'Site URL',
            description: siteUrl.isNotEmpty
                ? 'Site URL is configured: $siteUrl'
                : 'Site URL is not configured.',
            status: siteUrl.isNotEmpty ? CheckStatus.ok : CheckStatus.warning,
            scoreImpact: 12,
            ctaLabel: siteUrl.isEmpty ? 'Configure web server' : null,
          ),
        ],
      ),
      _CategoryResult(
        title: 'Performance',
        icon: Icons.speed_outlined,
        checks: [
          _CheckResult(
            title: 'Elasticsearch',
            description: totalPosts > 2000000 && totalUsers > 500
                ? (_elasticsearchOk
                      ? 'Elasticsearch is enabled and working.'
                      : 'Elasticsearch is recommended for this server size but is not configured.')
                : 'Elasticsearch is optional for this server size.',
            status: totalPosts > 2000000 && totalUsers > 500
                ? (_elasticsearchOk ? CheckStatus.ok : CheckStatus.warning)
                : CheckStatus.info,
            scoreImpact: 20,
            ctaLabel: !_elasticsearchOk ? 'Try Elasticsearch' : null,
          ),
        ],
      ),
      _CategoryResult(
        title: 'Data Privacy',
        icon: Icons.privacy_tip_outlined,
        checks: [
          _CheckResult(
            title: 'Data Retention',
            description:
                'Data retention policies help manage storage and comply with regulations.',
            status: CheckStatus.info,
            scoreImpact: 16,
          ),
        ],
      ),
      _CategoryResult(
        title: 'Ease of Management',
        icon: Icons.admin_panel_settings_outlined,
        checks: [
          _CheckResult(
            title: 'AD/LDAP',
            description: totalUsers > 100
                ? 'AD/LDAP is recommended for managing users at this scale.'
                : 'AD/LDAP is optional for this server size.',
            status: totalUsers > 100 ? CheckStatus.info : CheckStatus.ok,
            scoreImpact: 22,
          ),
        ],
      ),
    ];
  }

  int get _overallScore {
    if (_categories.isEmpty) return 0;
    final totalImpact = _categories.fold<int>(
      0,
      (sum, c) => sum + c.checks.fold<int>(0, (s, ch) => s + ch.scoreImpact),
    );
    final weightedSum = _categories.fold<int>(0, (sum, c) {
      final catTotal = c.checks.fold<int>(0, (s, ch) => s + ch.scoreImpact);
      return sum + ((c.score * catTotal) / 100).round();
    });
    return totalImpact > 0 ? ((weightedSum / totalImpact) * 100).round() : 100;
  }

  int get _suggestionsCount => _categories.fold<int>(
    0,
    (sum, c) =>
        sum + c.checks.where((ch) => ch.status == CheckStatus.info).length,
  );

  int get _warningsCount => _categories.fold<int>(
    0,
    (sum, c) =>
        sum + c.checks.where((ch) => ch.status == CheckStatus.warning).length,
  );

  int get _problemsCount => _categories.fold<int>(
    0,
    (sum, c) =>
        sum + c.checks.where((ch) => ch.status == CheckStatus.error).length,
  );

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
              'Workspace Optimization',
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
                : _buildDashboard(colors),
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
            'Failed to load workspace data',
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

  Widget _buildDashboard(MattermostColors colors) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallScoreCard(colors),
          SizedBox(height: 20),
          _buildChipsRow(colors),
          SizedBox(height: 24),
          ..._categories.map((cat) => _buildCategoryAccordion(colors, cat)),
        ],
      ),
    );
  }

  Widget _buildOverallScoreCard(MattermostColors colors) {
    final score = _overallScore;
    final scoreColor = score >= 80
        ? colors.onlineIndicator
        : score >= 50
        ? colors.awayIndicator
        : colors.errorTextColor;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 10,
                    backgroundColor: colors.centerChannelColor.withValues(
                      alpha: 0.12,
                    ),
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      score >= 80
                          ? Icons.check_circle_outline
                          : score >= 50
                          ? Icons.warning_amber_outlined
                          : Icons.error_outline,
                      color: scoreColor,
                      size: 28,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '$score%',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Health Score',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Based on ${_categories.length} diagnostic categories with ${_categories.fold<int>(0, (s, c) => s + c.checks.length)} checks.',
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.54),
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    _scoreChip(
                      colors,
                      '$_suggestionsCount Suggestions',
                      Colors.lightBlueAccent,
                    ),
                    SizedBox(width: 8),
                    _scoreChip(
                      colors,
                      '$_warningsCount Warnings',
                      colors.awayIndicator,
                    ),
                    SizedBox(width: 8),
                    _scoreChip(
                      colors,
                      '$_problemsCount Problems',
                      colors.errorTextColor,
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

  Widget _scoreChip(MattermostColors colors, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChipsRow(MattermostColors colors) {
    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: [
        _infoChip(
          colors,
          Icons.check_circle_outline,
          '${_categories.where((c) => c.score >= 80).length} Categories Healthy',
          colors.onlineIndicator,
        ),
        _infoChip(
          colors,
          Icons.warning_amber_outlined,
          '${_categories.where((c) => c.score >= 50 && c.score < 80).length} Need Attention',
          colors.awayIndicator,
        ),
        _infoChip(
          colors,
          Icons.error_outline,
          '${_categories.where((c) => c.score < 50).length} Critical Issues',
          colors.errorTextColor,
        ),
      ],
    );
  }

  Widget _infoChip(
    MattermostColors colors,
    IconData icon,
    String label,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryAccordion(MattermostColors colors, _CategoryResult cat) {
    final catColor = cat.score >= 80
        ? colors.onlineIndicator
        : cat.score >= 50
        ? colors.awayIndicator
        : colors.errorTextColor;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: ExpansionTile(
        leading: Icon(cat.icon, color: catColor, size: 22),
        title: Row(
          children: [
            Expanded(
              child: Text(
                cat.title,
                style: TextStyle(
                  color: colors.centerChannelColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: catColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${cat.score}%',
                style: TextStyle(
                  color: catColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        children: cat.checks
            .map((check) => _buildCheckTile(colors, check))
            .toList(),
      ),
    );
  }

  Widget _buildCheckTile(MattermostColors colors, _CheckResult check) {
    final statusColor = check.status == CheckStatus.ok
        ? colors.onlineIndicator
        : check.status == CheckStatus.warning
        ? colors.awayIndicator
        : check.status == CheckStatus.error
        ? colors.errorTextColor
        : Colors.lightBlueAccent;

    final statusIcon = check.status == CheckStatus.ok
        ? Icons.check_circle_outline
        : check.status == CheckStatus.warning
        ? Icons.warning_amber_outlined
        : check.status == CheckStatus.error
        ? Icons.error_outline
        : Icons.info_outline;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(statusIcon, color: statusColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  check.title,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  check.description,
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.60),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          if (check.ctaLabel != null) ...[
            SizedBox(width: 12),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: colors.buttonBg,
                side: BorderSide(color: colors.buttonBg),
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size(0, 32),
              ),
              child: Text(check.ctaLabel!, style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
