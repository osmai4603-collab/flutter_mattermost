import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_status.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/data/models/audit_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/compliance_report_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/audit_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/compliance_report_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_compliance_repository.dart';

/// صفحة الامتثال: تقارير الامتثال + سجل التدقيق (Audit Log).
class AdminConsoleCompliancePage extends StatefulWidget {
  const AdminConsoleCompliancePage({super.key});

  @override
  State<AdminConsoleCompliancePage> createState() =>
      _AdminConsoleCompliancePageState();
}

class _AdminConsoleCompliancePageState
    extends State<AdminConsoleCompliancePage> {
  final AdminComplianceRepository _repository =
      getIt<AdminComplianceRepository>();

  List<ComplianceReportEntity> _reports = [];
  List<AuditEntity> _audits = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        _repository.getComplianceReports(),
        _repository.getAudits(perPage: 100),
      ]);
      if (!mounted) return;
      setState(() {
        _reports = results[0] as List<ComplianceReportModel>;
        _audits = results[1] as List<AuditModel>;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _createReport(ComplianceReportType type) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.createComplianceReport(
        jobName: type == .daily
            ? 'Compliance Report (Daily)'
            : 'Compliance Report (Ad Hoc)',
        reportType: type,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Report job created')));
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _deleteReport(ComplianceReportEntity report) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.removeComplianceReport(report.id);
      if (!mounted) return;
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: colors.errorTextColor,
        ),
      );
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
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Compliance',
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: colors.buttonBg),
                  )
                : _error != null
                ? Center(
                    child: Text(
                      'Could not load compliance data: $_error',
                      style: TextStyle(
                        color: colors.errorTextColor,
                        fontSize: 13,
                      ),
                    ),
                  )
                : _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = AppTheme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _createReport(.daily),
                style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
                icon: const Icon(Icons.add_task_outlined, size: 16),
                label: const Text('Run Daily Report'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _createReport(.adhoc),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.buttonBg,
                  side: BorderSide(color: colors.buttonBg),
                ),
                icon: const Icon(Icons.playlist_add_outlined, size: 16),
                label: const Text('Run Ad-Hoc Report'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _loading ? null : _load,
                icon: Icon(
                  Icons.refresh,
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Compliance Reports',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_reports.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'No compliance reports yet',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                ),
              ),
            )
          else
            for (final report in _reports)
              Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: colors.mentionHighlightBg,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colors.centerChannelColor.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      report.status == ComplianceReportStatus.finished
                          ? Icons.check_circle_outline
                          : Icons.pending_outlined,
                      color: report.status == ComplianceReportStatus.finished
                          ? colors.onlineIndicator
                          : colors.awayIndicator,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${report.type.value} report (${report.count} events)',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Created at ${report.createAtDate?.toString().split('.').first ?? '—'}'
                            ' · Status: ${report.status.value}',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.38,
                              ),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (report.status == ComplianceReportStatus.finished)
                      IconButton(
                        tooltip: 'Delete',
                        onPressed: () => _deleteReport(report),
                        icon: Icon(
                          Icons.delete_outline,
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.38,
                          ),
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
          const SizedBox(height: 20),
          Text(
            'Audit Log (recent)',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_audits.isEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                'No audit entries',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                ),
              ),
            )
          else
            for (final audit in _audits.take(50))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        audit.createAtDate?.toString().split('.').first ?? '—',
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.38,
                          ),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        audit.action,
                        style: TextStyle(color: colors.buttonBg, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        audit.extraInfo,
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.70,
                          ),
                          fontSize: 12,
                        ),
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
