import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/admin_setting_schema.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/resource_keys.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_widget_factory.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

class AdminConsoleEnvironmentSettingsPage extends StatefulWidget {
  final String subTab; // 'web_server', 'database', 'file_storage', 'smtp', 'push'

  const AdminConsoleEnvironmentSettingsPage({
    super.key,
    this.subTab = 'web_server',
  });

  @override
  State<AdminConsoleEnvironmentSettingsPage> createState() =>
      _AdminConsoleEnvironmentSettingsPageState();
}

class _AdminConsoleEnvironmentSettingsPageState
    extends State<AdminConsoleEnvironmentSettingsPage> {
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
    setState(() {
      _pendingChanges[key] = value;
    });
  }

  Future<void> _save() async {
    if (_pendingChanges.isEmpty) return;

    setState(() {
      _saving = true;
      _error = null;
    });

    try {
      final patch = <String, dynamic>{};
      _pendingChanges.forEach((key, val) {
        final parts = key.split('.');
        if (parts.length == 2) {
          final section = parts[0];
          final field = parts[1];
          patch.putIfAbsent(section, () => <String, dynamic>{});
          (patch[section] as Map<String, dynamic>)[field] = val;
        }
      });

      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Environment settings saved'),
            backgroundColor: Colors.green.shade700,
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
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: Colors.blueAccent))
              : _error != null
                  ? Center(child: Text('Error loading environment settings: $_error', style: const TextStyle(color: Colors.redAccent)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _buildSchemasForSubTab().map((subSection) {
                          return AdminSettingSection(
                            title: subSection.name,
                            children: subSection.settings.map((fieldSchema) {
                              final parts = fieldSchema.key.split('.');
                              dynamic currentVal;
                              if (parts.length == 2) {
                                final sectionData = _config[parts[0]] as Map<String, dynamic>?;
                                currentVal = _pendingChanges[fieldSchema.key] ?? sectionData?[parts[1]];
                              }
                              return AdminWidgetFactory(
                                schema: fieldSchema,
                                currentValue: currentVal,
                                isDisabled: _saving,
                                onChanged: _onSettingChanged,
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
        ),
        if (_pendingChanges.isNotEmpty)
          SaveChangesPanel(
            isSaving: _saving,
            onSave: _save,
            onCancel: () => setState(() => _pendingChanges.clear()),
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
      child: Row(
        children: [
          const Icon(Icons.dns_outlined, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 10),
          Text(
            _getHeaderTitle(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (widget.subTab) {
      case 'database':
        return 'Database Settings';
      case 'file_storage':
        return 'File Storage Settings';
      case 'smtp':
        return 'SMTP / Email Server';
      case 'push':
        return 'Push Notifications';
      default:
        return 'Web Server Settings';
    }
  }

  List<AdminSubSectionSchema> _buildSchemasForSubTab() {
    switch (widget.subTab) {
      case 'database':
        return [
          const AdminSubSectionSchema(
            id: 'DatabaseSettings',
            name: 'Database Configuration',
            resourceKey: ResourceKeys.database,
            settings: [
              AdminSettingFieldSchema(
                key: 'SqlSettings.DriverName',
                type: AdminSettingType.textSetting,
                label: 'Driver Name',
                helpText: 'Database driver: postgres or mysql.',
              ),
              AdminSettingFieldSchema(
                key: 'SqlSettings.MaxOpenConns',
                type: AdminSettingType.numberSetting,
                label: 'Maximum Open Connections',
                helpText: 'Maximum number of open connections to the database.',
              ),
              AdminSettingFieldSchema(
                key: 'SqlSettings.MaxIdleConns',
                type: AdminSettingType.numberSetting,
                label: 'Maximum Idle Connections',
                helpText: 'Maximum number of idle connections to keep in pool.',
              ),
              AdminSettingFieldSchema(
                key: 'SqlSettings.Trace',
                type: AdminSettingType.boolSetting,
                label: 'Enable Trace',
                helpText: 'Executes SQL statements with tracing for debugging.',
              ),
            ],
          ),
        ];

      case 'file_storage':
        return [
          const AdminSubSectionSchema(
            id: 'FileSettings',
            name: 'File Storage Configuration',
            resourceKey: ResourceKeys.fileStorage,
            settings: [
              AdminSettingFieldSchema(
                key: 'FileSettings.DriverName',
                type: AdminSettingType.dropdownSetting,
                label: 'Storage Driver',
                helpText: 'Location where uploaded files are stored.',
                options: [
                  AdminSettingOptionSchema(value: 'local', displayName: 'Local File System'),
                  AdminSettingOptionSchema(value: 'amazons3', displayName: 'Amazon S3'),
                ],
              ),
              AdminSettingFieldSchema(
                key: 'FileSettings.Directory',
                type: AdminSettingType.textSetting,
                label: 'Local Storage Directory',
                helpText: 'Directory where files are saved on local disk.',
              ),
              AdminSettingFieldSchema(
                key: 'FileSettings.MaxFileSize',
                type: AdminSettingType.numberSetting,
                label: 'Maximum File Size (MB)',
                helpText: 'Maximum file size in MB for uploads.',
              ),
            ],
          ),
        ];

      case 'smtp':
        return [
          const AdminSubSectionSchema(
            id: 'EmailSettings',
            name: 'SMTP Configuration',
            resourceKey: ResourceKeys.smtp,
            settings: [
              AdminSettingFieldSchema(
                key: 'EmailSettings.EnableEmailBatching',
                type: AdminSettingType.boolSetting,
                label: 'Enable Email Batching',
                helpText: 'Batches multiple notifications into single digest email.',
              ),
              AdminSettingFieldSchema(
                key: 'EmailSettings.SMTPServer',
                type: AdminSettingType.textSetting,
                label: 'SMTP Server',
                placeholder: 'smtp.example.com',
                helpText: 'Hostname of SMTP server.',
              ),
              AdminSettingFieldSchema(
                key: 'EmailSettings.SMTPPort',
                type: AdminSettingType.textSetting,
                label: 'SMTP Port',
                placeholder: '587',
                helpText: 'Port of SMTP server.',
              ),
              AdminSettingFieldSchema(
                key: 'EmailSettings.EnableSMTPAuth',
                type: AdminSettingType.boolSetting,
                label: 'Enable SMTP Authentication',
              ),
              AdminSettingFieldSchema(
                key: 'EmailSettings.FeedbackEmail',
                type: AdminSettingType.textSetting,
                label: 'Notification From Address',
                placeholder: 'mattermost@example.com',
              ),
            ],
          ),
        ];

      default:
        return [
          const AdminSubSectionSchema(
            id: 'ServiceSettings',
            name: 'Web Server Settings',
            resourceKey: ResourceKeys.webServer,
            settings: [
              AdminSettingFieldSchema(
                key: 'ServiceSettings.SiteURL',
                type: AdminSettingType.textSetting,
                label: 'Site URL',
                placeholder: 'https://mattermost.example.com',
                helpText: 'The main URL of your Mattermost deployment.',
              ),
              AdminSettingFieldSchema(
                key: 'ServiceSettings.ListenAddress',
                type: AdminSettingType.textSetting,
                label: 'Listen Address',
                placeholder: ':8065',
                helpText: 'The network address and port to listen on.',
              ),
              AdminSettingFieldSchema(
                key: 'ServiceSettings.WebserverMode',
                type: AdminSettingType.dropdownSetting,
                label: 'Webserver Mode',
                options: [
                  AdminSettingOptionSchema(value: 'gzip', displayName: 'Gzip'),
                  AdminSettingOptionSchema(value: 'disabled', displayName: 'Disabled'),
                ],
              ),
              AdminSettingFieldSchema(
                key: 'ServiceSettings.EnableInsecureOutgoingConnections',
                type: AdminSettingType.boolSetting,
                label: 'Enable Insecure Outgoing Connections',
                helpText: 'Allows outgoing HTTP requests without TLS validation.',
              ),
            ],
          ),
        ];
    }
  }
}
