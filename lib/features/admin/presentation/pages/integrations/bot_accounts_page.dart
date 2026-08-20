import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class BotAccountsPage extends StatefulWidget {
  const BotAccountsPage({super.key});

  @override
  State<BotAccountsPage> createState() => _BotAccountsPageState();
}

class _BotAccountsPageState extends State<BotAccountsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableBotAccountCreation = false;
  bool _disableBotsWhenOwnerIsDeactivated = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _enableBotAccountCreation =
          serviceSettings['EnableBotAccountCreation'] == true;
      _disableBotsWhenOwnerIsDeactivated =
          serviceSettings['DisableBotsWhenOwnerIsDeactivated'] == true;
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
          'EnableBotAccountCreation': _enableBotAccountCreation,
          'DisableBotsWhenOwnerIsDeactivated':
              _disableBotsWhenOwnerIsDeactivated,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bot Accounts settings saved'),
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
              'Bot Accounts',
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
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bot Accounts',
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manage bot account creation and deactivation policies.',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.54,
                                ),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Settings
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.centerChannelBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.10,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: _enableBotAccountCreation,
                          onChanged: (v) =>
                              setState(() => _enableBotAccountCreation = v),
                          activeThumbColor: colors.buttonBg,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Enable Bot Account Creation',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, System Admins can create bot accounts for integrations in Integrations > Bot Accounts. Bot accounts are similar to user accounts except they cannot be used to log in.',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.54,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Divider(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.10,
                          ),
                          height: 24,
                        ),
                        SwitchListTile(
                          value: _disableBotsWhenOwnerIsDeactivated,
                          onChanged: (v) => setState(
                            () => _disableBotsWhenOwnerIsDeactivated = v,
                          ),
                          activeThumbColor: colors.buttonBg,
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Disable bot accounts when owner is deactivated',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When a user is deactivated, disables all bot accounts managed by the user. To re-enable bot accounts, go to Integrations > Bot Accounts.',
                            style: TextStyle(
                              color: colors.centerChannelColor.withValues(
                                alpha: 0.54,
                              ),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
