import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class PlaybooksSettingsPage extends StatefulWidget {
  const PlaybooksSettingsPage({super.key});

  @override
  State<PlaybooksSettingsPage> createState() => _PlaybooksSettingsPageState();
}

class _PlaybooksSettingsPageState extends State<PlaybooksSettingsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  bool _enablePlugin = false;
  bool _enableWebhooks = false;
  bool _enableChannelActions = false;
  bool _enableRetrospectives = false;
  bool _enableMetrics = false;
  bool _enableGuestsAccess = false;
  bool _allowAllMembersToCreatePlaybooks = false;
  final TextEditingController _webhookTimeoutController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _webhookTimeoutController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final pluginSettings =
          (config['PluginSettings'] as Map<String, dynamic>?) ?? const {};
      final pluginStates =
          (pluginSettings['PluginStates'] as Map<String, dynamic>?) ?? const {};
      final playbooksState =
          (pluginStates['playbooks'] as Map<String, dynamic>?) ?? const {};
      _enablePlugin = playbooksState['Enable'] == true;

      final plugins =
          (pluginSettings['Plugins'] as Map<String, dynamic>?) ?? const {};
      final playbooksConfig =
          (plugins['playbooks'] as Map<String, dynamic>?) ?? const {};
      _enableWebhooks = playbooksConfig['EnableWebhooks'] == true;
      _enableChannelActions = playbooksConfig['EnableChannelActions'] == true;
      _enableRetrospectives = playbooksConfig['EnableRetrospectives'] == true;
      _enableMetrics = playbooksConfig['EnableMetrics'] == true;
      _enableGuestsAccess = playbooksConfig['EnableGuestsAccess'] == true;
      _allowAllMembersToCreatePlaybooks =
          playbooksConfig['AllowAllMembersToCreatePlaybooks'] == true;
      _webhookTimeoutController.text =
          (playbooksConfig['WebhookTimeout']?.toString()) ?? '30';
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfig() async {
    final colors = AppTheme.of(context);
    setState(() => _isSaving = true);
    try {
      final patch = {
        'PluginSettings': {
          'PluginStates': {
            'playbooks': {'Enable': _enablePlugin},
          },
          'Plugins': {
            'playbooks': {
              'EnableWebhooks': _enableWebhooks,
              'EnableChannelActions': _enableChannelActions,
              'EnableRetrospectives': _enableRetrospectives,
              'EnableMetrics': _enableMetrics,
              'EnableGuestsAccess': _enableGuestsAccess,
              'AllowAllMembersToCreatePlaybooks':
                  _allowAllMembersToCreatePlaybooks,
              'WebhookTimeout':
                  int.tryParse(_webhookTimeoutController.text.trim()) ?? 30,
            },
          },
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        setState(() => _hasUnsavedChanges = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Playbooks settings saved successfully'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: colors.errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _markChanged() {
    if (!_hasUnsavedChanges) setState(() => _hasUnsavedChanges = true);
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
              'Playbooks',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: colors.buttonBg))
          : Column(
              spacing: 24,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(colors),
                        const SizedBox(height: 24),
                        _buildEnablePluginSection(colors),
                        const SizedBox(height: 20),
                        _buildPlaybookFeaturesSection(colors),
                        const SizedBox(height: 20),
                        _buildPermissionsSection(colors),
                        const SizedBox(height: 20),
                        _buildWebhookSection(colors),
                      ],
                    ),
                  ),
                ),
                if (_hasUnsavedChanges) _buildSaveBar(colors),
              ],
            ),
    );
  }

  Widget _buildHeader(MattermostColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    color: colors.buttonBg,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Playbooks',
                    style: TextStyle(
                      color: colors.centerChannelColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Configure workflow automation, run tracking, and playbook management features for your Mattermost workspace.',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.54),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Plugin ID: playbooks',
                style: TextStyle(
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                  fontSize: 11,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        if (_hasUnsavedChanges)
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _saveConfig,
            icon: _isSaving
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.centerChannelColor,
                    ),
                  )
                : const Icon(Icons.save_rounded, size: 18),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.buttonBg,
              foregroundColor: colors.buttonColor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEnablePluginSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enablePlugin,
          onChanged: (v) {
            if (v != null) {
              setState(() => _enablePlugin = v);
              _markChanged();
            }
          },
          title: 'Enable Plugin',
          subtitle:
              'When true, enables the Mattermost Playbooks plugin. This provides workflow automation, run tracking, and structured incident response capabilities.',
        ),
      ],
    );
  }

  Widget _buildPlaybookFeaturesSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Playbook Features',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Configure which playbook features are available to your workspace.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _boolTile(
          colors,
          value: _enableChannelActions,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableChannelActions = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Channel Actions',
          subtitle:
              'When true, allows playbooks to automatically trigger actions when runs are started or completed in channels. This includes auto-adding members, sending messages, and updating channel headers.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableRetrospectives,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableRetrospectives = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Retrospectives',
          subtitle:
              'When true, enables retrospective reports at the end of playbook runs. Teams can analyze what went well and what needs improvement after each run.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableMetrics,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableMetrics = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Metrics and Statistics',
          subtitle:
              'When true, enables tracking of playbook run metrics and statistics. Provides insights into run duration, task completion rates, and team performance.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableGuestsAccess,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableGuestsAccess = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Guest Access to Playbooks',
          subtitle:
              'When true, allows guest users to participate in playbook runs. Guests can be added as run members and perform assigned tasks.',
        ),
      ],
    );
  }

  Widget _buildPermissionsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Permissions',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Control who can create and manage playbooks in your workspace.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _boolTile(
          colors,
          value: _allowAllMembersToCreatePlaybooks,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _allowAllMembersToCreatePlaybooks = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Allow All Members to Create Playbooks',
          subtitle:
              'When true, all team members can create playbooks. When false, only team and system admins can create new playbooks. Existing playbooks can always be edited by their owners.',
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.centerChannelBg.withValues(alpha: 0.60),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Permission Groups (System Console)',
                style: TextStyle(
                  color: colors.centerChannelColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _permissionRow(
                colors,
                'Manage Public Playbooks',
                'Create, edit, and delete public playbooks',
              ),
              _permissionRow(
                colors,
                'Manage Private Playbooks',
                'Create, edit, and delete private playbooks',
              ),
              _permissionRow(
                colors,
                'Make Public/Private',
                'Change playbook visibility between public and private',
              ),
              _permissionRow(
                colors,
                'Manage Runs',
                'Start, update, and complete playbook runs',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _permissionRow(
    MattermostColors colors,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: colors.onlineIndicator,
            size: 14,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: colors.centerChannelColor.withValues(alpha: 0.54),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebhookSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Webhooks & Integrations',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Configure webhook integration settings for playbook runs.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _boolTile(
          colors,
          value: _enableWebhooks,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableWebhooks = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Webhooks',
          subtitle:
              'When true, allows playbook runs to send and receive webhook events. This enables integration with external systems for automated workflows.',
        ),
        if (_enableWebhooks) ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _webhookTimeoutController,
            title: 'Webhook Timeout (seconds)',
            subtitle:
                'The maximum time in seconds to wait for a webhook response before timing out. Increase this value if your webhook endpoints are slow to respond.',
            placeholder: '30',
            keyboardType: TextInputType.number,
            enabled: _enablePlugin,
            onChanged: (_) => _markChanged(),
          ),
        ],
      ],
    );
  }

  Widget _buildSaveBar(MattermostColors colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: colors.mentionHighlightBg,
        border: Border(
          top: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.linkColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'You have unsaved changes',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          OutlinedButton(
            onPressed: _isSaving
                ? null
                : () {
                    setState(() => _hasUnsavedChanges = false);
                    _loadConfig();
                  },
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: colors.centerChannelColor.withValues(alpha: 0.24),
              ),
              foregroundColor: colors.buttonColor.withValues(alpha: 0.70),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: _isSaving ? null : _saveConfig,
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
            icon: _isSaving
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: colors.buttonColor,
                    ),
                  )
                : Icon(
                    Icons.save_outlined,
                    size: 16,
                    color: colors.buttonColor,
                  ),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(
    MattermostColors colors, {
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _divider(MattermostColors colors) {
    return Divider(
      color: colors.centerChannelColor.withValues(alpha: 0.10),
      height: 24,
    );
  }

  Widget _boolTile(
    MattermostColors colors, {
    required bool value,
    ValueChanged<bool?>? onChanged,
    required String title,
    required String subtitle,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colors.buttonBg,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          color: colors.centerChannelColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: colors.centerChannelColor.withValues(alpha: 0.54),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _textTile(
    MattermostColors colors, {
    required TextEditingController controller,
    required String title,
    required String subtitle,
    String? placeholder,
    TextInputType? keyboardType,
    bool enabled = true,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          onChanged: onChanged,
          style: TextStyle(
            color: enabled
                ? colors.centerChannelColor
                : colors.centerChannelColor.withValues(alpha: 0.38),
            fontSize: 13,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.38),
              fontSize: 13,
            ),
            filled: true,
            fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
