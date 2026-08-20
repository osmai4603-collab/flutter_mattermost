import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/admin_setting_schema.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_widget_factory.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

/// Custom Terms of Service page – mirrors Mattermost CustomTermsOfServiceSettings.
class AdminConsoleCustomTermsOfServicePage extends StatefulWidget {
  const AdminConsoleCustomTermsOfServicePage({super.key});

  @override
  State<AdminConsoleCustomTermsOfServicePage> createState() =>
      _AdminConsoleCustomTermsOfServicePageState();
}

class _AdminConsoleCustomTermsOfServicePageState
    extends State<AdminConsoleCustomTermsOfServicePage> {
  final AdminConfigRepository _configRepo = getIt<AdminConfigRepository>();
  final AuthRemoteDataSource _authDataSource = getIt<AuthRemoteDataSource>();

  Map<String, dynamic> _config = {};
  final Map<String, dynamic> _pendingChanges = {};
  bool _loading = true;
  bool _saving = false;
  String? _error;
  String _tosText = '';
  bool _tosTextDirty = false;

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
        _configRepo.getConfig(),
        _authDataSource.getTermsOfService(),
      ]);
      if (!mounted) return;
      setState(() {
        _config = results[0] as Map<String, dynamic>;
        _tosText = results[1].text ?? '';
        _pendingChanges.clear();
        _tosTextDirty = false;
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
    if (_pendingChanges.isEmpty && !_tosTextDirty) return;
    final colors = AppTheme.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      // Create/update the Terms of Service text if changed
      if (_tosTextDirty && _tosText.trim().isNotEmpty) {
        await _authDataSource.createTermsOfService(_tosText);
      }

      // Patch the config settings
      if (_pendingChanges.isNotEmpty) {
        final patch = <String, dynamic>{};
        _pendingChanges.forEach((key, val) {
          final parts = key.split('.');
          if (parts.length == 2) {
            patch.putIfAbsent(parts[0], () => <String, dynamic>{});
            (patch[parts[0]] as Map<String, dynamic>)[parts[1]] = val;
          }
        });
        await _configRepo.patchConfig(patch);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Custom Terms of Service settings saved'),
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
              'Custom Terms of Service',
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
                      'Error loading terms of service settings: $_error',
                      style: TextStyle(
                        color: colors.errorTextColor,
                        fontSize: 13,
                      ),
                    ),
                  )
                : _buildContent(context),
          ),
          if (_pendingChanges.isNotEmpty || _tosTextDirty)
            SaveChangesPanel(
              isSaving: _saving,
              onSave: _save,
              onCancel: () => setState(() {
                _pendingChanges.clear();
                _tosTextDirty = false;
              }),
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
          AdminSettingSection(
            title: 'Custom Terms of Service',
            subtitle:
                'Configure custom terms of service that users must accept before accessing the platform.',
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

          // Terms of Service Text (custom textarea)
          AdminSettingSection(
            title: 'Terms of Service Text',
            subtitle:
                'The text that users must accept. Supports Markdown. Max 16,383 characters.',
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Terms of Service Text',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'The text content for your custom terms of service. Supports Markdown formatting.',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.54,
                              ),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 380),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            initialValue: _tosText,
                            maxLines: 12,
                            enabled: !_saving,
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                            onChanged: (v) {
                              setState(() {
                                _tosText = v;
                                _tosTextDirty = true;
                              });
                            },
                            decoration: InputDecoration(
                              hintText:
                                  '# Terms of Service\n\nEnter your custom terms here...',
                              hintStyle: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.38,
                                ),
                                fontSize: 12,
                              ),
                              filled: true,
                              fillColor: colors.mentionHighlightBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: colors.centerChannelColor.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: colors.centerChannelColor.withValues(
                                    alpha: 0.12,
                                  ),
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(12),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_tosText.length} / 16383 characters',
                            style: TextStyle(
                              color: _tosText.length > 16383
                                  ? colors.errorTextColor
                                  : colors.centerChannelColor.withValues(
                                      alpha: 0.38,
                                    ),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Preview section
          if (_tosText.trim().isNotEmpty)
            AdminSettingSection(
              title: 'Preview',
              subtitle: 'How the terms of service will appear to users.',
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.centerChannelBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Text(
                    _tosText,
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.70),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  static const _settingsSchemas = [
    AdminSettingFieldSchema(
      key: 'SupportSettings.CustomTermsOfServiceEnabled',
      type: AdminSettingType.boolSetting,
      label: 'Enable Custom Terms of Service',
      helpText:
          'When enabled, new users must accept the terms of service before accessing teams. Existing users must accept after login or browser refresh.',
    ),
    AdminSettingFieldSchema(
      key: 'SupportSettings.CustomTermsOfServiceReAcceptancePeriod',
      type: AdminSettingType.numberSetting,
      label: 'Re-Acceptance Period (days)',
      helpText:
          'The number of days before users are required to re-accept the terms of service. Set to 0 to require acceptance only once.',
    ),
  ];
}
