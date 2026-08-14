import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
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
      final gitlab = (config['GitLabSettings'] as Map<String, dynamic>?) ?? const {};
      final google = (config['GoogleSettings'] as Map<String, dynamic>?) ?? const {};
      final o365 = (config['Office365Settings'] as Map<String, dynamic>?) ?? const {};

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OAuth / OpenID settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save OAuth settings: $e'),
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
    _clientIdController.dispose();
    _clientSecretController.dispose();
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
                            'OpenID Connect & OAuth 2.0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure Single Sign-On using OAuth 2.0 / OpenID providers (GitLab, Google, Entra ID).',
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

                  // Settings Card
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
                        const Text(
                          'Select OAuth 2.0 Service Provider:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF212433),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _oauthType,
                              dropdownColor: const Color(0xFF212433),
                              isExpanded: true,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                              items: const [
                                DropdownMenuItem(value: 'off', child: Text('Do not allow sign-in via OAuth 2.0')),
                                DropdownMenuItem(value: 'gitlab', child: Text('GitLab SSO')),
                                DropdownMenuItem(value: 'google', child: Text('Google Apps SSO')),
                                DropdownMenuItem(value: 'office365', child: Text('Entra ID / Office 365 SSO')),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _oauthType = val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (_oauthType != 'off') ...[
                          const Text('Client ID (Application ID):', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _clientIdController,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Enter OAuth Client ID from provider console',
                              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                              filled: true,
                              fillColor: const Color(0xFF212433),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                            ),
                          ),
                          const SizedBox(height: 16),

                          const Text('Client Secret (Application Secret):', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _clientSecretController,
                            obscureText: true,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            decoration: InputDecoration(
                              hintText: '••••••••••••••••',
                              hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                              filled: true,
                              fillColor: const Color(0xFF212433),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
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
