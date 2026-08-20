import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class UsersAndTeamsPage extends StatefulWidget {
  const UsersAndTeamsPage({super.key});

  @override
  State<UsersAndTeamsPage> createState() => _UsersAndTeamsPageState();
}

class _UsersAndTeamsPageState extends State<UsersAndTeamsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _maxUsersPerTeamController =
      TextEditingController();
  final TextEditingController _maxChannelsPerTeamController =
      TextEditingController();
  bool _enableChannelCategorySorting = false;
  bool _enableJoinLeaveMessageByDefault = true;
  String _restrictDirectMessage = 'any';
  String _teammateNameDisplay = 'username';
  bool _lockTeammateNameDisplay = false;
  String _lockProfileFieldsForEmailUsers = 'none';
  bool _showEmailAddress = true;
  bool _showFullName = true;
  bool _enableCustomUserStatuses = false;
  bool _enableLastActiveTime = false;
  bool _enableCustomGroups = false;
  final TextEditingController _refreshPostStatsRunTimeController =
      TextEditingController();
  final TextEditingController _deleteAccountLinkController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _maxUsersPerTeamController.dispose();
    _maxChannelsPerTeamController.dispose();
    _refreshPostStatsRunTimeController.dispose();
    _deleteAccountLinkController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final teamSettings =
          (config['TeamSettings'] as Map<String, dynamic>?) ?? const {};
      final privacySettings =
          (config['PrivacySettings'] as Map<String, dynamic>?) ?? const {};
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _maxUsersPerTeamController.text =
          (teamSettings['MaxUsersPerTeam']?.toString()) ?? '50';
      _maxChannelsPerTeamController.text =
          (teamSettings['MaxChannelsPerTeam']?.toString()) ?? '2000';
      _enableChannelCategorySorting =
          teamSettings['EnableChannelCategorySorting'] == true;
      _enableJoinLeaveMessageByDefault =
          teamSettings['EnableJoinLeaveMessageByDefault'] != false;
      _restrictDirectMessage =
          (teamSettings['RestrictDirectMessage'] as String?) ?? 'any';
      _teammateNameDisplay =
          (teamSettings['TeammateNameDisplay'] as String?) ?? 'username';
      _lockTeammateNameDisplay =
          teamSettings['LockTeammateNameDisplay'] == true;
      _lockProfileFieldsForEmailUsers =
          (teamSettings['LockProfileFieldsForEmailUsers'] as String?) ?? 'none';
      _showEmailAddress = privacySettings['ShowEmailAddress'] != false;
      _showFullName = privacySettings['ShowFullName'] != false;
      _enableCustomUserStatuses =
          teamSettings['EnableCustomUserStatuses'] == true;
      _enableLastActiveTime = teamSettings['EnableLastActiveTime'] == true;
      _enableCustomGroups = serviceSettings['EnableCustomGroups'] == true;
      _refreshPostStatsRunTimeController.text =
          (serviceSettings['RefreshPostStatsRunTime'] as String?) ?? '';
      _deleteAccountLinkController.text =
          (serviceSettings['DeleteAccountLink'] as String?) ?? '';
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
        'TeamSettings': {
          'MaxUsersPerTeam':
              int.tryParse(_maxUsersPerTeamController.text.trim()) ?? 50,
          'MaxChannelsPerTeam':
              int.tryParse(_maxChannelsPerTeamController.text.trim()) ?? 2000,
          'EnableChannelCategorySorting': _enableChannelCategorySorting,
          'EnableJoinLeaveMessageByDefault': _enableJoinLeaveMessageByDefault,
          'RestrictDirectMessage': _restrictDirectMessage,
          'TeammateNameDisplay': _teammateNameDisplay,
          'LockTeammateNameDisplay': _lockTeammateNameDisplay,
          'LockProfileFieldsForEmailUsers': _lockProfileFieldsForEmailUsers,
          'EnableCustomUserStatuses': _enableCustomUserStatuses,
          'EnableLastActiveTime': _enableLastActiveTime,
        },
        'PrivacySettings': {
          'ShowEmailAddress': _showEmailAddress,
          'ShowFullName': _showFullName,
        },
        'ServiceSettings': {
          'EnableCustomGroups': _enableCustomGroups,
          'RefreshPostStatsRunTime': _refreshPostStatsRunTimeController.text
              .trim(),
          'DeleteAccountLink': _deleteAccountLinkController.text.trim(),
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Users and Teams settings saved'),
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
              'Users and Teams',
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
                  _buildTeamLimitsSection(colors),
                  const SizedBox(height: 20),
                  _buildMessagingSection(colors),
                  const SizedBox(height: 20),
                  _buildDisplaySection(colors),
                  const SizedBox(height: 20),
                  _buildPrivacySection(colors),
                  const SizedBox(height: 20),
                  _buildAdvancedSection(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildTeamLimitsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _maxUsersPerTeamController,
          title: 'Max Users Per Team',
          subtitle:
              'Maximum number of users per team, excluding system admins.',
          placeholder: '50',
          keyboardType: TextInputType.number,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _maxChannelsPerTeamController,
          title: 'Max Channels Per Team',
          subtitle:
              'Maximum number of channels per team, including active and archived channels.',
          placeholder: '2000',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildMessagingSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableChannelCategorySorting,
          onChanged: (v) {
            if (v != null) setState(() => _enableChannelCategorySorting = v);
          },
          title: 'Channel Category Sorting',
          subtitle:
              'When true, users can organize channels into custom categories in their sidebar.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableJoinLeaveMessageByDefault,
          onChanged: (v) {
            if (v != null) setState(() => _enableJoinLeaveMessageByDefault = v);
          },
          title: 'Enable Join/Leave Messages by Default',
          subtitle:
              'When true, join/leave messages are displayed in channels by default. Users can override this in their notification settings.',
        ),
        _divider(colors),
        _dropdownTile(
          colors,
          value: _restrictDirectMessage,
          onChanged: (v) {
            if (v != null) setState(() => _restrictDirectMessage = v);
          },
          title: 'Enable Users to Open Direct Message Channels With',
          subtitle: 'Restricts who can create new Direct Message channels.',
          options: {
            'any': 'Any user on the Mattermost server',
            'team': 'Any member of the team',
          },
        ),
      ],
    );
  }

  Widget _buildDisplaySection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _dropdownTile(
          colors,
          value: _teammateNameDisplay,
          onChanged: (v) {
            if (v != null) setState(() => _teammateNameDisplay = v);
          },
          title: 'Teammate Name Display',
          subtitle:
              'Set how to display other users\' names in the user interface.',
          options: {
            'username': 'Show username (default)',
            'nickname_full_name':
                'Show nickname if one exists, otherwise show first and last name',
            'full_name': 'Show first and last name',
          },
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _lockTeammateNameDisplay,
          onChanged: (v) {
            if (v != null) setState(() => _lockTeammateNameDisplay = v);
          },
          title: 'Lock Teammate Name Display for All Users',
          subtitle:
              'When true, users cannot change the teammate name display setting in their account settings.',
        ),
        _divider(colors),
        _dropdownTile(
          colors,
          value: _lockProfileFieldsForEmailUsers,
          onChanged: (v) {
            if (v != null) setState(() => _lockProfileFieldsForEmailUsers = v);
          },
          title: 'Lock Profile Fields for Email Users',
          subtitle:
              'Set which profile fields are locked for users who signed up with email.',
          options: {
            'none': 'Don\'t lock profile fields (default)',
            'name_and_username': 'Lock name and username',
            'all': 'Lock entire profile',
          },
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableCustomUserStatuses,
          onChanged: (v) {
            if (v != null) setState(() => _enableCustomUserStatuses = v);
          },
          title: 'Enable Custom Statuses',
          subtitle:
              'When true, users can set a custom status to share their availability or activities with their team.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableLastActiveTime,
          onChanged: (v) {
            if (v != null) setState(() => _enableLastActiveTime = v);
          },
          title: 'Enable Last Active Time',
          subtitle:
              'When true, users can see when their teammates were last active.',
        ),
      ],
    );
  }

  Widget _buildPrivacySection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _showEmailAddress,
          onChanged: (v) {
            if (v != null) setState(() => _showEmailAddress = v);
          },
          title: 'Show Email Address',
          subtitle:
              'When true, email addresses are shown to users in the user interface.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _showFullName,
          onChanged: (v) {
            if (v != null) setState(() => _showFullName = v);
          },
          title: 'Show Full Name',
          subtitle:
              'When true, full names are shown to users in the user interface.',
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
          value: _enableCustomGroups,
          onChanged: (v) {
            if (v != null) setState(() => _enableCustomGroups = v);
          },
          title: 'Enable Custom User Groups',
          subtitle:
              'When true, users can create custom user groups and invite users to them.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _refreshPostStatsRunTimeController,
          title: 'User Statistics Update Time',
          subtitle:
              'Set the time in 24-hour format (HH:MM) when the user statistics should be updated.',
          placeholder: '00:00',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _deleteAccountLinkController,
          title: 'Delete Account Link',
          subtitle:
              'If a URL is specified, a "Delete Account" link is shown in the Account Settings panel. The link should open a page that helps users delete their accounts.',
          placeholder: 'https://example.com/delete',
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
