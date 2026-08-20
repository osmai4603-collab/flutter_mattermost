import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/save_changes_panel.dart';

/// صفحة الميزات التجريبية (Experimental Features)
/// تطابق صفحة ExperimentalFeatures في Mattermost webapp.
class ExperimentalFeaturesPage extends StatefulWidget {
  const ExperimentalFeaturesPage({super.key});

  @override
  State<ExperimentalFeaturesPage> createState() =>
      _ExperimentalFeaturesPageState();
}

class _ExperimentalFeaturesPageState extends State<ExperimentalFeaturesPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _loading = true;
  bool _saving = false;
  String? _error;

  // ─── Controllers ───
  final _ldapLoginButtonColor = TextEditingController(text: '#2389D2');
  final _ldapLoginButtonBorderColor = TextEditingController(text: '#2389D2');
  final _ldapLoginButtonTextColor = TextEditingController(text: '#FFFFFF');

  bool _enableAuthenticationTransfer = true;

  final _linkMetadataTimeout = TextEditingController(text: '5000');

  final _emailBatchingBufferSize = TextEditingController(text: '256');
  final _emailBatchingInterval = TextEditingController(text: '30');

  final _emailLoginButtonColor = TextEditingController(text: '#2389D2');
  final _emailLoginButtonBorderColor = TextEditingController(text: '#2389D2');
  final _emailLoginButtonTextColor = TextEditingController(text: '#FFFFFF');

  bool _enableUserDeactivation = false;
  bool _enableAutomaticReplies = false;
  bool _enableChannelViewedMessages = true;
  bool _enableDefaultChannelLeaveJoinMessages = true;
  bool _enableHardenedMode = false;

  bool _enableThemeSelection = true;
  bool _allowCustomThemes = true;
  String _defaultTheme = 'denim';

  bool _enableTutorial = true;
  bool _enableOnboardingFlow = true;
  bool _enableUserTypingMessages = true;
  final _typingTimeout = TextEditingController(text: '5000');
  final _profileFetchingPollInterval = TextEditingController(text: '30000');
  final _primaryTeam = TextEditingController();

  final _samlLoginButtonColor = TextEditingController(text: '#2389D2');
  final _samlLoginButtonBorderColor = TextEditingController(text: '#2389D2');
  final _samlLoginButtonTextColor = TextEditingController(text: '#FFFFFF');

  bool _useChannelInEmailNotifications = true;
  final _userStatusAwayTimeout = TextEditingController(text: '300');

  bool _disableAppBar = false;
  bool _disableRefetchingOnBrowserFocus = false;
  bool _disableWakeUpReconnectHandler = false;
  bool _delayChannelAutocomplete = false;
  bool _youtubeReferrerPolicy = false;
  bool _enableWatermark = false;

  final Map<String, dynamic> _pendingChanges = {};

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
      final config = await _repository.getConfig();
      if (!mounted) return;

      final ldap =
          (config['LdapSettings'] as Map<String, dynamic>?) ?? const {};
      final service =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};
      final email =
          (config['EmailSettings'] as Map<String, dynamic>?) ?? const {};
      final team =
          (config['TeamSettings'] as Map<String, dynamic>?) ?? const {};
      final theme =
          (config['ThemeSettings'] as Map<String, dynamic>?) ?? const {};
      final experimental =
          (config['ExperimentalSettings'] as Map<String, dynamic>?) ?? const {};
      final saml =
          (config['SamlSettings'] as Map<String, dynamic>?) ?? const {};

      setState(() {
        _ldapLoginButtonColor.text =
            ldap['LoginButtonColor'] as String? ?? '#2389D2';
        _ldapLoginButtonBorderColor.text =
            ldap['LoginButtonBorderColor'] as String? ?? '#2389D2';
        _ldapLoginButtonTextColor.text =
            ldap['LoginButtonTextColor'] as String? ?? '#FFFFFF';

        _enableAuthenticationTransfer =
            service['ExperimentalEnableAuthenticationTransfer'] as bool? ?? true;

        _linkMetadataTimeout.text =
            (experimental['LinkMetadataTimeoutMilliseconds'] ?? 5000)
                .toString();

        _emailBatchingBufferSize.text =
            (email['EmailBatchingBufferSize'] ?? 256).toString();
        _emailBatchingInterval.text =
            (email['EmailBatchingInterval'] ?? 30).toString();

        _emailLoginButtonColor.text =
            email['LoginButtonColor'] as String? ?? '#2389D2';
        _emailLoginButtonBorderColor.text =
            email['LoginButtonBorderColor'] as String? ?? '#2389D2';
        _emailLoginButtonTextColor.text =
            email['LoginButtonTextColor'] as String? ?? '#FFFFFF';

        _enableUserDeactivation =
            team['EnableUserDeactivation'] as bool? ?? false;
        _enableAutomaticReplies =
            team['ExperimentalEnableAutomaticReplies'] as bool? ?? false;
        _enableChannelViewedMessages =
            service['EnableChannelViewedMessages'] as bool? ?? true;
        _enableDefaultChannelLeaveJoinMessages =
            service['ExperimentalEnableDefaultChannelLeaveJoinMessages']
                    as bool? ??
                true;
        _enableHardenedMode =
            service['ExperimentalEnableHardenedMode'] as bool? ?? false;

        _enableThemeSelection =
            theme['EnableThemeSelection'] as bool? ?? true;
        _allowCustomThemes =
            theme['AllowCustomThemes'] as bool? ?? true;
        _defaultTheme = theme['DefaultTheme'] as String? ?? 'denim';

        _enableTutorial = service['EnableTutorial'] as bool? ?? true;
        _enableOnboardingFlow =
            service['EnableOnboardingFlow'] as bool? ?? true;
        _enableUserTypingMessages =
            service['EnableUserTypingMessages'] as bool? ?? true;
        _typingTimeout.text =
            (service['TimeBetweenUserTypingUpdatesMilliseconds'] ?? 5000)
                .toString();
        _profileFetchingPollInterval.text =
            (experimental['UsersStatusAndProfileFetchingPollIntervalMilliseconds'] ??
                    30000)
                .toString();
        _primaryTeam.text =
            team['ExperimentalPrimaryTeam'] as String? ?? '';

        _samlLoginButtonColor.text =
            saml['LoginButtonColor'] as String? ?? '#2389D2';
        _samlLoginButtonBorderColor.text =
            saml['LoginButtonBorderColor'] as String? ?? '#2389D2';
        _samlLoginButtonTextColor.text =
            saml['LoginButtonTextColor'] as String? ?? '#FFFFFF';

        _useChannelInEmailNotifications =
            email['UseChannelInEmailNotifications'] as bool? ?? true;
        _userStatusAwayTimeout.text =
            (team['UserStatusAwayTimeout'] ?? 300).toString();

        _disableAppBar =
            experimental['DisableAppBar'] as bool? ?? false;
        _disableRefetchingOnBrowserFocus =
            experimental['DisableRefetchingOnBrowserFocus'] as bool? ?? false;
        _disableWakeUpReconnectHandler =
            experimental['DisableWakeUpReconnectHandler'] as bool? ?? false;
        _delayChannelAutocomplete =
            experimental['DelayChannelAutocomplete'] as bool? ?? false;
        _youtubeReferrerPolicy =
            experimental['YoutubeReferrerPolicy'] as bool? ?? false;
        _enableWatermark =
            experimental['EnableWatermark'] as bool? ?? false;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _trackChange(String key, dynamic value) {
    setState(() => _pendingChanges[key] = value);
  }

  Future<void> _save() async {
    final colors = AppTheme.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final patch = <String, dynamic>{
        'LdapSettings': {
          'LoginButtonColor': _ldapLoginButtonColor.text,
          'LoginButtonBorderColor': _ldapLoginButtonBorderColor.text,
          'LoginButtonTextColor': _ldapLoginButtonTextColor.text,
        },
        'ServiceSettings': {
          'ExperimentalEnableAuthenticationTransfer':
              _enableAuthenticationTransfer,
          'EnableChannelViewedMessages': _enableChannelViewedMessages,
          'ExperimentalEnableDefaultChannelLeaveJoinMessages':
              _enableDefaultChannelLeaveJoinMessages,
          'ExperimentalEnableHardenedMode': _enableHardenedMode,
          'EnableTutorial': _enableTutorial,
          'EnableOnboardingFlow': _enableOnboardingFlow,
          'EnableUserTypingMessages': _enableUserTypingMessages,
          'TimeBetweenUserTypingUpdatesMilliseconds':
              int.tryParse(_typingTimeout.text) ?? 5000,
        },
        'EmailSettings': {
          'EmailBatchingBufferSize':
              int.tryParse(_emailBatchingBufferSize.text) ?? 256,
          'EmailBatchingInterval':
              int.tryParse(_emailBatchingInterval.text) ?? 30,
          'LoginButtonColor': _emailLoginButtonColor.text,
          'LoginButtonBorderColor': _emailLoginButtonBorderColor.text,
          'LoginButtonTextColor': _emailLoginButtonTextColor.text,
          'UseChannelInEmailNotifications': _useChannelInEmailNotifications,
        },
        'TeamSettings': {
          'EnableUserDeactivation': _enableUserDeactivation,
          'ExperimentalEnableAutomaticReplies': _enableAutomaticReplies,
          'ExperimentalPrimaryTeam': _primaryTeam.text,
          'UserStatusAwayTimeout':
              int.tryParse(_userStatusAwayTimeout.text) ?? 300,
        },
        'ThemeSettings': {
          'EnableThemeSelection': _enableThemeSelection,
          'AllowCustomThemes': _allowCustomThemes,
          'DefaultTheme': _defaultTheme,
        },
        'ExperimentalSettings': {
          'LinkMetadataTimeoutMilliseconds':
              int.tryParse(_linkMetadataTimeout.text) ?? 5000,
          'UsersStatusAndProfileFetchingPollIntervalMilliseconds':
              int.tryParse(_profileFetchingPollInterval.text) ?? 30000,
          'DisableAppBar': _disableAppBar,
          'DisableRefetchingOnBrowserFocus': _disableRefetchingOnBrowserFocus,
          'DisableWakeUpReconnectHandler': _disableWakeUpReconnectHandler,
          'DelayChannelAutocomplete': _delayChannelAutocomplete,
          'YoutubeReferrerPolicy': _youtubeReferrerPolicy,
          'EnableWatermark': _enableWatermark,
        },
        'SamlSettings': {
          'LoginButtonColor': _samlLoginButtonColor.text,
          'LoginButtonBorderColor': _samlLoginButtonBorderColor.text,
          'LoginButtonTextColor': _samlLoginButtonTextColor.text,
        },
      };

      await _repository.patchConfig(patch);
      if (!mounted) return;
      setState(() => _pendingChanges.clear());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Experimental features settings saved'),
          backgroundColor: colors.onlineIndicator,
        ),
      );
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: colors.errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _ldapLoginButtonColor.dispose();
    _ldapLoginButtonBorderColor.dispose();
    _ldapLoginButtonTextColor.dispose();
    _linkMetadataTimeout.dispose();
    _emailBatchingBufferSize.dispose();
    _emailBatchingInterval.dispose();
    _emailLoginButtonColor.dispose();
    _emailLoginButtonBorderColor.dispose();
    _emailLoginButtonTextColor.dispose();
    _typingTimeout.dispose();
    _profileFetchingPollInterval.dispose();
    _primaryTeam.dispose();
    _samlLoginButtonColor.dispose();
    _samlLoginButtonBorderColor.dispose();
    _samlLoginButtonTextColor.dispose();
    _userStatusAwayTimeout.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(color: colors.buttonBg),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load settings: $_error',
                    style: TextStyle(color: colors.errorTextColor),
                  ),
                )
              : _buildForm(context),
        ),
        if (_pendingChanges.isNotEmpty)
          SaveChangesPanel(
            isSaving: _saving,
            onSave: _save,
            onCancel: () {
              setState(() => _pendingChanges.clear());
              _load();
            },
          ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = AppTheme.of(context);

    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, color: colors.buttonBg, size: 20),
          const SizedBox(width: 10),
          Text(
            'Experimental Features',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSettingSection(
            title: 'AD/LDAP Login Button Customization',
            subtitle:
                'Customize the appearance of the AD/LDAP login button on mobile apps.',
            children: [
              AdminSettingField(
                label: 'AD/LDAP Login Button Color',
                description:
                    'Specify the color of the AD/LDAP login button for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_ldapLoginButtonColor, (v) => _trackChange('ldapLoginButtonColor', v)),
              ),
              AdminSettingField(
                label: 'AD/LDAP Login Button Border Color',
                description:
                    'Specify the color of the AD/LDAP login button border for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_ldapLoginButtonBorderColor, (v) => _trackChange('ldapLoginButtonBorderColor', v)),
              ),
              AdminSettingField(
                label: 'AD/LDAP Login Button Text Color',
                description:
                    'Specify the color of the AD/LDAP login button text for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_ldapLoginButtonTextColor, (v) => _trackChange('ldapLoginButtonTextColor', v)),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Authentication',
            subtitle: 'Authentication and account settings.',
            children: [
              AdminSettingField(
                label: 'Allow Authentication Transfer',
                description:
                    'When true, users can change their sign-in method to any that is enabled on the server, either via their Profile or the APIs. When false, Users cannot change their sign-in method, regardless of which authentication options are enabled.',
                child: _toggle(
                  _enableAuthenticationTransfer,
                  (v) => setState(() {
                    _enableAuthenticationTransfer = v;
                    _trackChange('enableAuthenticationTransfer', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Enable Account Deactivation',
                description:
                    'When true, users may deactivate their own account from Settings > Advanced. If a user deactivates their own account, they will get an email notification confirming they were deactivated. When false, users may not deactivate their own account.',
                child: _toggle(
                  _enableUserDeactivation,
                  (v) => setState(() {
                    _enableUserDeactivation = v;
                    _trackChange('enableUserDeactivation', v);
                  }),
                ),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Link Metadata',
            subtitle: 'Settings for post link metadata.',
            children: [
              AdminSettingField(
                label: 'Link Metadata Timeout',
                description:
                    'The number of milliseconds to wait for metadata from a third-party link. Used with Post Metadata.',
                child: _numberField(_linkMetadataTimeout, (v) => _trackChange('linkMetadataTimeout', v)),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Email Batching',
            subtitle: 'Settings for batching email notifications.',
            children: [
              AdminSettingField(
                label: 'Email Batching Buffer Size',
                description:
                    'Specify the maximum number of notifications batched into a single email.',
                child: _numberField(_emailBatchingBufferSize, (v) => _trackChange('emailBatchingBufferSize', v)),
              ),
              AdminSettingField(
                label: 'Email Batching Interval',
                description:
                    'Specify the maximum frequency, in seconds, which the batching job checks for new notifications. Longer batching intervals will increase performance.',
                child: _numberField(_emailBatchingInterval, (v) => _trackChange('emailBatchingInterval', v)),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Email Login Button Customization',
            subtitle:
                'Customize the appearance of the email login button on mobile apps.',
            children: [
              AdminSettingField(
                label: 'Email Login Button Color',
                description:
                    'Specify the color of the email login button for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_emailLoginButtonColor, (v) => _trackChange('emailLoginButtonColor', v)),
              ),
              AdminSettingField(
                label: 'Email Login Button Border Color',
                description:
                    'Specify the color of the email login button border for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_emailLoginButtonBorderColor, (v) => _trackChange('emailLoginButtonBorderColor', v)),
              ),
              AdminSettingField(
                label: 'Email Login Button Text Color',
                description:
                    'Specify the color of the email login button text for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_emailLoginButtonTextColor, (v) => _trackChange('emailLoginButtonTextColor', v)),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Channel & Messaging',
            subtitle: 'Settings for channel messages and user interactions.',
            children: [
              AdminSettingField(
                label: 'Enable Channel Viewed WebSocket Messages',
                description:
                    'This setting determines whether channel_viewed WebSocket events are sent, which synchronize unread notifications across clients and devices. Disabling the setting in larger deployments may improve server performance.',
                child: _toggle(
                  _enableChannelViewedMessages,
                  (v) => setState(() {
                    _enableChannelViewedMessages = v;
                    _trackChange('enableChannelViewedMessages', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Enable Default Channel Leave/Join System Messages',
                description:
                    'This setting determines whether team leave/join system messages are posted in the default town-square channel.',
                child: _toggle(
                  _enableDefaultChannelLeaveJoinMessages,
                  (v) => setState(() {
                    _enableDefaultChannelLeaveJoinMessages = v;
                    _trackChange('enableDefaultChannelLeaveJoinMessages', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Enable User Typing Messages',
                description:
                    'This setting determines whether "user is typing..." messages are displayed below the message box. Disabling the setting in larger deployments may improve server performance.',
                child: _toggle(
                  _enableUserTypingMessages,
                  (v) => setState(() {
                    _enableUserTypingMessages = v;
                    _trackChange('enableUserTypingMessages', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'User Typing Timeout',
                description:
                    'The number of milliseconds to wait between emitting user typing websocket events.',
                child: _numberField(_typingTimeout, (v) => _trackChange('typingTimeout', v)),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Security',
            subtitle: 'Security-related experimental features.',
            children: [
              AdminSettingField(
                label: 'Enable Hardened Mode',
                description:
                    'Enables a hardened mode for Mattermost that makes user experience trade-offs in the interest of security.',
                child: _toggle(
                  _enableHardenedMode,
                  (v) => setState(() {
                    _enableHardenedMode = v;
                    _trackChange('enableHardenedMode', v);
                  }),
                ),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Theme',
            subtitle: 'Theme selection and customization settings.',
            children: [
              AdminSettingField(
                label: 'Enable Theme Selection',
                description:
                    'Enables the Display > Theme tab in Settings so users can select their theme.',
                child: _toggle(
                  _enableThemeSelection,
                  (v) => setState(() {
                    _enableThemeSelection = v;
                    _trackChange('enableThemeSelection', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Allow Custom Themes',
                description:
                    'Enables the Display > Theme > Custom Theme section in Settings.',
                child: _toggle(
                  _allowCustomThemes,
                  (v) => setState(() {
                    _allowCustomThemes = v;
                    _trackChange('allowCustomThemes', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Default Theme',
                description:
                    'Set a default theme that applies to all new users on the system.',
                child: _dropdown(
                  _defaultTheme,
                  const [
                    ('denim', 'Denim'),
                    ('sapphire', 'Sapphire'),
                    ('quartz', 'Quartz'),
                    ('indigo', 'Indigo'),
                    ('onyx', 'Onyx'),
                  ],
                  (v) => setState(() {
                    _defaultTheme = v;
                    _trackChange('defaultTheme', v);
                  }),
                ),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Onboarding & Tutorial',
            subtitle: 'Settings for new user onboarding experience.',
            children: [
              AdminSettingField(
                label: 'Enable Tutorial',
                description:
                    'When true, users are prompted with a tutorial when they open Mattermost for the first time after account creation. When false, the tutorial is disabled, and users are placed in Town Square when they open Mattermost for the first time after account creation.',
                child: _toggle(
                  _enableTutorial,
                  (v) => setState(() {
                    _enableTutorial = v;
                    _trackChange('enableTutorial', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Enable Onboarding',
                description:
                    'When true, new users are shown steps to complete as part of an onboarding process.',
                child: _toggle(
                  _enableOnboardingFlow,
                  (v) => setState(() {
                    _enableOnboardingFlow = v;
                    _trackChange('enableOnboardingFlow', v);
                  }),
                ),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'User Status & Profile',
            subtitle: 'Settings for user status and profile fetching.',
            children: [
              AdminSettingField(
                label: 'User Status and Profile Fetching Poll Interval',
                description:
                    'The number of milliseconds to wait between fetching user statuses and profiles periodically.',
                child: _numberField(_profileFetchingPollInterval, (v) => _trackChange('profileFetchingPollInterval', v)),
              ),
              AdminSettingField(
                label: 'Primary Team',
                description:
                    'The primary team of which users on the server are members. When a primary team is set, the options to join other teams or leave the primary team are disabled.',
                child: _textField(_primaryTeam, (v) => _trackChange('primaryTeam', v)),
              ),
              AdminSettingField(
                label: 'User Status Away Timeout',
                description:
                    'This setting defines the number of seconds after which the user\'s status indicator changes to "Away", when they are away from Mattermost.',
                child: _numberField(_userStatusAwayTimeout, (v) => _trackChange('userStatusAwayTimeout', v)),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'SAML Login Button Customization',
            subtitle:
                'Customize the appearance of the SAML login button on mobile apps.',
            children: [
              AdminSettingField(
                label: 'SAML Login Button Color',
                description:
                    'Specify the color of the SAML login button for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_samlLoginButtonColor, (v) => _trackChange('samlLoginButtonColor', v)),
              ),
              AdminSettingField(
                label: 'SAML Login Button Border Color',
                description:
                    'Specify the color of the SAML login button border for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_samlLoginButtonBorderColor, (v) => _trackChange('samlLoginButtonBorderColor', v)),
              ),
              AdminSettingField(
                label: 'SAML Login Button Text Color',
                description:
                    'Specify the color of the SAML login button text for white labeling purposes. Use a hex code with a #-sign before the code. This setting only applies to the mobile apps.',
                child: _colorField(_samlLoginButtonTextColor, (v) => _trackChange('samlLoginButtonTextColor', v)),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Email Notifications',
            subtitle: 'Settings for email notification content.',
            children: [
              AdminSettingField(
                label: 'Use Channel Name in Email Notifications',
                description:
                    'When true, channel and team name appears in email notification subject lines. Useful for servers using only one team. When false, only team name appears in email notification subject line.',
                child: _toggle(
                  _useChannelInEmailNotifications,
                  (v) => setState(() {
                    _useChannelInEmailNotifications = v;
                    _trackChange('useChannelInEmailNotifications', v);
                  }),
                ),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Integrations & Performance',
            subtitle:
                'Experimental settings for integrations and performance optimization.',
            children: [
              AdminSettingField(
                label: 'Disable Apps Bar',
                description:
                    'When false, all integrations move from the channel header to the Apps Bar. Channel header plugin icons that haven\'t explicitly registered an Apps Bar icon will be moved to the Apps Bar which may result in rendering issues.',
                child: _toggle(
                  _disableAppBar,
                  (v) => setState(() {
                    _disableAppBar = v;
                    _trackChange('disableAppBar', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Disable Data Refetching on Browser Refocus',
                description:
                    'When true, Mattermost will not refetch channels and channel members when the browser regains focus. This may result in improved performance for users with many channels and channel members.',
                child: _toggle(
                  _disableRefetchingOnBrowserFocus,
                  (v) => setState(() {
                    _disableRefetchingOnBrowserFocus = v;
                    _trackChange('disableRefetchingOnBrowserFocus', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Disable Wake Up Reconnect Handler',
                description:
                    'When true, Mattermost will not attempt to detect when the computer has woken up and refetch data. This might reduce the amount of regular network traffic the app is sending.',
                child: _toggle(
                  _disableWakeUpReconnectHandler,
                  (v) => setState(() {
                    _disableWakeUpReconnectHandler = v;
                    _trackChange('disableWakeUpReconnectHandler', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'Delay Channel Autocomplete',
                description:
                    'When true, the autocomplete for channel links (such as ~town-square) will only trigger after typing a tilde followed by a couple letters. When false, the autocomplete will appear as soon as the user types a tilde.',
                child: _toggle(
                  _delayChannelAutocomplete,
                  (v) => setState(() {
                    _delayChannelAutocomplete = v;
                    _trackChange('delayChannelAutocomplete', v);
                  }),
                ),
              ),
              AdminSettingField(
                label: 'YouTube Referrer Policy',
                description:
                    'When true, the referrer policy for embedded YouTube videos will be set to "strict-origin-when-cross-origin" which resolves issues where YouTube video previews display as unavailable. When false, the referrer policy will be set to "no-referrer" which enhances user privacy.',
                child: _toggle(
                  _youtubeReferrerPolicy,
                  (v) => setState(() {
                    _youtubeReferrerPolicy = v;
                    _trackChange('youtubeReferrerPolicy', v);
                  }),
                ),
              ),
            ],
          ),

          AdminSettingSection(
            title: 'Mobile',
            subtitle: 'Mobile-specific experimental features.',
            children: [
              AdminSettingField(
                label: 'Enable Mobile Watermark',
                description:
                    'When true, authenticated mobile sessions will display a watermark overlay showing the username, domain, date (YYYY-MM-DD), and time (HH:mm) for data loss prevention (DLP) purposes.',
                child: _toggle(
                  _enableWatermark,
                  (v) => setState(() {
                    _enableWatermark = v;
                    _trackChange('enableWatermark', v);
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Widget Helpers ───

  Switch _toggle(bool value, ValueChanged<bool> onChanged) {
    final colors = AppTheme.of(context);
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
    );
  }

  TextField _textField(
    TextEditingController controller,
    ValueChanged<String>? onChanged,
  ) {
    final colors = AppTheme.of(context);
    return TextField(
      controller: controller,
      style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.mentionHighlightBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  Widget _numberField(
    TextEditingController controller,
    ValueChanged<String>? onChanged,
  ) {
    final colors = AppTheme.of(context);
    return SizedBox(
      width: 140,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: colors.mentionHighlightBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colors.centerChannelColor.withValues(alpha: 0.12),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colors.centerChannelColor.withValues(alpha: 0.12),
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }

  Widget _colorField(
    TextEditingController controller,
    ValueChanged<String>? onChanged,
  ) {
    final colors = AppTheme.of(context);
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _parseHexColor(controller.text),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: colors.centerChannelColor.withValues(alpha: 0.24),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: '#FFFFFF',
              hintStyle: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.38),
                fontSize: 12,
              ),
              filled: true,
              fillColor: colors.mentionHighlightBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colors.centerChannelColor.withValues(alpha: 0.12),
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown(
    String value,
    List<(String, String)> options,
    ValueChanged<String> onChanged,
  ) {
    final colors = AppTheme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: colors.mentionHighlightBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.12),
        ),
      ),
      child: DropdownButton<String>(
        value: options.any((o) => o.$1 == value) ? value : options.first.$1,
        dropdownColor: colors.mentionHighlightBg,
        underline: const SizedBox(),
        isExpanded: true,
        style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
        onChanged: (v) {
          if (v != null) onChanged(v);
        },
        items: options.map((opt) {
          return DropdownMenuItem<String>(
            value: opt.$1,
            child: Text(opt.$2),
          );
        }).toList(),
      ),
    );
  }

  Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) {
        return Color(int.parse('FF$clean', radix: 16));
      }
    } catch (_) {}
    return Colors.blueAccent;
  }
}
