import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class MobileSecurityPage extends StatefulWidget {
  const MobileSecurityPage({super.key});

  @override
  State<MobileSecurityPage> createState() => _MobileSecurityPageState();
}

class _MobileSecurityPageState extends State<MobileSecurityPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _mobileEnableBiometrics = false;
  bool _mobilePreventScreenCapture = false;
  bool _mobileJailbreakProtection = false;
  bool _mobileEnableSecureFilePreview = false;
  bool _mobileAllowPdfLinkNavigation = false;

  bool _intuneEnable = false;
  String _intuneAuthService = '';
  final TextEditingController _intuneTenantIdController =
      TextEditingController();
  final TextEditingController _intuneClientIdController =
      TextEditingController();

  bool _mobileEphemeralEnable = false;
  final TextEditingController _disconnectionTimeoutSecondsController =
      TextEditingController();
  final TextEditingController _offlinePersistenceTimerHoursController =
      TextEditingController();
  final TextEditingController _autoCacheCleanupDaysController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _intuneTenantIdController.dispose();
    _intuneClientIdController.dispose();
    _disconnectionTimeoutSecondsController.dispose();
    _offlinePersistenceTimerHoursController.dispose();
    _autoCacheCleanupDaysController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final nativeAppSettings =
          (config['NativeAppSettings'] as Map<String, dynamic>?) ?? const {};
      final intuneSettings =
          (config['IntuneSettings'] as Map<String, dynamic>?) ?? const {};
      final mobileEphemeralSettings =
          (config['MobileEphemeralModeSettings'] as Map<String, dynamic>?) ??
          const {};

      _mobileEnableBiometrics =
          nativeAppSettings['MobileEnableBiometrics'] == true;
      _mobilePreventScreenCapture =
          nativeAppSettings['MobilePreventScreenCapture'] == true;
      _mobileJailbreakProtection =
          nativeAppSettings['MobileJailbreakProtection'] == true;
      _mobileEnableSecureFilePreview =
          nativeAppSettings['MobileEnableSecureFilePreview'] == true;
      _mobileAllowPdfLinkNavigation =
          nativeAppSettings['MobileAllowPdfLinkNavigation'] == true;

      _intuneEnable = intuneSettings['Enable'] == true;
      _intuneAuthService = (intuneSettings['AuthService'] as String?) ?? '';
      _intuneTenantIdController.text =
          (intuneSettings['TenantId'] as String?) ?? '';
      _intuneClientIdController.text =
          (intuneSettings['ClientId'] as String?) ?? '';

      _mobileEphemeralEnable = mobileEphemeralSettings['Enable'] == true;
      _disconnectionTimeoutSecondsController.text =
          (mobileEphemeralSettings['DisconnectionTimeoutSeconds'] as int?)
              ?.toString() ??
          '';
      _offlinePersistenceTimerHoursController.text =
          (mobileEphemeralSettings['OfflinePersistenceTimerHours'] as int?)
              ?.toString() ??
          '';
      _autoCacheCleanupDaysController.text =
          (mobileEphemeralSettings['AutoCacheCleanupDays'] as int?)
              ?.toString() ??
          '';
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
        'NativeAppSettings': {
          'MobileEnableBiometrics': _mobileEnableBiometrics,
          'MobilePreventScreenCapture': _mobilePreventScreenCapture,
          'MobileJailbreakProtection': _mobileJailbreakProtection,
          'MobileEnableSecureFilePreview': _mobileEnableSecureFilePreview,
          'MobileAllowPdfLinkNavigation': _mobileAllowPdfLinkNavigation,
        },
        'IntuneSettings': {
          'Enable': _intuneEnable,
          'AuthService': _intuneAuthService,
          'TenantId': _intuneTenantIdController.text.trim(),
          'ClientId': _intuneClientIdController.text.trim(),
        },
        'MobileEphemeralModeSettings': {
          'Enable': _mobileEphemeralEnable,
          'DisconnectionTimeoutSeconds':
              int.tryParse(
                _disconnectionTimeoutSecondsController.text.trim(),
              ) ??
              60,
          'OfflinePersistenceTimerHours':
              int.tryParse(
                _offlinePersistenceTimerHoursController.text.trim(),
              ) ??
              24,
          'AutoCacheCleanupDays':
              int.tryParse(_autoCacheCleanupDaysController.text.trim()) ?? 7,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Settings saved'),
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
              'Mobile Security',
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
                  _sectionCard(
                    colors,
                    children: [
                      Text(
                        'General Mobile Security',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _mobileEnableBiometrics,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _mobileEnableBiometrics = v);
                        },
                        title: 'Enable Biometric Authentication',
                        subtitle:
                            'Enforces biometric authentication before accessing the app.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _mobilePreventScreenCapture,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _mobilePreventScreenCapture = v);
                        },
                        title: 'Prevent Screen Capture',
                        subtitle: 'Blocks screenshots and screen recordings.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _mobileJailbreakProtection,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _mobileJailbreakProtection = v);
                        },
                        title: 'Enable Jailbreak/Root Protection',
                        subtitle:
                            'Prevents access on jailbroken/rooted devices.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _mobileEnableSecureFilePreview,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _mobileEnableSecureFilePreview = v);
                        },
                        title: 'Enable Secure File Preview Mode',
                        subtitle:
                            'Prevents file downloads, previews, and sharing for most file types.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _mobileAllowPdfLinkNavigation,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _mobileAllowPdfLinkNavigation = v);
                        },
                        title: 'Allow Link Navigation in Secure PDFs',
                        subtitle:
                            'Enables tapping links inside PDFs when Secure File Preview is active.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionCard(
                    colors,
                    children: [
                      Text(
                        'Microsoft Intune',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _intuneEnable,
                        onChanged: (v) {
                          if (v != null) setState(() => _intuneEnable = v);
                        },
                        title: 'Enable Microsoft Intune MAM',
                        subtitle:
                            'When enabled, uses Microsoft Entra ID for app authentication.',
                      ),
                      _divider(colors),
                      _dropdownTile(
                        colors,
                        value: _intuneAuthService,
                        onChanged: (v) {
                          if (v != null) setState(() => _intuneAuthService = v);
                        },
                        title: 'Auth Provider',
                        subtitle: 'Auth provider for Intune.',
                        options: {
                          '': 'Select',
                          'office365': 'OpenID Connect / Office 365',
                          'saml': 'SAML 2.0',
                        },
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _intuneTenantIdController,
                        title: 'Tenant ID',
                        subtitle: 'The Microsoft Entra ID Tenant ID.',
                        placeholder: '12345678-1234-1234-1234-123456789012',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _intuneClientIdController,
                        title: 'Application (Client) ID',
                        subtitle: 'The Application Client ID.',
                        placeholder: '87654321-4321-4321-4321-210987654321',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionCard(
                    colors,
                    children: [
                      Text(
                        'Mobile Ephemeral Mode',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _mobileEphemeralEnable,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _mobileEphemeralEnable = v);
                        },
                        title: 'Enable Mobile Ephemeral Mode',
                        subtitle:
                            'When enabled, mobile clients follow server-configured ephemeral data policies.',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _disconnectionTimeoutSecondsController,
                        title: 'Disconnection Timeout (seconds)',
                        subtitle:
                            'Grace period after losing connection. Values below 5 not recommended.',
                        placeholder: '60',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _offlinePersistenceTimerHoursController,
                        title: 'Offline Persistence Timer (hours)',
                        subtitle:
                            'How long cached content is kept after going offline.',
                        placeholder: '24',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _autoCacheCleanupDaysController,
                        title: 'Auto Cache Cleanup (days)',
                        subtitle: 'Maximum age of cached content on device.',
                        placeholder: '7',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
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
}
