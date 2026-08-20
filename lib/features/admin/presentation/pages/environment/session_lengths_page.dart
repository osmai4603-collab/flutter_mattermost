import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class SessionLengthsPage extends StatefulWidget {
  const SessionLengthsPage({super.key});

  @override
  State<SessionLengthsPage> createState() => _SessionLengthsPageState();
}

class _SessionLengthsPageState extends State<SessionLengthsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _extendSessionLengthWithActivity = false;
  bool _terminateSessionsOnPasswordChange = false;
  final TextEditingController _sessionLengthWebInHoursController =
      TextEditingController();
  final TextEditingController _sessionLengthMobileInHoursController =
      TextEditingController();
  final TextEditingController _sessionLengthSSOInHoursController =
      TextEditingController();
  final TextEditingController _sessionCacheInMinutesController =
      TextEditingController();
  final TextEditingController _sessionIdleTimeoutInMinutesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _sessionLengthWebInHoursController.dispose();
    _sessionLengthMobileInHoursController.dispose();
    _sessionLengthSSOInHoursController.dispose();
    _sessionCacheInMinutesController.dispose();
    _sessionIdleTimeoutInMinutesController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _extendSessionLengthWithActivity =
          serviceSettings['ExtendSessionLengthWithActivity'] == true;
      _terminateSessionsOnPasswordChange =
          serviceSettings['TerminateSessionsOnPasswordChange'] == true;
      _sessionLengthWebInHoursController.text =
          (serviceSettings['SessionLengthWebInHours'] as int?)?.toString() ??
          '';
      _sessionLengthMobileInHoursController.text =
          (serviceSettings['SessionLengthMobileInHours'] as int?)?.toString() ??
          '';
      _sessionLengthSSOInHoursController.text =
          (serviceSettings['SessionLengthSSOInHours'] as int?)?.toString() ??
          '';
      _sessionCacheInMinutesController.text =
          (serviceSettings['SessionCacheInMinutes'] as int?)?.toString() ?? '';
      _sessionIdleTimeoutInMinutesController.text =
          (serviceSettings['SessionIdleTimeoutInMinutes'] as int?)
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
        'ServiceSettings': {
          'ExtendSessionLengthWithActivity': _extendSessionLengthWithActivity,
          'TerminateSessionsOnPasswordChange':
              _terminateSessionsOnPasswordChange,
          'SessionLengthWebInHours':
              int.tryParse(_sessionLengthWebInHoursController.text.trim()) ??
              720,
          'SessionLengthMobileInHours':
              int.tryParse(_sessionLengthMobileInHoursController.text.trim()) ??
              720,
          'SessionLengthSSOInHours':
              int.tryParse(_sessionLengthSSOInHoursController.text.trim()) ??
              720,
          'SessionCacheInMinutes':
              int.tryParse(_sessionCacheInMinutesController.text.trim()) ?? 10,
          'SessionIdleTimeoutInMinutes':
              int.tryParse(
                _sessionIdleTimeoutInMinutesController.text.trim(),
              ) ??
              60,
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
              'Session Lengths',
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
                      _boolTile(
                        colors,
                        value: _extendSessionLengthWithActivity,
                        onChanged: (v) {
                          if (v != null)
                            setState(
                              () => _extendSessionLengthWithActivity = v,
                            );
                        },
                        title: 'Extend Session Length with Activity',
                        subtitle:
                            'When true, sessions automatically extend when the user is active.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _terminateSessionsOnPasswordChange,
                        onChanged: (v) {
                          if (v != null)
                            setState(
                              () => _terminateSessionsOnPasswordChange = v,
                            );
                        },
                        title: 'Terminate Sessions on Password Change',
                        subtitle:
                            'When true, all sessions expire if password is changed.',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _sessionLengthWebInHoursController,
                        title: 'Session Length AD/LDAP and Email (hours)',
                        subtitle: 'Hours from last activity to session expiry.',
                        placeholder: '720',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _sessionLengthMobileInHoursController,
                        title: 'Session Length Mobile (hours)',
                        subtitle: 'Same but for mobile sessions.',
                        placeholder: '720',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _sessionLengthSSOInHoursController,
                        title: 'Session Length SSO (hours)',
                        subtitle: 'Same but for SSO sessions.',
                        placeholder: '720',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _sessionCacheInMinutesController,
                        title: 'Session Cache (minutes)',
                        subtitle: 'Minutes to cache a session in memory.',
                        placeholder: '10',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _sessionIdleTimeoutInMinutesController,
                        title: 'Session Idle Timeout (minutes)',
                        subtitle:
                            'Minutes from last activity to expiry. Min 5, 0=unlimited.',
                        placeholder: '60',
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
