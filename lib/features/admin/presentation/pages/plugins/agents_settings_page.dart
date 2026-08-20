import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/agent_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/agent_status_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/llm_service_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_config_data_source.dart';

class AgentsSettingsPage extends StatefulWidget {
  const AgentsSettingsPage({super.key});

  @override
  State<AgentsSettingsPage> createState() => _AgentsSettingsPageState();
}

class _AgentsSettingsPageState extends State<AgentsSettingsPage> {
  final AdminConfigRepository _configRepository =
      getIt<AdminConfigRepository>();
  final AdminConfigDataSource _dataSource = getIt<AdminConfigDataSource>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasUnsavedChanges = false;

  bool _enablePlugin = false;
  bool _enableCopilot = false;
  bool _enableAIForChannels = false;
  bool _enableSummarization = false;
  bool _enableTranslation = false;
  final TextEditingController _defaultModelController = TextEditingController();
  final TextEditingController _maxTokensController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();

  List<AgentEntity> _agents = [];
  List<AgentStatusEntity> _agentStatuses = [];
  List<LlmServiceEntity> _llmServices = [];

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _defaultModelController.dispose();
    _maxTokensController.dispose();
    _temperatureController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final results = await Future.wait([
        _configRepository.getConfig(),
        _dataSource.getAgents(),
        _dataSource.getAgentsStatus(),
        _dataSource.getLLMServices(),
      ]);

      final config = results[0] as Map<String, dynamic>;
      _agents = results[1] as List<AgentEntity>;
      _agentStatuses = results[2] as List<AgentStatusEntity>;
      _llmServices = results[3] as List<LlmServiceEntity>;

      final pluginSettings =
          (config['PluginSettings'] as Map<String, dynamic>?) ?? const {};
      final pluginStates =
          (pluginSettings['PluginStates'] as Map<String, dynamic>?) ?? const {};
      final agentsState =
          (pluginStates['mattermost-ai'] as Map<String, dynamic>?) ?? const {};
      _enablePlugin = agentsState['Enable'] == true;

