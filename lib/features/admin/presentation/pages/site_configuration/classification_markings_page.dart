import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class ClassificationMarkingsPage extends StatefulWidget {
  const ClassificationMarkingsPage({super.key});

  @override
  State<ClassificationMarkingsPage> createState() =>
      _ClassificationMarkingsPageState();
}

class _ClassificationMarkingsPageState
    extends State<ClassificationMarkingsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableClassificationMarkings = false;
  bool _enforceClassificationMarkings = false;
  final TextEditingController _classificationLevelsController =
      TextEditingController();
  bool _showClassificationOnPosts = true;
  bool _showClassificationOnChannels = true;
  bool _allowUserCustomMarkings = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _classificationLevelsController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final classificationSettings =
          (config['ClassificationMarkingsSettings'] as Map<String, dynamic>?) ??
          const {};

      _enableClassificationMarkings =
          classificationSettings['EnableClassificationMarkings'] == true;
      _enforceClassificationMarkings =
          classificationSettings['EnforceClassificationMarkings'] == true;
      _classificationLevelsController.text =
          (classificationSettings['ClassificationLevels'] as String?) ?? '';
      _showClassificationOnPosts =
          classificationSettings['ShowClassificationOnPosts'] != false;
      _showClassificationOnChannels =
          classificationSettings['ShowClassificationOnChannels'] != false;
      _allowUserCustomMarkings =
          classificationSettings['AllowUserCustomMarkings'] == true;
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
        'ClassificationMarkingsSettings': {
          'EnableClassificationMarkings': _enableClassificationMarkings,
          'EnforceClassificationMarkings': _enforceClassificationMarkings,
          'ClassificationLevels': _classificationLevelsController.text.trim(),
          'ShowClassificationOnPosts': _showClassificationOnPosts,
          'ShowClassificationOnChannels': _showClassificationOnChannels,
          'AllowUserCustomMarkings': _allowUserCustomMarkings,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Classification Markings settings saved'),
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
              'Classification Markings',
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
                  _buildInfoBanner(colors),
                  const SizedBox(height: 20),
                  _buildGeneralSection(colors),
                  const SizedBox(height: 20),
                  _buildDisplaySection(colors),
                  const SizedBox(height: 20),
                  _buildAdvancedSection(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoBanner(MattermostColors colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.buttonBg.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.buttonBg.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colors.buttonBg, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Classification Markings is an Enterprise Advanced feature. Please ensure you have the appropriate license to use this feature.',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.70),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableClassificationMarkings,
          onChanged: (v) {
            if (v != null) setState(() => _enableClassificationMarkings = v);
          },
          title: 'Enable Classification Markings',
          subtitle:
              'When true, classification markings are enabled and can be applied to content and channels across the system.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enforceClassificationMarkings,
          onChanged: _enableClassificationMarkings
              ? (v) {
                  if (v != null)
                    setState(() => _enforceClassificationMarkings = v);
                }
              : null,
          title: 'Enforce Classification Markings',
          subtitle:
              'When true, users are required to add classification markings to their posts before sending.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _classificationLevelsController,
          title: 'Classification Levels',
          subtitle:
              'Define the available classification levels as a JSON array. Each level should include a label, color, and severity.',
          placeholder: '[{"label":"Public","color":"#00FF00","severity":0}]',
        ),
      ],
    );
  }

  Widget _buildDisplaySection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _showClassificationOnPosts,
          onChanged: _enableClassificationMarkings
              ? (v) {
                  if (v != null) setState(() => _showClassificationOnPosts = v);
                }
              : null,
          title: 'Show Classification on Posts',
          subtitle:
              'When true, classification labels are displayed on individual posts in the channel view.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _showClassificationOnChannels,
          onChanged: _enableClassificationMarkings
              ? (v) {
                  if (v != null)
                    setState(() => _showClassificationOnChannels = v);
                }
              : null,
          title: 'Show Classification on Channels',
          subtitle:
              'When true, classification labels are displayed on channel headers in the sidebar.',
        ),
      ],
    );
  }

  Widget _buildAdvancedSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _allowUserCustomMarkings,
          onChanged: _enableClassificationMarkings
              ? (v) {
                  if (v != null) setState(() => _allowUserCustomMarkings = v);
                }
              : null,
          title: 'Allow User Custom Markings',
          subtitle:
              'When true, users can create custom classification markings in addition to the system-defined ones.',
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
          style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          maxLines: 3,
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
