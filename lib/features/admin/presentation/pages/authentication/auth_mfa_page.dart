import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة المصادقة المتعددة العوامل (MFA Settings Page)
class AdminConsoleAuthMfaPage extends StatefulWidget {
  const AdminConsoleAuthMfaPage({super.key});

  @override
  State<AdminConsoleAuthMfaPage> createState() =>
      _AdminConsoleAuthMfaPageState();
}

class _AdminConsoleAuthMfaPageState extends State<AdminConsoleAuthMfaPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _enableMfa = true;
  bool _enforceMfa = false;

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

      _enableMfa =
          serviceSettings['EnableMultifactorAuthentication'] as bool? ?? true;
      _enforceMfa =
          serviceSettings['EnforceMultifactorAuthentication'] as bool? ?? false;
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
        'ServiceSettings': {
          'EnableMultifactorAuthentication': _enableMfa,
          'EnforceMultifactorAuthentication': _enforceMfa,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('MFA settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save MFA settings: $e'),
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
                            'Multi-factor Authentication (MFA)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure TOTP multi-factor authentication for email and AD/LDAP logins.',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
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

                  // Info Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.vibration_rounded, color: Colors.blueAccent, size: 24),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Multi-factor authentication adds an extra layer of security using Google Authenticator, Authy, or compatible TOTP apps.',
                            style: TextStyle(color: Colors.white70, fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings Card
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
                          value: _enableMfa,
                          onChanged: (val) => setState(() {
                            _enableMfa = val;
                            if (!val) _enforceMfa = false;
                          }),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Multi-factor Authentication',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, users with email or AD/LDAP login can add MFA to their account.',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        SwitchListTile(
                          value: _enforceMfa,
                          onChanged: _enableMfa
                              ? (val) => setState(() => _enforceMfa = val)
                              : null,
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enforce Multi-factor Authentication',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, MFA is mandatory. Users will be required to setup MFA upon logging in.',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
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
