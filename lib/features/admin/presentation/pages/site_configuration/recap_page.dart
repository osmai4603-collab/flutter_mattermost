import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class RecapPage extends StatefulWidget {
  const RecapPage({super.key});

  @override
  State<RecapPage> createState() => _RecapPageState();
}

class _RecapPageState extends State<RecapPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableRecap = false;

  // Quota Limits
  final TextEditingController _maxScheduledRecapsController =
      TextEditingController();
  final TextEditingController _maxRecapsPerDayController =
      TextEditingController();
  final TextEditingController _maxPostsPerDayController =
      TextEditingController();

  // Content Limits
  final TextEditingController _maxChannelsPerRecapController =
      TextEditingController();
  final TextEditingController _maxPostsPerRecapController =
      TextEditingController();
  final TextEditingController _maxTokensPerRecapController =
      TextEditingController();

  // Time Limits
  final TextEditingController _cooldownMinutesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _maxScheduledRecapsController.dispose();
    _maxRecapsPerDayController.dispose();
    _maxPostsPerDayController.dispose();
    _maxChannelsPerRecapController.dispose();
    _maxPostsPerRecapController.dispose();
    _maxTokensPerRecapController.dispose();
    _cooldownMinutesController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final recapSettings =
          (config['AIRecapSettings'] as Map<String, dynamic>?) ?? const {};
      final defaultLimits =
          (recapSettings['DefaultLimits'] as Map<String, dynamic>?) ?? const {};

      _enableRecap = recapSettings['Enable'] == true;
      _maxScheduledRecapsController.text =
          (defaultLimits['MaxScheduledRecaps']?.toString()) ?? '';
      _maxRecapsPerDayController.text =
          (defaultLimits['MaxRecapsPerDay']?.toString()) ?? '';
      _maxPostsPerDayController.text =
          (defaultLimits['MaxPostsPerDay']?.toString()) ?? '';
      _maxChannelsPerRecapController.text =
          (defaultLimits['MaxChannelsPerRecap']?.toString()) ?? '';
      _maxPostsPerRecapController.text =
          (defaultLimits['MaxPostsPerRecap']?.toString()) ?? '';
      _maxTokensPerRecapController.text =
          (defaultLimits['MaxTokensPerRecap']?.toString()) ?? '';
      _cooldownMinutesController.text =
          (defaultLimits['CooldownMinutes']?.toString()) ?? '';
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
        'AIRecapSettings': {
          'Enable': _enableRecap,
          'DefaultLimits': {
            'MaxScheduledRecaps':
                int.tryParse(_maxScheduledRecapsController.text.trim()) ?? 0,
            'MaxRecapsPerDay':
                int.tryParse(_maxRecapsPerDayController.text.trim()) ?? 0,
            'MaxPostsPerDay':
                int.tryParse(_maxPostsPerDayController.text.trim()) ?? 0,
            'MaxChannelsPerRecap':
                int.tryParse(_maxChannelsPerRecapController.text.trim()) ?? 0,
            'MaxPostsPerRecap':
                int.tryParse(_maxPostsPerRecapController.text.trim()) ?? 0,
            'MaxTokensPerRecap':
                int.tryParse(_maxTokensPerRecapController.text.trim()) ?? 0,
            'CooldownMinutes':
                int.tryParse(_cooldownMinutesController.text.trim()) ?? 0,
          },
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Recap settings saved'),
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
              'Recap',
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
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  _buildGeneralSection(colors),
                  const SizedBox(height: 20),
                  _buildSectionTitle(colors, 'Quota Limits'),
                  _buildQuotaSection(colors),
                  const SizedBox(height: 20),
                  _buildSectionTitle(colors, 'Content Limits'),
                  _buildContentSection(colors),
                  const SizedBox(height: 20),
                  _buildSectionTitle(colors, 'Time Limits'),
                  _buildTimeSection(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(MattermostColors colors, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: colors.centerChannelColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildGeneralSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableRecap,
          onChanged: (v) {
            if (v != null) setState(() => _enableRecap = v);
          },
          title: 'Enable AI Recaps',
          subtitle:
              'When true, AI-powered channel recaps are enabled for users. This allows users to get summaries of channel activity.',
        ),
      ],
    );
  }

  Widget _buildQuotaSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _maxScheduledRecapsController,
          title: 'Maximum Scheduled Recaps',
          subtitle:
              'Maximum number of recaps a user can schedule. Set to 0 for unlimited.',
          placeholder: '0',
          keyboardType: TextInputType.number,
          enabled: _enableRecap,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _maxRecapsPerDayController,
          title: 'Maximum Recaps Per Day',
          subtitle:
              'Maximum number of recaps a user can request per day. Set to 0 for unlimited.',
          placeholder: '0',
          keyboardType: TextInputType.number,
          enabled: _enableRecap,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _maxPostsPerDayController,
          title: 'Maximum Posts Per Day',
          subtitle:
              'Maximum number of posts included in recaps per day. Set to 0 for unlimited.',
          placeholder: '0',
          keyboardType: TextInputType.number,
          enabled: _enableRecap,
        ),
      ],
    );
  }

  Widget _buildContentSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _maxChannelsPerRecapController,
          title: 'Maximum Channels Per Recap',
          subtitle:
              'Maximum number of channels included in a single recap. Set to 0 for unlimited.',
          placeholder: '0',
          keyboardType: TextInputType.number,
          enabled: _enableRecap,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _maxPostsPerRecapController,
          title: 'Maximum Posts Per Recap',
          subtitle:
              'Maximum number of posts included in a single recap. Set to 0 for unlimited.',
          placeholder: '0',
          keyboardType: TextInputType.number,
          enabled: _enableRecap,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _maxTokensPerRecapController,
          title: 'Maximum Tokens Per Recap',
          subtitle:
              'Maximum number of tokens used per recap. Set to 0 for unlimited.',
          placeholder: '0',
          keyboardType: TextInputType.number,
          enabled: _enableRecap,
        ),
      ],
    );
  }

  Widget _buildTimeSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _cooldownMinutesController,
          title: 'Cooldown Between Recaps (minutes)',
          subtitle:
              'Minimum time (in minutes) a user must wait between requesting recaps. Set to 0 for no cooldown.',
          placeholder: '60',
          keyboardType: TextInputType.number,
          enabled: _enableRecap,
        ),
      ],
    );
  }

  // --- Helper Widgets ---

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
      child: Column(children: children),
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
          style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
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
          ),
        ),
      ],
    );
  }
}
