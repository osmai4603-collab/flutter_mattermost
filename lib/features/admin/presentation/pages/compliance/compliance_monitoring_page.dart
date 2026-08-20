import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/admin_setting_schema.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/audit_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/compliance_report_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_compliance_repository.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_widget_factory.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

/// Compliance Monitoring page – mirrors Mattermost Audits + ComplianceReports.
class AdminConsoleComplianceMonitoringPage extends StatefulWidget {
  const AdminConsoleComplianceMonitoringPage({super.key});

  @override
  State<AdminConsoleComplianceMonitoringPage> createState() =>
      _AdminConsoleComplianceMonitoringPageState();
}

class _AdminConsoleComplianceMonitoringPageState
    extends State<AdminConsoleComplianceMonitoringPage> {
  final AdminConfigRepository _configRepo = getIt<AdminConfigRepository>();
  final AdminComplianceRepository _complianceRepo =
      getIt<AdminComplianceRepository>();

  Map<String, dynamic> _config = {};
  final Map<String, dynamic> _pendingChanges = {};
  List<ComplianceReportEntity> _reports = [];
  List<AuditEntity> _audits = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  // Form controllers for creating a new compliance report
  final _descCtrl = TextEditingController();
  final _fromCtrl = TextEditingController();
  final _toCtrl = TextEditingController();
  final _emailsCtrl = TextEditingController();
  final _keywordsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _emailsCtrl.dispose();
    _keywordsCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        _configRepo.getConfig(),
        _complianceRepo.getComplianceReports(),
        _complianceRepo.getAudits(perPage: 100),
      ]);
      if (!mounted) return;
      setState(() {
        _config = results[0] as Map<String, dynamic>;
        _reports = results[1] as List<ComplianceReportEntity>;
        _audits = results[2] as List<AuditEntity>;
        _pendingChanges.clear();
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onSettingChanged(String key, dynamic value) {
    setState(() => _pendingChanges[key] = value);
  }

  Future<void> _save() async {
    if (_pendingChanges.isEmpty) return;
    final colors = AppTheme.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final patch = <String, dynamic>{};
      _pendingChanges.forEach((key, val) {
        final parts = key.split('.');
        if (parts.length == 2) {
          patch.putIfAbsent(parts[0], () => <String, dynamic>{});
          (patch[parts[0]] as Map<String, dynamic>)[parts[1]] = val;
        }
      });
      await _configRepo.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Compliance Monitoring settings saved'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
        _load();
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _runReport() async {
    final colors = AppTheme.of(context);
    if (_descCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a job name'),
          backgroundColor: colors.awayIndicator,
        ),
      );
      return;
    }
    try {
      await _complianceRepo.createComplianceReport(
        jobName: _descCtrl.text.trim(),
        reportType: ComplianceReportType.adhoc,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compliance report job created')),
      );
      _descCtrl.clear();
      _fromCtrl.clear();
      _toCtrl.clear();
      _emailsCtrl.clear();
      _keywordsCtrl.clear();
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
              'Compliance Monitoring',
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
                ? Center(
                    child: Text(
                      'Error loading compliance monitoring: $_error',
                      style: TextStyle(
                        color: colors.errorTextColor,
                        fontSize: 13,
                      ),
                    ),
                  )
                : _buildContent(context),
          ),
          if (_pendingChanges.isNotEmpty)
            SaveChangesPanel(
              isSaving: _saving,
              onSave: _save,
              onCancel: () => setState(() => _pendingChanges.clear()),
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
          // Deprecation banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.awayIndicator.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.awayIndicator.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.awayIndicator, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'This feature is replaced by a new Compliance Export feature. Please see the Compliance Export tab for the new functionality.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Settings section
          AdminSettingSection(
            title: 'Compliance Reporting',
            subtitle: 'Configure compliance report generation settings.',
            children: _settingsSchemas.map((fieldSchema) {
              final parts = fieldSchema.key.split('.');
              dynamic currentVal;
              if (parts.length == 2) {
                final sectionData = _config[parts[0]] as Map<String, dynamic>?;
                currentVal =
                    _pendingChanges[fieldSchema.key] ?? sectionData?[parts[1]];
              }
              return AdminWidgetFactory(
                schema: fieldSchema,
                currentValue: currentVal,
                isDisabled: _saving,
                onChanged: _onSettingChanged,
              );
            }).toList(),
          ),

          const SizedBox(height: 8),

          // Run Report Form
          AdminSettingSection(
            title: 'Run a Compliance Report',
            subtitle:
                'Create an ad-hoc compliance report for a specific time range.',
            children: [
              _buildTextField('Job Name', _descCtrl, 'e.g. Audit 445 for HR'),
              _buildTextField('From', _fromCtrl, 'e.g. 2024-01-01'),
              _buildTextField('To', _toCtrl, 'e.g. 2024-01-15'),
              _buildTextField(
                'Emails',
                _emailsCtrl,
                'e.g. bill@example.com, bob@example.com',
              ),
              _buildTextField('Keywords', _keywordsCtrl, 'e.g. shorting stock'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: _runReport,
                  style: FilledButton.styleFrom(
                    backgroundColor: colors.buttonBg,
                  ),
                  icon: const Icon(Icons.play_arrow_outlined, size: 16),
                  label: const Text('Run Report'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Existing Reports Table
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
            _buildReportsTable(),

          const SizedBox(height: 20),

          // Audit Log section
          Text(
            'User Activity Logs',
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
            _buildAuditTable(),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl,
    String placeholder,
  ) {
    final colors = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: TextFormField(
                controller: ctrl,
                style: TextStyle(
                  color: colors.centerChannelColor,
                  fontSize: 13,
                ),
                decoration: InputDecoration(
                  hintText: placeholder,
                  hintStyle: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.38),
                    fontSize: 12,
                  ),
                  filled: true,
                  fillColor: colors.mentionHighlightBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportsTable() {
    final colors = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(
            colors.centerChannelColor.withValues(alpha: 0.06),
          ),
          columns: [
            _headerCell('Status'),
            _headerCell('Timestamp'),
            _headerCell('Records'),
            _headerCell('Type'),
            _headerCell('Description'),
            _headerCell('Params'),
          ],
          rows: _reports.map((report) {
            final statusColor = report.status.value == 'success'
                ? colors.onlineIndicator
                : report.status.value == 'pending'
                ? colors.awayIndicator
                : colors.errorTextColor;
            final statusIcon = report.status.value == 'success'
                ? Icons.check_circle_outline
                : report.status.value == 'pending'
                ? Icons.pending_outlined
                : Icons.error_outline;
            return DataRow(
              cells: [
                DataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        report.status.value,
                        style: TextStyle(color: statusColor, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                DataCell(
                  Text(
                    report.createAtDate?.toString().split('.').first ?? '—',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    '${report.count}',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    report.type.value,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    report.desc,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    _reportParams(report),
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _reportParams(ComplianceReportEntity report) {
    final parts = <String>[];
    if (report.emails.isNotEmpty) {
      parts.add('emails: ${report.emails}');
    }
    if (report.keywords.isNotEmpty) {
      parts.add('keywords: ${report.keywords}');
    }
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  Widget _buildAuditTable() {
    final colors = AppTheme.of(context);
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(
            colors.centerChannelColor.withValues(alpha: 0.06),
          ),
          columns: [
            _headerCell('Timestamp'),
            _headerCell('User ID'),
            _headerCell('Action'),
            _headerCell('Extra Info'),
          ],
          rows: _audits.take(100).map((audit) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    audit.createAtDate?.toString().split('.').first ?? '—',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.38),
                      fontSize: 11,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    audit.userId,
                    style: TextStyle(color: colors.buttonBg, fontSize: 12),
                  ),
                ),
                DataCell(
                  Text(
                    audit.action,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 12,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    audit.extraInfo,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  DataColumn _headerCell(String label) {
    final colors = AppTheme.of(context);
    return DataColumn(
      label: Text(
        label,
        style: TextStyle(
          color: colors.centerChannelColor.withValues(alpha: 0.54),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static const _settingsSchemas = [
    AdminSettingFieldSchema(
      key: 'ComplianceSettings.Enable',
      type: AdminSettingType.boolSetting,
      label: 'Enable Compliance Reporting',
      helpText:
          'When enabled, allows compliance reporting from the Compliance and Auditing tab.',
    ),
    AdminSettingFieldSchema(
      key: 'ComplianceSettings.Directory',
      type: AdminSettingType.textSetting,
      label: 'Compliance Report Directory',
      placeholder: './data/',
      helpText:
          'Directory to which compliance reports are written. Default is ./data/.',
    ),
    AdminSettingFieldSchema(
      key: 'ComplianceSettings.EnableDaily',
      type: AdminSettingType.boolSetting,
      label: 'Enable Daily Report',
      helpText:
          'When enabled, Mattermost will generate a daily compliance report.',
    ),
  ];
}
