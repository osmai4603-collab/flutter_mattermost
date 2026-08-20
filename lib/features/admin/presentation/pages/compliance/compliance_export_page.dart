import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/admin_setting_schema.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_widget_factory.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

/// Compliance Export page – mirrors Mattermost MessageExportSettings.
class AdminConsoleComplianceExportPage extends StatefulWidget {
  const AdminConsoleComplianceExportPage({super.key});

  @override
  State<AdminConsoleComplianceExportPage> createState() =>
      _AdminConsoleComplianceExportPageState();
}

class _AdminConsoleComplianceExportPageState
    extends State<AdminConsoleComplianceExportPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  Map<String, dynamic> _config = {};
  final Map<String, dynamic> _pendingChanges = {};
  bool _loading = true;
  bool _saving = false;
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
      final config = await _repository.getConfig();
      if (!mounted) return;
      setState(() {
        _config = config;
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
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Compliance Export settings saved'),
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
              'Compliance Export',
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
                      'Error loading settings: $_error',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSettingSection(
            title: 'Compliance Export',
            subtitle:
                'Configure compliance exports for third-party integration tools.',
            children: _schemas.map((fieldSchema) {
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
        ],
      ),
    );
  }

  static const _schemas = [
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.EnableExport',
      type: AdminSettingType.boolSetting,
      label: 'Enable Compliance Export',
      helpText:
          'When enabled, Mattermost will export all messages posted in the last 24 hours. Export task runs daily at the specified time.',
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.DailyRunTime',
      type: AdminSettingType.textSetting,
      label: 'Compliance Export Time',
      placeholder: '02:00',
      helpText:
          'Start time of daily scheduled compliance export job (UTC, 24-hour format HH:MM).',
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.ExportFormat',
      type: AdminSettingType.dropdownSetting,
      label: 'Export Format',
      helpText:
          'The format to use for compliance exports. Global Relay uses email-based exports.',
      options: [
        AdminSettingOptionSchema(
          value: 'actiance',
          displayName: 'Actiance XML',
        ),
        AdminSettingOptionSchema(value: 'csv', displayName: 'CSV'),
        AdminSettingOptionSchema(
          value: 'globalrelay',
          displayName: 'Global Relay EML',
        ),
      ],
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.GlobalRelaySettings.CustomerType',
      type: AdminSettingType.radioSetting,
      label: 'Customer Type',
      helpText:
          'Select the Global Relay customer type. Only visible when export format is Global Relay.',
      options: [
        AdminSettingOptionSchema(value: 'A9', displayName: 'A9/Type 9'),
        AdminSettingOptionSchema(value: 'A10', displayName: 'A10/Type 10'),
        AdminSettingOptionSchema(value: 'CUSTOM', displayName: 'Custom'),
      ],
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.GlobalRelaySettings.SMTPUsername',
      type: AdminSettingType.textSetting,
      label: 'SMTP Username',
      helpText: 'Username for GlobalRelay SMTP authentication.',
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.GlobalRelaySettings.SMTPPassword',
      type: AdminSettingType.textSetting,
      label: 'SMTP Password',
      helpText: 'Password for GlobalRelay SMTP authentication.',
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.GlobalRelaySettings.EmailAddress',
      type: AdminSettingType.textSetting,
      label: 'Email Address',
      placeholder: 'user@globalrelay.com',
      helpText:
          'Email address that the Global Relay server monitors for exports.',
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.GlobalRelaySettings.CustomSMTPServerName',
      type: AdminSettingType.textSetting,
      label: 'SMTP Server Name',
      helpText:
          'Custom SMTP server name. Only shown when customer type is Custom.',
    ),
    AdminSettingFieldSchema(
      key: 'MessageExportSettings.GlobalRelaySettings.CustomSMTPPort',
      type: AdminSettingType.numberSetting,
      label: 'SMTP Server Port',
      helpText:
          'Custom SMTP server port. Only shown when customer type is Custom.',
    ),
  ];
}
