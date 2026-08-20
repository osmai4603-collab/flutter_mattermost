import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class SmtpPage extends StatefulWidget {
  const SmtpPage({super.key});

  @override
  State<SmtpPage> createState() => _SmtpPageState();
}

class _SmtpPageState extends State<SmtpPage> {
  final _adminConfigRepository = getIt<AdminConfigRepository>();
  bool _isSaving = false;

  final _smtpServerController = TextEditingController();
  final _smtpPortController = TextEditingController();
  final _smtpUsernameController = TextEditingController();
  final _smtpPasswordController = TextEditingController();

  bool _enableSMTPAuth = false;
  String _connectionSecurity = '';
  bool _skipServerCertVerification = false;
  bool _enableSecurityFixAlert = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _smtpServerController.dispose();
    _smtpPortController.dispose();
    _smtpUsernameController.dispose();
    _smtpPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await _adminConfigRepository.getConfig();
    setState(() {
      _smtpServerController.text = config['EmailSettings.SMTPServer'] ?? '';
      _smtpPortController.text = config['EmailSettings.SMTPPort'] ?? '';
      _enableSMTPAuth = config['EmailSettings.EnableSMTPAuth'] == 'true';
      _smtpUsernameController.text = config['EmailSettings.SMTPUsername'] ?? '';
      _smtpPasswordController.text = config['EmailSettings.SMTPPassword'] ?? '';
      _connectionSecurity = config['EmailSettings.ConnectionSecurity'] ?? '';
      _skipServerCertVerification =
          config['EmailSettings.SkipServerCertificateVerification'] == 'true';
      _enableSecurityFixAlert =
          config['ServiceSettings.EnableSecurityFixAlert'] == 'true';
    });
  }

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      await _adminConfigRepository.patchConfig({
        'EmailSettings.SMTPServer': _smtpServerController.text,
        'EmailSettings.SMTPPort': _smtpPortController.text,
        'EmailSettings.EnableSMTPAuth': _enableSMTPAuth.toString(),
        'EmailSettings.SMTPUsername': _smtpUsernameController.text,
        'EmailSettings.SMTPPassword': _smtpPasswordController.text,
        'EmailSettings.ConnectionSecurity': _connectionSecurity,
        'EmailSettings.SkipServerCertificateVerification':
            _skipServerCertVerification.toString(),
        'ServiceSettings.EnableSecurityFixAlert': _enableSecurityFixAlert
            .toString(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('SMTP settings saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _sectionCard(
    MattermostColors colors, {
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.centerChannelBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colors.centerChannelColor.withValues(alpha: 0.10),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _divider(MattermostColors colors) {
    return Divider(
      color: colors.centerChannelColor.withValues(alpha: 0.10),
      height: 24,
    );
  }

  Widget _boolTile(
    MattermostColors colors, {
    required bool value,
    ValueChanged<bool?>? onChanged,
    required String title,
    required String subtitle,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: colors.buttonBg,
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(
          color: colors.centerChannelColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: colors.centerChannelColor.withValues(alpha: 0.54),
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _textTile(
    MattermostColors colors, {
    required TextEditingController controller,
    required String title,
    required String subtitle,
    String? placeholder,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: colors.centerChannelColor.withValues(alpha: 0.38),
              fontSize: 13,
            ),
            filled: true,
            fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _numberTile(
    MattermostColors colors, {
    required TextEditingController controller,
    required String title,
    required String subtitle,
    String? placeholder,
  }) {
    return _textTile(
      colors,
      controller: controller,
      title: title,
      subtitle: subtitle,
      placeholder: placeholder,
      keyboardType: TextInputType.number,
    );
  }

  Widget _dropdownTile(
    MattermostColors colors, {
    required String value,
    ValueChanged<String?>? onChanged,
    required String title,
    required String subtitle,
    required Map<String, String> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.centerChannelColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            color: colors.centerChannelColor.withValues(alpha: 0.54),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          dropdownColor: colors.centerChannelBg,
          style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: colors.centerChannelBg.withValues(alpha: 0.60),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          items: options.entries
              .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MattermostColors>()!;

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
              'SMTP',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            _sectionCard(
              colors,
              children: [
                Text(
                  'SMTP Server',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _textTile(
                  colors,
                  controller: _smtpServerController,
                  title: 'SMTP Server',
                  subtitle: 'Location of SMTP email server.',
                  placeholder: 'smtp.yourcompany.com',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _smtpPortController,
                  title: 'SMTP Server Port',
                  subtitle: 'Port of SMTP email server.',
                  placeholder: '25, 465, 587',
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _enableSMTPAuth,
                  onChanged: (v) =>
                      setState(() => _enableSMTPAuth = v ?? false),
                  title: 'Enable SMTP Authentication',
                  subtitle: 'When true, SMTP Authentication is enabled.',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _smtpUsernameController,
                  title: 'SMTP Server Username',
                  subtitle: 'Obtain from email server admin.',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _smtpPasswordController,
                  title: 'SMTP Server Password',
                  subtitle: 'Obtain from email server admin.',
                ),
                _divider(colors),
                _dropdownTile(
                  colors,
                  value: _connectionSecurity,
                  onChanged: (v) =>
                      setState(() => _connectionSecurity = v ?? ''),
                  title: 'Connection Security',
                  subtitle: 'Connection security method.',
                  options: {
                    '': 'None',
                    'TLS': 'TLS (Recommended)',
                    'STARTTLS': 'STARTTLS',
                  },
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _skipServerCertVerification,
                  onChanged: (v) =>
                      setState(() => _skipServerCertVerification = v ?? false),
                  title: 'Skip Server Certificate Verification',
                  subtitle:
                      'When true, will not verify email server certificate.',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _sectionCard(
              colors,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _boolTile(
                  colors,
                  value: _enableSecurityFixAlert,
                  onChanged: (v) =>
                      setState(() => _enableSecurityFixAlert = v ?? false),
                  title: 'Enable Security Alerts',
                  subtitle:
                      'When true, admins are notified by email of relevant security fix alerts.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
