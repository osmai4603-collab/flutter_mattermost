import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class DataSpillageHandlingPage extends StatefulWidget {
  const DataSpillageHandlingPage({super.key});

  @override
  State<DataSpillageHandlingPage> createState() =>
      _DataSpillageHandlingPageState();
}

class _DataSpillageHandlingPageState extends State<DataSpillageHandlingPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableContentFlagging = false;
  bool _enableExternalImageDeletion = false;
  bool _enableAutomaticReplies = false;
  final TextEditingController _notificationChannelController =
      TextEditingController();
  final TextEditingController _reviewersController = TextEditingController();
  bool _allowSelfReview = false;
  bool _notifyOnFlagged = true;
  bool _includePostContent = true;
  final TextEditingController _customMessageController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _notificationChannelController.dispose();
    _reviewersController.dispose();
    _customMessageController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final contentFlagging =
          (config['ContentFlaggingSettings'] as Map<String, dynamic>?) ??
          const {};

      _enableContentFlagging = contentFlagging['EnableContentFlagging'] == true;
      _enableExternalImageDeletion =
          contentFlagging['EnableExternalImageDeletion'] == true;
      _enableAutomaticReplies =
          contentFlagging['EnableAutomaticReplies'] == true;
      _notificationChannelController.text =
          (contentFlagging['NotificationChannel'] as String?) ?? '';
      _reviewersController.text =
          (contentFlagging['Reviewers'] as String?) ?? '';
      _allowSelfReview = contentFlagging['AllowSelfReview'] == true;
      _notifyOnFlagged = contentFlagging['NotifyOnFlagged'] != false;
      _includePostContent = contentFlagging['IncludePostContent'] != false;
      _customMessageController.text =
          (contentFlagging['CustomMessage'] as String?) ?? '';
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
        'ContentFlaggingSettings': {
          'EnableContentFlagging': _enableContentFlagging,
          'EnableExternalImageDeletion': _enableExternalImageDeletion,
          'EnableAutomaticReplies': _enableAutomaticReplies,
          'NotificationChannel': _notificationChannelController.text.trim(),
          'Reviewers': _reviewersController.text.trim(),
          'AllowSelfReview': _allowSelfReview,
          'NotifyOnFlagged': _notifyOnFlagged,
          'IncludePostContent': _includePostContent,
          'CustomMessage': _customMessageController.text.trim(),
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Data Spillage Handling settings saved'),
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
              'Data Spillage Handling',
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
                  _buildReviewersSection(colors),
                  const SizedBox(height: 20),
                  _buildNotificationsSection(colors),
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
              'Data Spillage Handling is an Enterprise Advanced feature. Please ensure you have the appropriate license to use this feature.',
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
          value: _enableContentFlagging,
          onChanged: (v) {
            if (v != null) setState(() => _enableContentFlagging = v);
          },
          title: 'Enable Data Spillage Handling',
          subtitle:
              'When true, data spillage handling and content flagging features are enabled across the system.',
        ),
      ],
    );
  }

  Widget _buildReviewersSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _reviewersController,
          title: 'Content Reviewers',
          subtitle:
              'Comma-separated list of user IDs who are authorized to review flagged content.',
          placeholder: 'user_id_1, user_id_2',
          enabled: _enableContentFlagging,
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _allowSelfReview,
          onChanged: _enableContentFlagging
              ? (v) {
                  if (v != null) setState(() => _allowSelfReview = v);
                }
              : null,
          title: 'Allow Self Review',
          subtitle:
              'When true, users who flagged their own content can review and resolve it.',
        ),
      ],
    );
  }

  Widget _buildNotificationsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _notificationChannelController,
          title: 'Notification Channel',
          subtitle:
              'Channel ID where notifications about flagged content will be sent.',
          placeholder: 'channel_id',
          enabled: _enableContentFlagging,
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _notifyOnFlagged,
          onChanged: _enableContentFlagging
              ? (v) {
                  if (v != null) setState(() => _notifyOnFlagged = v);
                }
              : null,
          title: 'Notify on Flagged Content',
          subtitle:
              'When true, reviewers are notified when content is flagged for review.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _includePostContent,
          onChanged: _enableContentFlagging
              ? (v) {
                  if (v != null) setState(() => _includePostContent = v);
                }
              : null,
          title: 'Include Post Content in Notifications',
          subtitle:
              'When true, the actual post content is included in review notifications.',
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
          value: _enableExternalImageDeletion,
          onChanged: _enableContentFlagging
              ? (v) {
                  if (v != null)
                    setState(() => _enableExternalImageDeletion = v);
                }
              : null,
          title: 'Enable External Image Deletion',
          subtitle:
              'When true, external images in flagged content are automatically deleted.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableAutomaticReplies,
          onChanged: _enableContentFlagging
              ? (v) {
                  if (v != null) setState(() => _enableAutomaticReplies = v);
                }
              : null,
          title: 'Enable Automatic Replies',
          subtitle:
              'When true, automatic replies are sent to users when their content is flagged.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _customMessageController,
          title: 'Custom Message',
          subtitle:
              'Custom message to display to users when their content is flagged for review.',
          placeholder: 'Your content has been flagged for review...',
          enabled: _enableContentFlagging,
          maxLines: 3,
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
    bool enabled = true,
    int maxLines = 1,
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
          enabled: enabled,
          maxLines: maxLines,
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
