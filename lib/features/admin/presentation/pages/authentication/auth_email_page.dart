import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
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
          const SnackBar(
            content: Text('Email authentication settings saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: Colors.redAccent,
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
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Title & Save Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Email Authentication',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure email and username sign-in options.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveConfig,
                        icon: _isSaving
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_rounded, size: 18),
                        label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
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
                  const SizedBox(height: 24),

                  // Settings Form Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      children: [
                        SwitchListTile(
                          value: _enableSignUpWithEmail,
                          onChanged: (val) =>
                              setState(() => _enableSignUpWithEmail = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Account Creation with Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, users can register new accounts using email and password.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        SwitchListTile(
                          value: _requireEmailVerification,
                          onChanged: (val) =>
                              setState(() => _requireEmailVerification = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Require Email Verification',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, users must verify their email address before logging in.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        SwitchListTile(
                          value: _enableSignInWithEmail,
                          onChanged: (val) =>
                              setState(() => _enableSignInWithEmail = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Sign-in with Email',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'Allow users to log in using their email address.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        SwitchListTile(
                          value: _enableSignInWithUsername,
                          onChanged: (val) =>
                              setState(() => _enableSignInWithUsername = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Sign-in with Username',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'Allow users to log in using their username.',
                            style: TextStyle(
                              color: Colors.white54,
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
