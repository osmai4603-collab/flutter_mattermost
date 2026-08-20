import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة مصادقة البريد الإلكتروني (Email Authentication Page)
class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _enableSignUpWithEmail = true;
  bool _requireEmailVerification = true;
  bool _enableSignInWithEmail = true;
  bool _enableSignInWithUsername = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final emailSettings =
          (config['EmailSettings'] as Map<String, dynamic>?) ?? const {};

      _enableSignUpWithEmail =
          emailSettings['EnableSignUpWithEmail'] as bool? ?? true;
      _requireEmailVerification =
          emailSettings['RequireEmailVerification'] as bool? ?? true;
      _enableSignInWithEmail =
          emailSettings['EnableSignInWithEmail'] as bool? ?? true;
      _enableSignInWithUsername =
          emailSettings['EnableSignInWithUsername'] as bool? ?? true;
    } catch (_) {
      // الاحتفاظ بالقيم الافتراضية
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveConfig() async {
    final colors = AppTheme.of(context);
    setState(() => _isSaving = true);
    try {
      final patch = {
        'EmailSettings': {
          'EnableSignUpWithEmail': _enableSignUpWithEmail,
          'RequireEmailVerification': _requireEmailVerification,
          'EnableSignInWithEmail': _enableSignInWithEmail,
          'EnableSignInWithUsername': _enableSignInWithUsername,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Email authentication settings saved'),
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
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
              'Email',
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
                  // Settings Form Container
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
                          value: _enableSignUpWithEmail,
                          onChanged: (val) =>
                              setState(() => _enableSignUpWithEmail = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Account Creation with Email',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, users can register new accounts using email and password.',
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
                          value: _requireEmailVerification,
                          onChanged: (val) =>
                              setState(() => _requireEmailVerification = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Require Email Verification',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, users must verify their email address before logging in.',
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
                          value: _enableSignInWithEmail,
                          onChanged: (val) =>
                              setState(() => _enableSignInWithEmail = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Sign-in with Email',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Allow users to log in using their email address.',
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
                          value: _enableSignInWithUsername,
                          onChanged: (val) =>
                              setState(() => _enableSignInWithUsername = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Sign-in with Username',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Allow users to log in using their username.',
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
