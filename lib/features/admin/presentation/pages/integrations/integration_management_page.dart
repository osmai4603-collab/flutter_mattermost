import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class IntegrationManagementPage extends StatefulWidget {
  const IntegrationManagementPage({super.key});

  @override
  State<IntegrationManagementPage> createState() =>
      _IntegrationManagementPageState();
}

class _IntegrationManagementPageState extends State<IntegrationManagementPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  // Webhooks & Commands
  bool _enableIncomingWebhooks = false;
  bool _enableOutgoingWebhooks = false;
  bool _enableOutgoingOAuthConnections = false;
  bool _enableCustomSlashCommands = false;

  // OAuth
  bool _enableOAuthServiceProvider = false;
  bool _enableDynamicClientRegistration = false;
  final TextEditingController _dcrRedirectURIAllowlistController =
      TextEditingController();

  // Timeouts & Overrides
  final TextEditingController _integrationRequestTimeoutController =
      TextEditingController();
  bool _enablePostUsernameOverride = false;
  bool _enablePostIconOverride = false;

  // Personal Access Tokens
  bool _enableUserAccessTokens = false;
  final TextEditingController _maxTokenLifetimeController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _dcrRedirectURIAllowlistController.dispose();
    _integrationRequestTimeoutController.dispose();
    _maxTokenLifetimeController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _enableIncomingWebhooks =
          serviceSettings['EnableIncomingWebhooks'] == true;
      _enableOutgoingWebhooks =
          serviceSettings['EnableOutgoingWebhooks'] == true;
      _enableOutgoingOAuthConnections =
          serviceSettings['EnableOutgoingOAuthConnections'] == true;
      _enableCustomSlashCommands = serviceSettings['EnableCommands'] == true;
      _enableOAuthServiceProvider =
          serviceSettings['EnableOAuthServiceProvider'] == true;
      _enableDynamicClientRegistration =
          serviceSettings['EnableDynamicClientRegistration'] == true;
      _dcrRedirectURIAllowlistController.text =
          (serviceSettings['DCRRedirectURIAllowlist'] as String?) ?? '';
      _integrationRequestTimeoutController.text =
          (serviceSettings['OutgoingIntegrationRequestsTimeout']?.toString()) ??
          '30';
      _enablePostUsernameOverride =
          serviceSettings['EnablePostUsernameOverride'] == true;
      _enablePostIconOverride =
          serviceSettings['EnablePostIconOverride'] == true;
      _enableUserAccessTokens =
          serviceSettings['EnableUserAccessTokens'] == true;
      _maxTokenLifetimeController.text =
          (serviceSettings['MaximumPersonalAccessTokenLifetimeDays']
              ?.toString()) ??
          '0';
    } catch (_) {
      // Keep defaults
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
          'EnableIncomingWebhooks': _enableIncomingWebhooks,
          'EnableOutgoingWebhooks': _enableOutgoingWebhooks,
          'EnableOutgoingOAuthConnections': _enableOutgoingOAuthConnections,
          'EnableCommands': _enableCustomSlashCommands,
          'EnableOAuthServiceProvider': _enableOAuthServiceProvider,
          'EnableDynamicClientRegistration': _enableDynamicClientRegistration,
          'DCRRedirectURIAllowlist': _dcrRedirectURIAllowlistController.text
              .trim(),
          'OutgoingIntegrationRequestsTimeout':
              int.tryParse(_integrationRequestTimeoutController.text.trim()) ??
              30,
          'EnablePostUsernameOverride': _enablePostUsernameOverride,
          'EnablePostIconOverride': _enablePostIconOverride,
          'EnableUserAccessTokens': _enableUserAccessTokens,
          'MaximumPersonalAccessTokenLifetimeDays':
              int.tryParse(_maxTokenLifetimeController.text.trim()) ?? 0,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Integration Management settings saved'),
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
              'Integration Management',
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
                  _buildWebhooksSection(colors),
                  const SizedBox(height: 20),
                  _buildOAuthSection(colors),
                  const SizedBox(height: 20),
                  _buildTimeoutSection(colors),
                  const SizedBox(height: 20),
                  _buildOverridesSection(colors),
                  const SizedBox(height: 20),
                  _buildPersonalAccessTokensSection(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildWebhooksSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableIncomingWebhooks,
          onChanged: (v) {
            if (v != null) setState(() => _enableIncomingWebhooks = v);
          },
          title: 'Enable Incoming Webhooks',
          subtitle:
              'When true, incoming webhooks will be allowed. To help combat phishing attacks, all posts from webhooks will be labelled by a BOT tag.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableOutgoingWebhooks,
          onChanged: (v) {
            if (v != null) setState(() => _enableOutgoingWebhooks = v);
          },
          title: 'Enable Outgoing Webhooks',
          subtitle: 'When true, outgoing webhooks will be allowed.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableOutgoingOAuthConnections,
          onChanged: (v) {
            if (v != null) {
              setState(() => _enableOutgoingOAuthConnections = v);
            }
          },
          title: 'Enable Outgoing OAuth Connections',
          subtitle:
              'When true, outgoing webhooks and slash commands will use set up OAuth connections to authenticate with third party services.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableCustomSlashCommands,
          onChanged: (v) {
            if (v != null) setState(() => _enableCustomSlashCommands = v);
          },
          title: 'Enable Custom Slash Commands',
          subtitle: 'When true, custom slash commands will be allowed.',
        ),
      ],
    );
  }

  Widget _buildOAuthSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableOAuthServiceProvider,
          onChanged: (v) {
            if (v != null) setState(() => _enableOAuthServiceProvider = v);
          },
          title: 'Enable OAuth 2.0 Service Provider',
          subtitle:
              'When true, Mattermost can act as an OAuth 2.0 service provider allowing Mattermost to authorize API requests from external applications.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableDynamicClientRegistration,
          onChanged: _enableOAuthServiceProvider
              ? (v) {
                  if (v != null) {
                    setState(() => _enableDynamicClientRegistration = v);
                  }
                }
              : null,
          title: 'Enable OAuth 2.0 Dynamic Client Registration',
          subtitle:
              'When true, external applications can dynamically register as OAuth 2.0 clients with Mattermost. Only enable this if you need third-party applications to register OAuth clients programmatically.',
        ),
        if (_enableOAuthServiceProvider &&
            _enableDynamicClientRegistration) ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _dcrRedirectURIAllowlistController,
            title: 'DCR Redirect URI Allowlist',
            subtitle:
                'When Dynamic Client Registration is enabled, optionally restrict which redirect URIs can be registered. Enter comma-separated URL glob patterns (e.g. https://*.example.com/**). If empty, all valid redirect URIs are allowed.',
            placeholder:
                'E.g.: https://*.example.com/**, https://app.example.com/callback',
          ),
        ],
      ],
    );
  }

  Widget _buildTimeoutSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _integrationRequestTimeoutController,
          title: 'Integration Request Timeout (seconds)',
          subtitle:
              'The number of seconds to wait for Integration requests. That includes Slash Commands, Outgoing Webhooks, Interactive Messages and Interactive Dialogs.',
          placeholder: '30',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildOverridesSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enablePostUsernameOverride,
          onChanged: (v) {
            if (v != null) setState(() => _enablePostUsernameOverride = v);
          },
          title: 'Enable integrations to override usernames',
          subtitle:
              'When true, webhooks, slash commands and other integrations will be allowed to change the username they are posting as. Note: Combined with allowing integrations to override profile picture icons, users may be able to perform phishing attacks by attempting to impersonate other users.',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enablePostIconOverride,
          onChanged: (v) {
            if (v != null) setState(() => _enablePostIconOverride = v);
          },
          title: 'Enable integrations to override profile picture icons',
          subtitle:
              'When true, webhooks, slash commands and other integrations will be allowed to change the profile picture they post with. Note: Combined with allowing integrations to override usernames, users may be able to perform phishing attacks by attempting to impersonate other users.',
        ),
      ],
    );
  }

  Widget _buildPersonalAccessTokensSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableUserAccessTokens,
          onChanged: (v) {
            if (v != null) setState(() => _enableUserAccessTokens = v);
          },
          title: 'Enable Personal Access Tokens',
          subtitle:
              'When true, users can create personal access tokens for integrations in Profile > Security. They can be used to authenticate against the API and give full access to the account. To manage who can create personal access tokens or to search users by token ID, go to System Console > User Management > Users.',
        ),
        if (_enableUserAccessTokens) ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _maxTokenLifetimeController,
            title: 'Maximum Personal Access Token Lifetime (days)',
            subtitle:
                'The maximum number of days a personal access token can remain valid before it expires. Set to 0 to allow tokens that never expire. When set to a positive value, users must select an expiry date within this range when creating a token.',
            placeholder: '0',
            keyboardType: TextInputType.number,
          ),
        ],
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
}
