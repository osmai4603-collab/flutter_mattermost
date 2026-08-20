import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  // Threads
  bool _threadAutoFollow = true;
  String _collapsedThreads = 'default_off';

  // Drafts
  bool _allowSyncedDrafts = false;
  bool _scheduledPosts = false;

  // Priority
  bool _postPriority = false;
  bool _allowPersistentNotifications = false;
  final TextEditingController _persistentNotificationMaxRecipientsController =
      TextEditingController();
  final TextEditingController _persistentNotificationIntervalMinutesController =
      TextEditingController();
  final TextEditingController _persistentNotificationMaxCountController =
      TextEditingController();
  bool _allowPersistentNotificationsForGuests = false;

  // Content & Previews
  bool _enableLinkPreviews = true;
  final TextEditingController _restrictLinkPreviewsController =
      TextEditingController();
  bool _enablePermalinkPreviews = true;
  bool _enableSVGs = false;
  bool _enableLatex = false;
  bool _enableInlineLatex = false;
  final TextEditingController _googleDeveloperKeyController =
      TextEditingController();

  // Performance
  final TextEditingController _maxMarkdownNodesController =
      TextEditingController();
  final TextEditingController _uniqueEmojiReactionLimitPerPostController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _persistentNotificationMaxRecipientsController.dispose();
    _persistentNotificationIntervalMinutesController.dispose();
    _persistentNotificationMaxCountController.dispose();
    _restrictLinkPreviewsController.dispose();
    _googleDeveloperKeyController.dispose();
    _maxMarkdownNodesController.dispose();
    _uniqueEmojiReactionLimitPerPostController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};
      final displaySettings =
          (config['DisplaySettings'] as Map<String, dynamic>?) ?? const {};

      _threadAutoFollow = serviceSettings['ThreadAutoFollow'] != false;
      _collapsedThreads =
          (serviceSettings['CollapsedThreads'] as String?) ?? 'default_off';
      _allowSyncedDrafts = serviceSettings['AllowSyncedDrafts'] == true;
      _scheduledPosts = serviceSettings['ScheduledPosts'] == true;
      _postPriority = serviceSettings['PostPriority'] == true;
      _allowPersistentNotifications =
          serviceSettings['AllowPersistentNotifications'] == true;
      _persistentNotificationMaxRecipientsController.text =
          (serviceSettings['PersistentNotificationMaxRecipients']
              ?.toString()) ??
          '5';
      _persistentNotificationIntervalMinutesController.text =
          (serviceSettings['PersistentNotificationIntervalMinutes']
              ?.toString()) ??
          '5';
      _persistentNotificationMaxCountController.text =
          (serviceSettings['PersistentNotificationMaxCount']?.toString()) ??
          '6';
      _allowPersistentNotificationsForGuests =
          serviceSettings['AllowPersistentNotificationsForGuests'] == true;
      _enableLinkPreviews = serviceSettings['EnableLinkPreviews'] != false;
      _restrictLinkPreviewsController.text =
          (serviceSettings['RestrictLinkPreviews'] as String?) ?? '';
      _enablePermalinkPreviews =
          serviceSettings['EnablePermalinkPreviews'] != false;
      _enableSVGs = serviceSettings['EnableSVGs'] == true;
      _enableLatex = serviceSettings['EnableLatex'] == true;
      _enableInlineLatex = serviceSettings['EnableInlineLatex'] == true;
      _googleDeveloperKeyController.text =
          (serviceSettings['GoogleDeveloperKey'] as String?) ?? '';
      _maxMarkdownNodesController.text =
          (displaySettings['MaxMarkdownNodes']?.toString()) ?? '0';
      _uniqueEmojiReactionLimitPerPostController.text =
          (serviceSettings['UniqueEmojiReactionLimitPerPost']?.toString()) ??
          '25';
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
        'ServiceSettings': {
          'ThreadAutoFollow': _threadAutoFollow,
          'CollapsedThreads': _collapsedThreads,
          'AllowSyncedDrafts': _allowSyncedDrafts,
          'ScheduledPosts': _scheduledPosts,
          'PostPriority': _postPriority,
          'AllowPersistentNotifications': _allowPersistentNotifications,
          'PersistentNotificationMaxRecipients':
              int.tryParse(
                _persistentNotificationMaxRecipientsController.text.trim(),
              ) ??
              5,
          'PersistentNotificationIntervalMinutes':
              int.tryParse(
                _persistentNotificationIntervalMinutesController.text.trim(),
              ) ??
              5,
          'PersistentNotificationMaxCount':
              int.tryParse(
                _persistentNotificationMaxCountController.text.trim(),
              ) ??
              6,
          'AllowPersistentNotificationsForGuests':
              _allowPersistentNotificationsForGuests,
          'EnableLinkPreviews': _enableLinkPreviews,
          'RestrictLinkPreviews': _restrictLinkPreviewsController.text.trim(),
          'EnablePermalinkPreviews': _enablePermalinkPreviews,
          'EnableSVGs': _enableSVGs,
          'EnableLatex': _enableLatex,
          'EnableInlineLatex': _enableInlineLatex,
          'GoogleDeveloperKey': _googleDeveloperKeyController.text.trim(),
          'UniqueEmojiReactionLimitPerPost':
              int.tryParse(
                _uniqueEmojiReactionLimitPerPostController.text.trim(),
              ) ??
              25,
        },
        'DisplaySettings': {
          'MaxMarkdownNodes':
              int.tryParse(_maxMarkdownNodesController.text.trim()) ?? 0,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Posts settings saved'),
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
              'Posts',
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
                  _buildSectionTitle(colors, 'Threads'),
                  _buildThreadsSection(colors),
                  const SizedBox(height: 20),
                  _buildSectionTitle(colors, 'Drafts and Scheduled Posts'),
                  _buildDraftsSection(colors),
                  const SizedBox(height: 20),
                  _buildSectionTitle(colors, 'Priority & Urgent Notifications'),
                  _buildPrioritySection(colors),
                  const SizedBox(height: 20),
                  _buildSectionTitle(colors, 'Content & Previews'),
                  _buildPreviewsSection(colors),
                  const SizedBox(height: 20),
                  _buildSectionTitle(colors, 'Performance & Limits'),
                  _buildPerformanceSection(colors),
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

  Widget _buildThreadsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _threadAutoFollow,
          onChanged: (v) {
            if (v != null) setState(() => _threadAutoFollow = v);
          },
          title: 'Automatically Follow Threads',
          subtitle:
              'When true, all threads that a user participates in or is mentioned in will be automatically followed.',
        ),
        _divider(colors),
        _dropdownTile(
          colors,
          value: _collapsedThreads,
          onChanged: (v) {
            if (v != null) setState(() => _collapsedThreads = v);
          },
          title: 'Threaded Discussions',
          subtitle: 'Choose how threaded discussions work in Mattermost.',
          options: {
            'disabled': 'Disabled',
            'default_off': 'Enabled (Default Off)',
            'default_on': 'Enabled (Default On)',
            'always_on': 'Always On',
          },
        ),
      ],
    );
  }

  Widget _buildDraftsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _allowSyncedDrafts,
          onChanged: (v) {
            if (v != null) setState(() => _allowSyncedDrafts = v);
          },
          title: 'Enable Server Syncing of Message Drafts',
          subtitle:
              'When true, drafts are synced across devices so users can continue writing from any device.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _scheduledPosts,
          onChanged: (v) {
            if (v != null) setState(() => _scheduledPosts = v);
          },
          title: 'Scheduled Posts',
          subtitle:
              'When true, users can schedule messages to be sent at a later time.',
        ),
      ],
    );
  }

  Widget _buildPrioritySection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _postPriority,
          onChanged: (v) {
            if (v != null) setState(() => _postPriority = v);
          },
          title: 'Message Priority',
          subtitle:
              'When true, users can set a priority level on their messages to indicate urgency.',
        ),
        if (_postPriority) ...[
          _divider(colors),
          _boolTile(
            colors,
            value: _allowPersistentNotifications,
            onChanged: (v) {
              if (v != null) setState(() => _allowPersistentNotifications = v);
            },
            title: 'Persistent Notifications',
            subtitle:
                'When true, users can send persistent notifications that repeatedly notify recipients until acknowledged.',
          ),
        ],
        if (_postPriority && _allowPersistentNotifications) ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _persistentNotificationMaxRecipientsController,
            title: 'Maximum Recipients for Persistent Notifications',
            subtitle:
                'Maximum number of recipients allowed for a persistent notification.',
            placeholder: '5',
            keyboardType: TextInputType.number,
          ),
          _divider(colors),
          _textTile(
            colors,
            controller: _persistentNotificationIntervalMinutesController,
            title: 'Frequency of Persistent Notifications (minutes)',
            subtitle:
                'How often persistent notifications are repeated. Minimum value is 2.',
            placeholder: '5',
            keyboardType: TextInputType.number,
          ),
          _divider(colors),
          _textTile(
            colors,
            controller: _persistentNotificationMaxCountController,
            title: 'Total Number of Persistent Notifications per Post',
            subtitle:
                'Maximum number of times a persistent notification will be sent.',
            placeholder: '6',
            keyboardType: TextInputType.number,
          ),
          _divider(colors),
          _boolTile(
            colors,
            value: _allowPersistentNotificationsForGuests,
            onChanged: (v) {
              if (v != null)
                setState(() => _allowPersistentNotificationsForGuests = v);
            },
            title: 'Allow Guests to Send Persistent Notifications',
            subtitle:
                'When true, guest users can send persistent notifications.',
          ),
        ],
      ],
    );
  }

  Widget _buildPreviewsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableLinkPreviews,
          onChanged: (v) {
            if (v != null) setState(() => _enableLinkPreviews = v);
          },
          title: 'Enable Website Link Previews',
          subtitle:
              'When true, links to public websites will show a preview beneath the message.',
        ),
        if (_enableLinkPreviews) ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _restrictLinkPreviewsController,
            title: 'Disable Website Link Previews from These Domains',
            subtitle:
                'Comma-separated list of domains to disable link previews for.',
            placeholder: 'example.com, test.org',
          ),
        ],
        _divider(colors),
        _boolTile(
          colors,
          value: _enablePermalinkPreviews,
          onChanged: (v) {
            if (v != null) setState(() => _enablePermalinkPreviews = v);
          },
          title: 'Enable Message Link Previews',
          subtitle:
              'When true, links to Mattermost messages will show a preview beneath the message.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableSVGs,
          onChanged: (v) {
            if (v != null) setState(() => _enableSVGs = v);
          },
          title: 'Enable SVGs',
          subtitle:
              'When true, SVGs are enabled and can be rendered in messages and channel descriptions.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableLatex,
          onChanged: (v) {
            if (v != null) setState(() => _enableLatex = v);
          },
          title: 'Enable Latex Rendering',
          subtitle:
              'When true, users can display code blocks using LaTeX syntax.',
        ),
        if (_enableLatex) ...[
          _divider(colors),
          _boolTile(
            colors,
            value: _enableInlineLatex,
            onChanged: (v) {
              if (v != null) setState(() => _enableInlineLatex = v);
            },
            title: 'Enable Inline Latex Rendering',
            subtitle: 'When true, inline LaTeX is rendered within messages.',
          ),
        ],
        _divider(colors),
        _textTile(
          colors,
          controller: _googleDeveloperKeyController,
          title: 'Google API Key',
          subtitle: 'Google API Key for YouTube link previews.',
          placeholder: 'Enter API Key',
        ),
      ],
    );
  }

  Widget _buildPerformanceSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _maxMarkdownNodesController,
          title: 'Maximum Markdown Nodes',
          subtitle:
              'Maximum number of markdown nodes (e.g., tables, code blocks) allowed per post. Set to 0 for no limit.',
          placeholder: '0',
          keyboardType: TextInputType.number,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _uniqueEmojiReactionLimitPerPostController,
          title: 'Unique Emoji Reaction Limit per Post',
          subtitle:
              'Maximum number of unique emoji reactions allowed per post. Set to 0 for no limit.',
          placeholder: '25',
          keyboardType: TextInputType.number,
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

  Widget _dropdownTile(
    MattermostColors colors, {
    required String value,
    ValueChanged<String?>? onChanged,
    required String title,
    required String subtitle,
    required Map<String, String> options,
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
        DropdownButtonFormField<String>(
          initialValue: options.containsKey(value) ? value : options.keys.first,
          onChanged: onChanged,
          dropdownColor: colors.centerChannelBg,
          style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          items: options.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
        ),
      ],
    );
  }
}
