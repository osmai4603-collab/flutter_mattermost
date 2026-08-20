import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/admin_setting_schema.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_widget_factory.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

/// Audit Logging page – mirrors Mattermost ExperimentalAuditSettings.
class AdminConsoleAuditLoggingPage extends StatefulWidget {
  const AdminConsoleAuditLoggingPage({super.key});

  @override
  State<AdminConsoleAuditLoggingPage> createState() =>
      _AdminConsoleAuditLoggingPageState();
}

class _AdminConsoleAuditLoggingPageState
    extends State<AdminConsoleAuditLoggingPage> {
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
            content: const Text('Audit Logging settings saved'),
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
              'Audit Logging',
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
                      'Error loading audit logging settings: $_error',
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
          // Restart warning banner
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.linkColor.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.linkColor.withValues(alpha: 0.30),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: colors.linkColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Changing properties in this section will require a server restart before taking effect.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // File audit logging settings
          AdminSettingSection(
            title: 'File Audit Logging',
            subtitle:
                'Configure audit log file output. Audit logs capture detailed information about user activity and system events.',
            children: _fileSettingsSchemas.map((fieldSchema) {
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

          // Advanced logging JSON
          AdminSettingSection(
            title: 'Advanced Audit Logging',
            subtitle:
                'JSON configuration for advanced audit logging. Requires valid JSON.',
            children: _advancedSchemas.map((fieldSchema) {
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

  static const _fileSettingsSchemas = [
    AdminSettingFieldSchema(
      key: 'ExperimentalAuditSettings.FileEnabled',
      type: AdminSettingType.boolSetting,
      label: 'File Enabled',
      helpText:
          'When enabled, audit logs are written locally to a file. Disable to stop writing audit logs to file.',
    ),
    AdminSettingFieldSchema(
      key: 'ExperimentalAuditSettings.FileName',
      type: AdminSettingType.textSetting,
      label: 'File Name',
      placeholder: 'audit.log',
      helpText:
          'The name of the file to write audit logs to. Disabled when File Enabled is false.',
    ),
  ];

  static const _advancedSchemas = [
    AdminSettingFieldSchema(
      key: 'ExperimentalAuditSettings.AdvancedLoggingJSON',
      type: AdminSettingType.textSetting,
      label: 'Advanced Logging (JSON)',
      placeholder: '{"loglevel": "INFO", "backends": [...]}',
      helpText:
          'Advanced Audit Logging JSON configuration. Defines custom logging targets, formats, and filters. Must be valid JSON.',
    ),
  ];
}
