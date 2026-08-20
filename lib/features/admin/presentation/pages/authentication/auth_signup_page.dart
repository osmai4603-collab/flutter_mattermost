import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة إعدادات التسجيل (Signup Settings Page)
/// تتيح للمسؤولين التحكم في إنشاء الحسابات، تقييد النطاقات، والسيرفر المفتوح.
class AdminConsoleAuthSignupPage extends StatefulWidget {
  const AdminConsoleAuthSignupPage({super.key});

  @override
  State<AdminConsoleAuthSignupPage> createState() =>
      _AdminConsoleAuthSignupPageState();
}

class _AdminConsoleAuthSignupPageState
    extends State<AdminConsoleAuthSignupPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _enableUserCreation = true;
  bool _enableOpenServer = true;
  bool _enableEmailInvitations = true;
  final TextEditingController _restrictDomainsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final teamSettings =
          (config['TeamSettings'] as Map<String, dynamic>?) ?? const {};
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _enableUserCreation = teamSettings['EnableUserCreation'] as bool? ?? true;
      _enableOpenServer = teamSettings['EnableOpenServer'] as bool? ?? true;
      _enableEmailInvitations =
          serviceSettings['EnableEmailInvitations'] as bool? ?? true;
      _restrictDomainsController.text =
          teamSettings['RestrictCreationToDomains'] as String? ?? '';
    } catch (_) {
      // الابقاء على القيم الافتراضية عند عدم توفر الخادم
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
        'TeamSettings': {
          'EnableUserCreation': _enableUserCreation,
          'EnableOpenServer': _enableOpenServer,
          'RestrictCreationToDomains': _restrictDomainsController.text.trim(),
        },
        'ServiceSettings': {'EnableEmailInvitations': _enableEmailInvitations},
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Signup settings saved successfully'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
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
    _restrictDomainsController.dispose();
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
              'Sign Up',
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
                  // Settings Card Container
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
                        // Enable User Creation Toggle
                        SwitchListTile(
                          value: _enableUserCreation,
                          onChanged: (val) =>
                              setState(() => _enableUserCreation = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Account Creation',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When false, account creation is disabled across email and OAuth signups.',
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

                        // Enable Open Server Toggle
                        SwitchListTile(
                          value: _enableOpenServer,
                          onChanged: (val) =>
                              setState(() => _enableOpenServer = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Open Server',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, anyone can sign up for a user account without needing an invitation.',
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

                        // Enable Email Invitations Toggle
                        SwitchListTile(
                          value: _enableEmailInvitations,
                          onChanged: (val) =>
                              setState(() => _enableEmailInvitations = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Email Invitations',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, users can send email invitations to join teams and channels.',
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

                        // Restrict Domains Input
                        Text(
                          'Restrict Account Creation to Specified Email Domains:',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _restrictDomainsController,
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'e.g. corp.mattermost.com, mattermost.com',
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
                        const SizedBox(height: 4),
                        Text(
                          'Comma-separated list of domain names required for new signups.',
                          style: TextStyle(
                            color: colors.centerChannelColor.withValues(
                              alpha: 0.54,
                            ),
                            fontSize: 11,
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
