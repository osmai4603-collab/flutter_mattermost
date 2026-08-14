import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
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
  final TextEditingController _portController = TextEditingController(text: '389');
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('AD/LDAP settings saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save AD/LDAP settings: $e'),
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
    _serverController.dispose();
    _portController.dispose();
    _bindUserController.dispose();
    _bindPasswordController.dispose();
    _baseDnController.dispose();
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
                            'AD/LDAP Authentication & Sync',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Synchronize user accounts and groups from Active Directory or LDAP server.',
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
                          value: _enableLdap,
                          onChanged: (val) => setState(() => _enableLdap = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Enable Login With AD/LDAP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            'When true, Mattermost allows login using AD/LDAP credentials.',
                            style: TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                        ),
                        const Divider(color: Colors.white10, height: 24),

                        // Server & Port Row
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('AD/LDAP Server:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _serverController,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: 'e.g. ldap.example.com',
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
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Port:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _portController,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: '389 / 636',
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
                        const SizedBox(height: 16),

                        // Bind Username & Password
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Bind Username:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _bindUserController,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: 'e.g. cn=admin,dc=example,dc=com',
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
                                  const Text('Bind Password:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  TextField(
                                    controller: _bindPasswordController,
                                    obscureText: true,
                                    style: const TextStyle(color: Colors.white, fontSize: 13),
                                    decoration: InputDecoration(
                                      hintText: '••••••••',
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
                        const SizedBox(height: 16),

                        // Base DN
                        const Text('Base DN:', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _baseDnController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'e.g. ou=Users,dc=example,dc=com',
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
            ),
    );
  }
}
