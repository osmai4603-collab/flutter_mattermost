import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class CustomizationPage extends StatefulWidget {
  const CustomizationPage({super.key});

  @override
  State<CustomizationPage> createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _siteNameController = TextEditingController();
  final TextEditingController _siteDescriptionController =
      TextEditingController();
  bool _enableCustomBrand = false;
  final TextEditingController _customBrandTextController =
      TextEditingController();
  bool _enableAskCommunityLink = false;
  final TextEditingController _helpLinkController = TextEditingController();
  final TextEditingController _termsOfServiceLinkController =
      TextEditingController();
  final TextEditingController _privacyPolicyLinkController =
      TextEditingController();
  final TextEditingController _aboutLinkController = TextEditingController();
  final TextEditingController _forgotPasswordLinkController =
      TextEditingController();
  String _reportAProblemType = 'default';
  final TextEditingController _reportAProblemLinkController =
      TextEditingController();
  final TextEditingController _reportAProblemMailController =
      TextEditingController();
  bool _allowDownloadLogs = false;
  final TextEditingController _appDownloadLinkController =
      TextEditingController();
  final TextEditingController _androidAppDownloadLinkController =
      TextEditingController();
  final TextEditingController _iosAppDownloadLinkController =
      TextEditingController();
  bool _enableDesktopLandingPage = false;
  final TextEditingController _minimumDesktopAppVersionController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _siteNameController.dispose();
    _siteDescriptionController.dispose();
    _customBrandTextController.dispose();
    _helpLinkController.dispose();
    _termsOfServiceLinkController.dispose();
    _privacyPolicyLinkController.dispose();
    _aboutLinkController.dispose();
    _forgotPasswordLinkController.dispose();
    _reportAProblemLinkController.dispose();
    _reportAProblemMailController.dispose();
    _appDownloadLinkController.dispose();
    _androidAppDownloadLinkController.dispose();
    _iosAppDownloadLinkController.dispose();
    _minimumDesktopAppVersionController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final teamSettings =
          (config['TeamSettings'] as Map<String, dynamic>?) ?? const {};
      final supportSettings =
          (config['SupportSettings'] as Map<String, dynamic>?) ?? const {};
      final nativeAppSettings =
          (config['NativeAppSettings'] as Map<String, dynamic>?) ?? const {};
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _siteNameController.text = (teamSettings['SiteName'] as String?) ?? '';
      _siteDescriptionController.text =
          (teamSettings['CustomDescriptionText'] as String?) ?? '';
      _enableCustomBrand = teamSettings['EnableCustomBrand'] == true;
      _customBrandTextController.text =
          (teamSettings['CustomBrandText'] as String?) ?? '';
      _enableAskCommunityLink =
          supportSettings['EnableAskCommunityLink'] == true;
      _helpLinkController.text = (supportSettings['HelpLink'] as String?) ?? '';
      _termsOfServiceLinkController.text =
          (supportSettings['TermsOfServiceLink'] as String?) ?? '';
      _privacyPolicyLinkController.text =
          (supportSettings['PrivacyPolicyLink'] as String?) ?? '';
      _aboutLinkController.text =
          (supportSettings['AboutLink'] as String?) ?? '';
      _forgotPasswordLinkController.text =
          (supportSettings['ForgotPasswordLink'] as String?) ?? '';
      _reportAProblemType =
          (supportSettings['ReportAProblemType'] as String?) ?? 'default';
      _reportAProblemLinkController.text =
          (supportSettings['ReportAProblemLink'] as String?) ?? '';
      _reportAProblemMailController.text =
          (supportSettings['ReportAProblemMail'] as String?) ?? '';
      _allowDownloadLogs = supportSettings['AllowDownloadLogs'] == true;
      _appDownloadLinkController.text =
          (nativeAppSettings['AppDownloadLink'] as String?) ?? '';
      _androidAppDownloadLinkController.text =
          (nativeAppSettings['AndroidAppDownloadLink'] as String?) ?? '';
      _iosAppDownloadLinkController.text =
          (nativeAppSettings['IosAppDownloadLink'] as String?) ?? '';
      _enableDesktopLandingPage =
          serviceSettings['EnableDesktopLandingPage'] == true;
      _minimumDesktopAppVersionController.text =
          (serviceSettings['MinimumDesktopAppVersion'] as String?) ?? '';
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
        'TeamSettings': {
          'SiteName': _siteNameController.text.trim(),
          'CustomDescriptionText': _siteDescriptionController.text.trim(),
          'EnableCustomBrand': _enableCustomBrand,
          'CustomBrandText': _customBrandTextController.text.trim(),
        },
        'SupportSettings': {
          'EnableAskCommunityLink': _enableAskCommunityLink,
          'HelpLink': _helpLinkController.text.trim(),
          'TermsOfServiceLink': _termsOfServiceLinkController.text.trim(),
          'PrivacyPolicyLink': _privacyPolicyLinkController.text.trim(),
          'AboutLink': _aboutLinkController.text.trim(),
          'ForgotPasswordLink': _forgotPasswordLinkController.text.trim(),
          'ReportAProblemType': _reportAProblemType,
          'ReportAProblemLink': _reportAProblemLinkController.text.trim(),
          'ReportAProblemMail': _reportAProblemMailController.text.trim(),
          'AllowDownloadLogs': _allowDownloadLogs,
        },
        'NativeAppSettings': {
          'AppDownloadLink': _appDownloadLinkController.text.trim(),
          'AndroidAppDownloadLink': _androidAppDownloadLinkController.text
              .trim(),
          'IosAppDownloadLink': _iosAppDownloadLinkController.text.trim(),
        },
        'ServiceSettings': {
          'EnableDesktopLandingPage': _enableDesktopLandingPage,
          'MinimumDesktopAppVersion': _minimumDesktopAppVersionController.text
              .trim(),
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Customization settings saved'),
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
              'Customization',
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
                  _buildSiteInfoSection(colors),
                  const SizedBox(height: 20),
                  _buildBrandingSection(colors),
                  const SizedBox(height: 20),
                  _buildLinksSection(colors),
                  const SizedBox(height: 20),
                  _buildReportProblemSection(colors),
                  const SizedBox(height: 20),
                  _buildMobileAppsSection(colors),
                  const SizedBox(height: 20),
                  _buildDesktopSection(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildSiteInfoSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _siteNameController,
          title: 'Site Name',
          subtitle:
              'Name of service shown in login screens and UI. Defaults to "Mattermost".',
          placeholder: 'Mattermost',
          maxLength: 30,
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _siteDescriptionController,
          title: 'Site Description',
          subtitle:
              'Description of service shown in login screens and UI. When not empty, displays as a title above the login form. When empty, the words "Log in" are displayed.',
        ),
      ],
    );
  }

  Widget _buildBrandingSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableCustomBrand,
          onChanged: (v) {
            if (v != null) setState(() => _enableCustomBrand = v);
          },
          title: 'Enable Custom Branding',
          subtitle:
              'Enable custom branding to show an image and help text on the login page.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _customBrandTextController,
          title: 'Custom Brand Text',
          subtitle:
              'Text that will appear below the custom brand image on the login page. Supports Markdown. Maximum 500 characters.',
          placeholder: 'Enter a custom brand message...',
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _enableAskCommunityLink,
          onChanged: (v) {
            if (v != null) setState(() => _enableAskCommunityLink = v);
          },
          title: 'Enable Ask Community Link',
          subtitle:
              'Display a link to Mattermost Community on the main page to ask questions, provide feedback, and search for help from community members.',
        ),
      ],
    );
  }

  Widget _buildLinksSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _helpLinkController,
          title: 'Help Link',
          subtitle:
              'URL for the Help link in the Help Menu and on the login and sign-up pages. If the field is empty, the Help link is hidden from the Help Menu and the login and sign-up pages.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _termsOfServiceLinkController,
          title: 'Terms of Use Link',
          subtitle:
              'URL to the Terms of Service for the link on the sign-up page. If the field is empty, the Terms of Use link is hidden from the sign-up and login pages.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _privacyPolicyLinkController,
          title: 'Privacy Policy Link',
          subtitle:
              'URL to the Privacy Policy for the link on the sign-up page. If the field is empty, the Privacy Policy link is hidden from the sign-up and login pages.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _aboutLinkController,
          title: 'About Link',
          subtitle:
              'URL to an About page for the link on the login and sign-up pages. If the field is empty, the About link is hidden from the login and sign-up pages.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _forgotPasswordLinkController,
          title: 'Forgot Password Custom Link',
          subtitle:
              'URL to a custom password reset page. If the field is empty, the default password reset flow is used. Leave empty to use the default.',
        ),
      ],
    );
  }

  Widget _buildReportProblemSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _dropdownTile(
          colors,
          value: _reportAProblemType,
          onChanged: (v) {
            if (v != null) setState(() => _reportAProblemType = v);
          },
          title: 'Report a Problem',
          subtitle: 'Configure how users can report problems.',
          options: {
            'default': 'Default',
            'email': 'Email address',
            'link': 'Custom link',
            'hidden': 'Hide link',
          },
        ),
        if (_reportAProblemType == 'link') ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _reportAProblemLinkController,
            title: 'Custom Report a Problem Link',
            subtitle: 'Enter a URL for the Report a Problem link.',
          ),
        ],
        if (_reportAProblemType == 'email') ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _reportAProblemMailController,
            title: 'Report a Problem Email Address',
            subtitle: 'Enter an email address for the Report a Problem link.',
          ),
        ],
        _divider(colors),
        _boolTile(
          colors,
          value: _allowDownloadLogs,
          onChanged: (v) {
            if (v != null) setState(() => _allowDownloadLogs = v);
          },
          title: 'Allow Mobile App Log Downloads',
          subtitle:
              'When true, users can download logs from the mobile app. When false, the option to download logs is hidden from the mobile app.',
        ),
      ],
    );
  }

  Widget _buildMobileAppsSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _textTile(
          colors,
          controller: _appDownloadLinkController,
          title: 'Mattermost Apps Download Page Link',
          subtitle:
              'URL to the download page for the Mattermost apps. If the field is empty, the link is hidden from the product.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _androidAppDownloadLinkController,
          title: 'Android App Download Link',
          subtitle:
              'URL to the Android app download page. If the field is empty, the link is hidden from the product.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _iosAppDownloadLinkController,
          title: 'iOS App Download Link',
          subtitle:
              'URL to the iOS app download page. If the field is empty, the link is hidden from the product.',
        ),
      ],
    );
  }

  Widget _buildDesktopSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableDesktopLandingPage,
          onChanged: (v) {
            if (v != null) setState(() => _enableDesktopLandingPage = v);
          },
          title: 'Enable Desktop App Landing Page',
          subtitle:
              'When true, users who access the Mattermost server via a browser are shown a landing page with links to download the desktop app.',
        ),
        _divider(colors),
        _textTile(
          colors,
          controller: _minimumDesktopAppVersionController,
          title: 'Minimum Desktop App Version',
          subtitle:
              'If set, users on desktop versions below this will be prompted to upgrade. Input a version number (e.g. 5.0.0). Leave empty for no minimum version requirement.',
          placeholder: '5.0.0',
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
    int? maxLength,
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
          maxLength: maxLength,
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
          initialValue: value,
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
}
