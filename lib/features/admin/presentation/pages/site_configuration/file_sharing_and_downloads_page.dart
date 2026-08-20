import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class FileSharingAndDownloadsPage extends StatefulWidget {
  const FileSharingAndDownloadsPage({super.key});

  @override
  State<FileSharingAndDownloadsPage> createState() =>
      _FileSharingAndDownloadsPageState();
}

class _FileSharingAndDownloadsPageState
    extends State<FileSharingAndDownloadsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableFileAttachments = true;
  bool _enableMobileUpload = true;
  bool _enableMobileDownload = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final fileSettings =
          (config['FileSettings'] as Map<String, dynamic>?) ?? const {};

      _enableFileAttachments = fileSettings['EnableFileAttachments'] != false;
      _enableMobileUpload = fileSettings['EnableMobileUpload'] != false;
      _enableMobileDownload = fileSettings['EnableMobileDownload'] != false;
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
        'FileSettings': {
          'EnableFileAttachments': _enableFileAttachments,
          'EnableMobileUpload': _enableMobileUpload,
          'EnableMobileDownload': _enableMobileDownload,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('File Sharing and Downloads settings saved'),
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
              'File Sharing and Downloads',
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
                children: [_buildFileSharingSection(colors)],
              ),
            ),
    );
  }

  Widget _buildFileSharingSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableFileAttachments,
          onChanged: (v) {
            if (v != null) setState(() => _enableFileAttachments = v);
          },
          title: 'Allow File Sharing',
          subtitle:
              'When false, file and image uploads are disabled in all messages. Use this to restrict file sharing across the system.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableMobileUpload,
          onChanged: (v) {
            if (v != null) setState(() => _enableMobileUpload = v);
          },
          title: 'Allow File Uploads on Mobile',
          subtitle:
              'When true, users can upload files from the Mattermost mobile app. Requires Compliance feature license.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableMobileDownload,
          onChanged: (v) {
            if (v != null) setState(() => _enableMobileDownload = v);
          },
          title: 'Allow File Downloads on Mobile',
          subtitle:
              'When true, users can download files from the Mattermost mobile app. Requires Compliance feature license.',
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
}