      final plugins =
          (pluginSettings['Plugins'] as Map<String, dynamic>?) ?? const {};
      final agentsConfig =
          (plugins['mattermost-ai'] as Map<String, dynamic>?) ?? const {};
      _enableCopilot = agentsConfig['EnableCopilot'] == true;
      _enableAIForChannels = agentsConfig['EnableAIForChannels'] == true;
      _enableSummarization = agentsConfig['EnableSummarization'] == true;
      _enableTranslation = agentsConfig['EnableTranslation'] == true;
      _defaultModelController.text =
          (agentsConfig['DefaultModel'] as String?) ?? '';
      _maxTokensController.text =
          (agentsConfig['MaxTokens']?.toString()) ?? '2048';
      _temperatureController.text =
          (agentsConfig['Temperature']?.toString()) ?? '0.7';
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
            'mattermost-ai': {'Enable': _enablePlugin},
          },
          'Plugins': {
            'mattermost-ai': {
              'EnableCopilot': _enableCopilot,
              'EnableAIForChannels': _enableAIForChannels,
              'EnableSummarization': _enableSummarization,
              'EnableTranslation': _enableTranslation,
              'DefaultModel': _defaultModelController.text.trim(),
              'MaxTokens':
                  int.tryParse(_maxTokensController.text.trim()) ?? 2048,
              'Temperature':
                  double.tryParse(_temperatureController.text.trim()) ?? 0.7,
            },
          },
        },
      };
      await _configRepository.patchConfig(patch);
      if (mounted) {
        setState(() => _hasUnsavedChanges = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Agents settings saved successfully'),
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
              'AI Agents',
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
                        _buildEnablePluginSection(colors),
                        const SizedBox(height: 20),
                        _buildCopilotSection(colors),
                        const SizedBox(height: 20),
                        _buildLLMServicesSection(colors),
                        const SizedBox(height: 20),
                        _buildAgentsListSection(colors),
                        const SizedBox(height: 20),
                        _buildAdvancedSettingsSection(colors),
                      ],
                    ),
                  ),
                ),
                if (_hasUnsavedChanges) _buildSaveBar(colors),
              ],
            ),
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
              'When true, enables the Mattermost AI Agents plugin on your server. This plugin provides AI-powered copilot, summarization, translation, and custom agent capabilities.',
        ),
      ],
    );
  }

  Widget _buildCopilotSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableCopilot,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableCopilot = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Copilot',
          subtitle:
              'When true, enables the AI Copilot feature that provides intelligent chat assistance, post summarization, thread analysis, and content generation within channels.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableAIForChannels,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableAIForChannels = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable AI for Channels',
          subtitle:
              'When true, allows AI agents to be used within channel conversations. Users can mention AI agents to get intelligent responses and perform automated tasks.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableSummarization,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableSummarization = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Summarization',
          subtitle:
              'When true, enables AI-powered thread and channel summarization. Users can request summaries of long conversations or channel histories.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableTranslation,
          onChanged: _enablePlugin
              ? (v) {
                  if (v != null) {
                    setState(() => _enableTranslation = v);
                    _markChanged();
                  }
                }
              : null,
          title: 'Enable Translation',
          subtitle:
              'When true, enables AI-powered message translation. Users can translate messages to different languages using AI services.',
        ),
      ],
    );
  }

  Widget _buildLLMServicesSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'LLM Services',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Available LLM service integrations configured on your server.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        if (_llmServices.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.centerChannelBg.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No LLM services configured. Add LLM service providers in the plugin configuration.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ..._llmServices.map((service) {
            final isDefault = service.isDefault == true;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.centerChannelBg.withValues(alpha: 0.60),
                borderRadius: BorderRadius.circular(8),
                border: isDefault
                    ? Border.all(
                        color: colors.onlineIndicator.withValues(alpha: 0.40),
                      )
                    : null,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.memory,
                    color: isDefault ? colors.onlineIndicator : colors.buttonBg,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              service.display_name ?? service.name ?? 'Unknown',
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (isDefault) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.onlineIndicator.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Default',
                                  style: TextStyle(
                                    color: colors.onlineIndicator,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (service.description != null &&
                            service.description!.isNotEmpty)
                          Text(
                            service.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildAgentsListSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Registered Agents',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'AI agents registered on your Mattermost server.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        if (_agents.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.centerChannelBg.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: colors.centerChannelColor.withValues(alpha: 0.38),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No agents registered. Enable the plugin and configure LLM services to start using AI agents.',
                    style: TextStyle(
                      color: colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ..._agents.map((agent) {
            final status = _agentStatuses.firstWhere(
              (s) => s.agent_id == agent.agent_id,
              orElse: () => const AgentStatusEntity(),
            );
            final isRunning =
                status.status == 'online' || status.status == 'running';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.centerChannelBg.withValues(alpha: 0.60),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isRunning
                          ? colors.onlineIndicator
                          : colors.centerChannelColor.withValues(alpha: 0.38),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          agent.display_name ??
                              agent.name ??
                              agent.agent_id ??
                              'Unknown Agent',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (agent.description != null &&
                            agent.description!.isNotEmpty)
                          Text(
                            agent.description!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                  if (agent.type != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colors.buttonBg.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        agent.type!,
                        style: TextStyle(
                          color: colors.buttonBg,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Text(
                    isRunning ? 'Online' : (status.status ?? 'Unknown'),
                    style: TextStyle(
                      color: isRunning
                          ? colors.onlineIndicator
                          : colors.centerChannelColor.withValues(alpha: 0.54),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildAdvancedSettingsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        Text(
          'Advanced Settings',
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Configure model parameters and advanced options for AI agents.',
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _textTile(
          colors,
          controller: _defaultModelController,
          title: 'Default Model',
          subtitle:
              'The default LLM model to use for AI agent interactions when no specific model is selected.',
          placeholder: 'e.g. gpt-4, claude-3, llama-3',
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _maxTokensController,
          title: 'Max Tokens',
          subtitle:
              'The maximum number of tokens to generate in AI responses. Higher values allow longer responses but use more API credits.',
          placeholder: '2048',
          keyboardType: TextInputType.number,
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _temperatureController,
          title: 'Temperature',
          subtitle:
              'Controls randomness in AI responses. Lower values (0.0-0.3) make responses more focused and deterministic. Higher values (0.7-1.0) make responses more creative and varied.',
          placeholder: '0.7',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          enabled: _enablePlugin,
          onChanged: (_) => _markChanged(),
        ),
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
