import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة إعدادات المصادقة الموحدة SAML 2.0 (SAML 2.0 Authentication Page)
class AdminConsoleAuthSamlPage extends StatefulWidget {
  const AdminConsoleAuthSamlPage({super.key});

  @override
  State<AdminConsoleAuthSamlPage> createState() =>
      _AdminConsoleAuthSamlPageState();
}

class _AdminConsoleAuthSamlPageState extends State<AdminConsoleAuthSamlPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _enableSaml = false;
  final TextEditingController _idpMetadataUrlController = TextEditingController();
  final TextEditingController _idpSsoUrlController = TextEditingController();
  final TextEditingController _emailAttrController = TextEditingController(text: 'Email');
  final TextEditingController _usernameAttrController = TextEditingController(text: 'Username');

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final samlSettings =
          (config['SamlSettings'] as Map<String, dynamic>?) ?? const {};

      _enableSaml = samlSettings['Enable'] as bool? ?? false;
      _idpMetadataUrlController.text =
          samlSettings['IdpMetadataURL'] as String? ?? '';
      _idpSsoUrlController.text = samlSettings['IdpURL'] as String? ?? '';
      _emailAttrController.text =
          samlSettings['EmailAttribute'] as String? ?? 'Email';
      _usernameAttrController.text =
          samlSettings['UsernameAttribute'] as String? ?? 'Username';
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
        'SamlSettings': {
          'Enable': _enableSaml,
          'IdpMetadataURL': _idpMetadataUrlController.text.trim(),
          'IdpURL': _idpSsoUrlController.text.trim(),
          'EmailAttribute': _emailAttrController.text.trim(),
          'UsernameAttribute': _usernameAttrController.text.trim(),
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('SAML 2.0 settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save SAML 2.0 settings: $e'),
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
    _idpMetadataUrlController.dispose();
    _idpSsoUrlController.dispose();
    _emailAttrController.dispose();
    _usernameAttrController.dispose();
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
                            'SAML 2.0 Single Sign-On',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Configure SAML 2.0 enterprise single sign-on (Okta, PingIdentity, OneLogin, ADFS).',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.purpleAccent.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.4)),
                            ),
                            child: const Text(
                              'ENT',
                              style: TextStyle(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
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
                        SwitchListTile(
                          value: _enableSaml,
                          onChanged: (val) => setState(() => _enableSaml = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Login With SAML 2.0',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, users can sign in using enterprise SAML 2.0 Single Sign-On.',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),

                        // IdP Metadata URL
                        const Text('Identity Provider Metadata URL:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _idpMetadataUrlController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'e.g. https://idp.example.org/SAML2/saml/metadata',
                            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFF212433),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // IdP SSO URL
                        const Text('SAML SSO URL:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _idpSsoUrlController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'e.g. https://idp.example.org/SAML2/SSO/Login',
                            hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                            filled: true,
                            fillColor: const Color(0xFF212433),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email & Username Attributes
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Email Attribute:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _emailAttrController,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: 'e.g. Email',
                                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                                      filled: true,
                                      fillColor: const Color(0xFF212433),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Username Attribute:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _usernameAttrController,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: 'e.g. Username',
                                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
                                      filled: true,
                                      fillColor: const Color(0xFF212433),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
