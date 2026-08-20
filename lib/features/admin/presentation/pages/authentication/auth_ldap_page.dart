import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة إعدادات دليل AD/LDAP (AD/LDAP Authentication Page)
class AdminConsoleAuthLdapPage extends StatefulWidget {
  const AdminConsoleAuthLdapPage({super.key});

  @override
  State<AdminConsoleAuthLdapPage> createState() =>
      _AdminConsoleAuthLdapPageState();
}

class _AdminConsoleAuthLdapPageState extends State<AdminConsoleAuthLdapPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _enableLdap = false;
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _portController = TextEditingController(
    text: '389',
  );
  final TextEditingController _bindUserController = TextEditingController();
  final TextEditingController _bindPasswordController = TextEditingController();
  final TextEditingController _baseDnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final ldapSettings =
          (config['LdapSettings'] as Map<String, dynamic>?) ?? const {};

      _enableLdap = ldapSettings['Enable'] as bool? ?? false;
      _serverController.text = ldapSettings['LdapServer'] as String? ?? '';
      _portController.text =
          (ldapSettings['LdapPort'] as num?)?.toString() ?? '389';
      _bindUserController.text = ldapSettings['BindUsername'] as String? ?? '';
      _baseDnController.text = ldapSettings['BaseDN'] as String? ?? '';
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
        'LdapSettings': {
          'Enable': _enableLdap,
          'LdapServer': _serverController.text.trim(),
          'LdapPort': int.tryParse(_portController.text) ?? 389,
          'BindUsername': _bindUserController.text.trim(),
          'BindPassword': _bindPasswordController.text,
          'BaseDN': _baseDnController.text.trim(),
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('AD/LDAP settings saved successfully'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save AD/LDAP settings: $e'),
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
    _serverController.dispose();
    _portController.dispose();
    _bindUserController.dispose();
    _bindPasswordController.dispose();
    _baseDnController.dispose();
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
              'AD/LDAP',
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
                          value: _enableLdap,
                          onChanged: (val) => setState(() => _enableLdap = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Enable Login With AD/LDAP',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'When true, Mattermost allows login using AD/LDAP credentials.',
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

                        // Server & Port Row
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AD/LDAP Server:',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _serverController,
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'e.g. ldap.example.com',
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
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Port:',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _portController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '389 / 636',
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
                        const SizedBox(height: 16),

                        // Bind Username & Password
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Bind Username:',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _bindUserController,
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          'e.g. cn=admin,dc=example,dc=com',
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
                                    'Bind Password:',
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _bindPasswordController,
                                    obscureText: true,
                                    style: TextStyle(
                                      color: colors.centerChannelColor,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
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
                        const SizedBox(height: 16),

                        // Base DN
                        Text(
                          'Base DN:',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _baseDnController,
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'e.g. ou=Users,dc=example,dc=com',
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
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
