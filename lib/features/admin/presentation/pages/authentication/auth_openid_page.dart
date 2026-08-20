import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة إعدادات OpenID Connect / OAuth 2.0 (OAuth Settings Page)
class AdminConsoleAuthOpenIdPage extends StatefulWidget {
  const AdminConsoleAuthOpenIdPage({super.key});

  @override
  State<AdminConsoleAuthOpenIdPage> createState() =>
      _AdminConsoleAuthOpenIdPageState();
}

class _AdminConsoleAuthOpenIdPageState
    extends State<AdminConsoleAuthOpenIdPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  String _oauthType = 'off';
  final TextEditingController _clientIdController = TextEditingController();
  final TextEditingController _clientSecretController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final gitlab =
          (config['GitLabSettings'] as Map<String, dynamic>?) ?? const {};
      final google =
          (config['GoogleSettings'] as Map<String, dynamic>?) ?? const {};
      final o365 =
          (config['Office365Settings'] as Map<String, dynamic>?) ?? const {};

      if (gitlab['Enable'] == true) {
        _oauthType = 'gitlab';
        _clientIdController.text = gitlab['Id'] as String? ?? '';
      } else if (google['Enable'] == true) {
        _oauthType = 'google';
        _clientIdController.text = google['Id'] as String? ?? '';
      } else if (o365['Enable'] == true) {
        _oauthType = 'office365';
        _clientIdController.text = o365['Id'] as String? ?? '';
      } else {
        _oauthType = 'off';
      }
    } catch (_) {
      // الاحتفاظ بالقيم الافتراضية
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      final patch = {
        'GitLabSettings': {
          'Enable': _oauthType == 'gitlab',
          if (_oauthType == 'gitlab') 'Id': _clientIdController.text.trim(),
          if (_oauthType == 'gitlab') 'Secret': _clientSecretController.text,
        },
        'GoogleSettings': {
          'Enable': _oauthType == 'google',
          if (_oauthType == 'google') 'Id': _clientIdController.text.trim(),
          if (_oauthType == 'google') 'Secret': _clientSecretController.text,
        },
        'Office365Settings': {
          'Enable': _oauthType == 'office365',
          if (_oauthType == 'office365') 'Id': _clientIdController.text.trim(),
          if (_oauthType == 'office365') 'Secret': _clientSecretController.text,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('OAuth / OpenID settings saved successfully'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save OAuth settings: $e'),
            backgroundColor: colors.errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _clientIdController.dispose();
    _clientSecretController.dispose();
    super.dispose();
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
              'OpenID Connect',
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
                  // Settings Card
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select OAuth 2.0 Service Provider:',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: colors.centerChannelBg.withValues(
                              alpha: 0.60,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _oauthType,
                              dropdownColor: colors.centerChannelBg.withValues(
                                alpha: 0.60,
                              ),
                              isExpanded: true,
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 13,
                              ),
                              items: [
                                DropdownMenuItem(
                                  value: 'off',
                                  child: Text(
                                    'Do not allow sign-in via OAuth 2.0',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'gitlab',
                                  child: Text(
                                    'GitLab SSO',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'google',
                                  child: Text(
                                    'Google Apps SSO',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'office365',
                                  child: Text(
                                    'Entra ID / Office 365 SSO',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null)
                                  setState(() => _oauthType = val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (_oauthType != 'off') ...[
                          Text(
                            'Client ID (Application ID):',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _clientIdController,
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  'Enter OAuth Client ID from provider console',
                              hintStyle: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.38,
                                ),
                                fontSize: 13,
                              ),
                              filled: true,
                              fillColor: colors.centerChannelBg.withValues(
                                alpha: 0.60,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Text(
                            'Client Secret (Application Secret):',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _clientSecretController,
                            obscureText: true,
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••••••••••',
                              hintStyle: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.38,
                                ),
                                fontSize: 13,
                              ),
                              filled: true,
                              fillColor: colors.centerChannelBg.withValues(
                                alpha: 0.60,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
