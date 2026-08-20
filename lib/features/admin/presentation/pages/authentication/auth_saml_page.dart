import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
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
  final TextEditingController _idpMetadataUrlController =
      TextEditingController();
  final TextEditingController _idpSsoUrlController = TextEditingController();
  final TextEditingController _emailAttrController = TextEditingController(
    text: 'Email',
  );
  final TextEditingController _usernameAttrController = TextEditingController(
    text: 'Username',
  );

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
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('SAML 2.0 settings saved successfully'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save SAML 2.0 settings: $e'),
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
    _idpMetadataUrlController.dispose();
    _idpSsoUrlController.dispose();
    _emailAttrController.dispose();
    _usernameAttrController.dispose();
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
              'SAML',
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
                        SwitchListTile(
                          value: _enableSaml,
                          onChanged: (val) => setState(() => _enableSaml = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Login With SAML 2.0',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, users can sign in using enterprise SAML 2.0 Single Sign-On.',
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

                        // IdP Metadata URL
                        Text(
                          'Identity Provider Metadata URL:',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _idpMetadataUrlController,
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'e.g. https://idp.example.org/SAML2/saml/metadata',
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

                        // IdP SSO URL
                        Text(
                          'SAML SSO URL:',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _idpSsoUrlController,
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'e.g. https://idp.example.org/SAML2/SSO/Login',
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

                        // Email & Username Attributes
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email Attribute:',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _emailAttrController,
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'e.g. Email',
                                      hintStyle: TextStyle(
                                        color: colors.centerChannelColor
                                            .withValues(alpha: 0.38),
                                        fontSize: 13,
                                      ),
                                      filled: true,
                                      fillColor: colors.centerChannelBg
                                          .withValues(alpha: 0.60),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
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
                                  Text(
                                    'Username Attribute:',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _usernameAttrController,
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'e.g. Username',
                                      hintStyle: TextStyle(
                                        color: colors.centerChannelColor
                                            .withValues(alpha: 0.38),
                                        fontSize: 13,
                                      ),
                                      filled: true,
                                      fillColor: colors.centerChannelBg
                                          .withValues(alpha: 0.60),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide.none,
                                      ),
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
