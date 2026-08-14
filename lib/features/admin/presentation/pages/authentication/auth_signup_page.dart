import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
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

      _enableUserCreation =
          teamSettings['EnableUserCreation'] as bool? ?? true;
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
        'ServiceSettings': {
          'EnableEmailInvitations': _enableEmailInvitations,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signup settings saved successfully'),
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
  void dispose() {
    _restrictDomainsController.dispose();
    super.dispose();
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
                            'Signup Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure how users create accounts and sign up to your server.',
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

                  // Settings Card Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF161922),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Enable User Creation Toggle
                        SwitchListTile(
                          value: _enableUserCreation,
                          onChanged: (val) =>
                              setState(() => _enableUserCreation = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Account Creation',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When false, account creation is disabled across email and OAuth signups.',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),

                        // Enable Open Server Toggle
                        SwitchListTile(
                          value: _enableOpenServer,
                          onChanged: (val) =>
                              setState(() => _enableOpenServer = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Open Server',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, anyone can sign up for a user account without needing an invitation.',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),

                        // Enable Email Invitations Toggle
                        SwitchListTile(
                          value: _enableEmailInvitations,
                          onChanged: (val) =>
                              setState(() => _enableEmailInvitations = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Email Invitations',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, users can send email invitations to join teams and channels.',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),

                        // Restrict Domains Input
                        const Text(
                          'Restrict Account Creation to Specified Email Domains:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _restrictDomainsController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'e.g. corp.mattermost.com, mattermost.com',
                            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFF212433),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Comma-separated list of domain names required for new signups.',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
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
