import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_security_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';

/// صفحة الأمان: اختبار LDAP + حالة SAML + إحصاء MFA.
class AdminConsoleSecuritySettingsPage extends StatefulWidget {
  const AdminConsoleSecuritySettingsPage({super.key});

  @override
  State<AdminConsoleSecuritySettingsPage> createState() => _AdminConsoleSecuritySettingsPageState();
}

class _AdminConsoleSecuritySettingsPageState extends State<AdminConsoleSecuritySettingsPage> {
  final AdminSecurityRepository _repository = getIt<AdminSecurityRepository>();

  bool _busy = false;
  String? _statusMessage;
  bool _isError = false;
  bool _samlConfigured = false;
  int _mfaUsers = 0;

  @override
  void initState() {
    super.initState();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    setState(() => _busy = true);
    try {
      final results = await Future.wait<dynamic>([
        _repository.getMFAStatus(),
        _repository.getSAMLCertificateStatus(),
      ]);
      final mfa = results[0] as Map<String, dynamic>;
      final saml = results[1] as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _mfaUsers = (mfa['total'] as num?)?.toInt() ?? 0;
        _samlConfigured = saml['valid'] == true;
      });
    } catch (_) {
      // قد لا يكون SAML مفعّلاً — تبقى الحالة الافتراضية.
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _run(String label, Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _statusMessage = null;
      _isError = false;
    });
    try {
      await action();
      if (mounted) {
        setState(() => _statusMessage = '$label succeeded');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = '$label failed: $e';
          _isError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_statusMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _statusMessage!,
                      style: TextStyle(
                        color: _isError
                            ? Colors.redAccent
                            : Colors.lightGreenAccent,
                        fontSize: 13,
                      ),
                    ),
                  ),
                _buildLDAPSection(),
                _buildSAMLSection(),
                _buildMFASection(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: const Row(
        children: [
          Icon(Icons.security_outlined, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'Security Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLDAPSection() {
    return AdminSettingSection(
      title: 'LDAP',
      subtitle: 'Integration with LDAP/Active Directory (Enterprise).',
      children: [
        Row(
          children: [
            _actionButton(
              'Test Connection',
              () => _run('LDAP test', _repository.testLDAPConnection),
            ),
            const SizedBox(width: 10),
            _actionButton(
              'Sync Now',
              () => _run('LDAP sync', _repository.syncLDAP),
            ),
            const SizedBox(width: 10),
            _actionButton(
              'Test Diagnostics',
              () => _run('LDAP diagnostics', () async {
                await _repository.testLDAPDiagnostics();
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSAMLSection() {
    return AdminSettingSection(
      title: 'SAML',
      subtitle: 'Single Sign-On via SAML (Enterprise).',
      children: [
        Row(
          children: [
            Icon(
              _samlConfigured ? Icons.verified_outlined : Icons.error_outline,
              color: _samlConfigured
                  ? Colors.lightGreenAccent
                  : Colors.orangeAccent,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              _samlConfigured
                  ? 'Certificate status: valid'
                  : 'SAML certificate not configured',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMFASection() {
    return AdminSettingSection(
      title: 'Multi-factor Authentication (MFA)',
      subtitle: 'Users currently enforcing MFA.',
      children: [
        Row(
          children: [
            const Icon(
              Icons.verified_user_outlined,
              color: Colors.blueAccent,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              '$_mfaUsers users',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed) {
    return OutlinedButton.icon(
      onPressed: _busy ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.blueAccent,
        side: const BorderSide(color: Colors.blueAccent),
      ),
      icon: const Icon(Icons.play_arrow, size: 16),
      label: Text(label),
    );
  }
}
