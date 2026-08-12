import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';

/// صفحة الإعدادات العامة: Site Settings + Localization.
class AdminConsoleGeneralSettingsPage extends StatefulWidget {
  const AdminConsoleGeneralSettingsPage({super.key});

  @override
  State<AdminConsoleGeneralSettingsPage> createState() => _AdminConsoleGeneralSettingsPageState();
}

class _AdminConsoleGeneralSettingsPageState extends State<AdminConsoleGeneralSettingsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  Map<String, dynamic> _config = {};
  TextEditingController _siteName = TextEditingController();
  TextEditingController _siteUrl = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool _enableUserCreation = true;
  bool _enableCustomEmoji = true;
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final config = await _repository.getConfig();
      if (!mounted) return;
      setState(() {
        _config = config;
        final site = (config['TeamSettings'] as Map<String, dynamic>?) ?? {};
        final service =
            (config['ServiceSettings'] as Map<String, dynamic>?) ?? {};
        final emoji =
            (config['ServiceSettings'] as Map<String, dynamic>?) ?? {};
        _siteName = TextEditingController(
          text: site['SiteName'] as String? ?? '',
        );
        _siteUrl = TextEditingController(
          text: service['SiteURL'] as String? ?? '',
        );
        _description = TextEditingController(
          text: site['CustomDescriptionText'] as String? ?? '',
        );
        _enableUserCreation = service['EnableUserCreation'] as bool? ?? true;
        _enableCustomEmoji = emoji['EnableCustomEmoji'] as bool? ?? true;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final config = Map<String, dynamic>.from(_config);
      final team = Map<String, dynamic>.from(
        (config['TeamSettings'] as Map?) ?? const {},
      );
      final service = Map<String, dynamic>.from(
        (config['ServiceSettings'] as Map?) ?? const {},
      );
      team['SiteName'] = _siteName.text;
      team['CustomDescriptionText'] = _description.text;
      service['SiteURL'] = _siteUrl.text;
      service['EnableUserCreation'] = _enableUserCreation;
      service['EnableCustomEmoji'] = _enableCustomEmoji;
      config['TeamSettings'] = team;
      config['ServiceSettings'] = service;
      await _repository.updateConfig(config);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Settings saved'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _siteName.dispose();
    _siteUrl.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load settings: $_error',
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                )
              : _buildForm(context),
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
          Icon(Icons.tune, color: Colors.blueAccent, size: 20),
          SizedBox(width: 10),
          Text(
            'General Settings',
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

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSettingSection(
            title: 'Site Configuration',
            subtitle: 'Basic information about your Mattermost server.',
            children: [
              AdminSettingField(
                label: 'Site Name',
                description:
                    'Name shown in account creation and sign in pages.',
                child: _textField(_siteName),
              ),
              AdminSettingField(
                label: 'Site URL',
                description: 'The URL of your Mattermost server.',
                child: _textField(_siteUrl),
              ),
              AdminSettingField(
                label: 'Custom Description Text',
                description: 'A short description shown on login pages.',
                child: _textField(_description),
              ),
            ],
          ),
          AdminSettingSection(
            title: 'Behavioral Settings',
            children: [
              AdminSettingField(
                label: 'Enable user account creation',
                description: 'Allow new user accounts to be created.',
                child: _toggle(
                  _enableUserCreation,
                  (v) => setState(() => _enableUserCreation = v),
                ),
              ),
              AdminSettingField(
                label: 'Enable custom emoji',
                description: 'Allow custom emoji to be uploaded by users.',
                child: _toggle(
                  _enableCustomEmoji,
                  (v) => setState(() => _enableCustomEmoji = v),
                ),
              ),
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Save failed: $_error',
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(backgroundColor: Colors.blueAccent),
            icon: Icon(
              _saving ? Icons.hourglass_top : Icons.save_outlined,
              size: 16,
            ),
            label: Text(_saving ? 'Saving...' : 'Save'),
          ),
        ],
      ),
    );
  }

  TextField _textField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF181825),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
    );
  }

  Switch _toggle(bool value, ValueChanged<bool> onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: Colors.blueAccent.withValues(alpha: 0.5),
    );
  }
}
