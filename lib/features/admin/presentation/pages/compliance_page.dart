import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_status.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';
import 'package:flutter_mattermost/features/admin/data/models/audit_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/compliance_report_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/audit_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/compliance_report_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_compliance_repository.dart';

/// صفحة الامتثال: تقارير الامتثال + سجل التدقيق (Audit Log).
class AdminConsoleCompliancePage extends StatefulWidget {
  const AdminConsoleCompliancePage({super.key});

  @override
  State<AdminConsoleCompliancePage> createState() => _AdminConsoleCompliancePageState();
}

class _AdminConsoleCompliancePageState extends State<AdminConsoleCompliancePage> {
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
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _deleteReport(ComplianceReportEntity report) async {
    try {
      await _repository.removeComplianceReport(report.id);
      if (!mounted) return;
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load compliance data: $_error',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                )
              : _buildContent(context),
        ),
      ],
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
          Icon(Icons.policy_outlined, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'Compliance',
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

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FilledButton.icon(
                onPressed: () => _createReport(.daily),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: const Icon(Icons.add_task_outlined, size: 16),
                label: const Text('Run Daily Report'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () => _createReport(.adhoc),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blueAccent,
                  side: const BorderSide(color: Colors.blueAccent),
                ),
                icon: const Icon(Icons.playlist_add_outlined, size: 16),
                label: const Text('Run Ad-Hoc Report'),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _loading ? null : _load,
                icon: const Icon(Icons.refresh, color: Colors.white54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Compliance Reports',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_reports.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'No compliance reports yet',
                style: TextStyle(color: Colors.white38),
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
                  color: const Color(0xFF181825),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white12),
                ),
                child: Row(
                  children: [
                    Icon(
                      report.status == ComplianceReportStatus.finished
                          ? Icons.check_circle_outline
                          : Icons.pending_outlined,
                      color: report.status == ComplianceReportStatus.finished
                          ? Colors.lightGreenAccent
                          : Colors.orangeAccent,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${report.type.value} report (${report.count} events)',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            'Created at ${report.createAtDate?.toString().split('.').first ?? '—'}'
                            ' · Status: ${report.status.value}',
                            style: const TextStyle(
                              color: Colors.white38,
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
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white38,
                          size: 18,
                        ),
                      ),
                  ],
                ),
              ),
          const SizedBox(height: 20),
          const Text(
            'Audit Log (recent)',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_audits.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                'No audit entries',
                style: TextStyle(color: Colors.white38),
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
                        style: const TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: Text(
                        audit.action,
                        style: const TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        audit.extraInfo,
                        style: const TextStyle(
                          color: Colors.white70,
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
