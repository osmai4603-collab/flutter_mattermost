import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class LocalizationPage extends StatefulWidget {
  const LocalizationPage({super.key});

  @override
  State<LocalizationPage> createState() => _LocalizationPageState();
}

class _LocalizationPageState extends State<LocalizationPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  String _defaultServerLocale = 'en';
  String _defaultClientLocale = 'en';
  final TextEditingController _availableLocalesController =
      TextEditingController();
  bool _enableExperimentalLocales = false;

  static const Map<String, String> _languages = {
    'en': 'English (US)',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'ja': '日本語',
    'ko': '한국어',
    'pt-BR': 'Português (Brasil)',
    'zh-CN': '中文 (简体)',
    'zh-TW': '中文 (繁體)',
    'nl': 'Nederlands',
    'pl': 'Polski',
    'ru': 'Русский',
    'tr': 'Türkçe',
    'it': 'Italiano',
    'sv': 'Svenska',
    'uk': 'Українська',
    'bg': 'Български',
    'cs': 'Čeština',
    'el': 'Ελληνικά',
    'fa': 'فارسی',
    'he': 'עברית',
    'hi': 'हिन्दी',
    'hu': 'Magyar',
    'ro': 'Română',
    'vi': 'Tiếng Việt',
    'ar': 'العربية',
    'id': 'Bahasa Indonesia',
    'ms': 'Bahasa Melayu',
    'ka': 'ქართული',
    'lt': 'Lietuvių',
    'nb-NO': 'Norsk bokmål',
    'fa-IR': 'فارسی (ایران)',
    'gl': 'Galego',
  };

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _availableLocalesController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final localizationSettings =
          (config['LocalizationSettings'] as Map<String, dynamic>?) ?? const {};

      _defaultServerLocale =
          (localizationSettings['DefaultServerLocale'] as String?) ?? 'en';
      _defaultClientLocale =
          (localizationSettings['DefaultClientLocale'] as String?) ?? 'en';
      _availableLocalesController.text =
          (localizationSettings['AvailableLocales'] as String?) ?? '';
      _enableExperimentalLocales =
          localizationSettings['EnableExperimentalLocales'] == true;
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfig() async {
    final colors = AppTheme.of(context);
    setState(() => _isSaving = true);
    try {
      final patch = {
        'LocalizationSettings': {
          'DefaultServerLocale': _defaultServerLocale,
          'DefaultClientLocale': _defaultClientLocale,
          'AvailableLocales': _availableLocalesController.text.trim(),
          'EnableExperimentalLocales': _enableExperimentalLocales,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Localization settings saved'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
            backgroundColor: colors.errorTextColor,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
              'Localization',
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
                  _buildLocaleSettingsSection(colors),
                  const SizedBox(height: 20),
                  _buildAdvancedSection(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildLocaleSettingsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _dropdownTile(
          colors,
          value: _defaultServerLocale,
          onChanged: (v) {
            if (v != null) setState(() => _defaultServerLocale = v);
          },
          title: 'Default Server Language',
          subtitle: 'The default language for system messages and emails.',
          options: _languages,
        ),
        _divider(colors),
        _dropdownTile(
          colors,
          value: _defaultClientLocale,
          onChanged: (v) {
            if (v != null) setState(() => _defaultClientLocale = v);
          },
          title: 'Default Client Language',
          subtitle: 'The default language for the user interface.',
          options: _languages,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _availableLocalesController,
          title: 'Available Languages',
          subtitle:
              'The list of available languages the user can select from in the language selector. If blank, all available languages are shown. Comma-separated list of locale codes (e.g. "en, es, fr").',
          placeholder: 'en, es, fr, de, ja',
        ),
      ],
    );
  }

  Widget _buildAdvancedSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableExperimentalLocales,
          onChanged: (v) {
            if (v != null) setState(() => _enableExperimentalLocales = v);
          },
          title: 'Enable Experimental Locales',
          subtitle:
              'When true, users can select experimental languages that are not yet fully supported. These languages may have incomplete translations.',
        ),
      ],
    );
  }

  // --- Helper Widgets ---

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
          initialValue: options.containsKey(value) ? value : 'en',
          onChanged: onChanged,
          dropdownColor: colors.centerChannelBg,
          style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
          isExpanded: true,
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
}
