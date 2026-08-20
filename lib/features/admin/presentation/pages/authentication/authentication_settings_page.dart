import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';
import 'package:flutter_mattermost/features/admin/presentation/widgets/admin_setting_section.dart';

/// صفحة إعدادات المصادقة: تسجيل الدخول بالبريد/اسم المستخدم + كلمة المرور.
class AdminConsoleAuthenticationSettingsPage extends StatefulWidget {
  const AdminConsoleAuthenticationSettingsPage({super.key});

  @override
  State<AdminConsoleAuthenticationSettingsPage> createState() =>
      _AdminConsoleAuthenticationSettingsPageState();
}

class _AdminConsoleAuthenticationSettingsPageState
    extends State<AdminConsoleAuthenticationSettingsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  Map<String, dynamic> _config = {};
  TextEditingController _minPasswordLength = TextEditingController();
  bool _enableSignUpWithEmail = true;
  bool _enableSignInWithEmail = true;
  bool _enableSignInWithUsername = true;
  bool _enableGuestAccounts = false;
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
        final teamSettings =
            (config['TeamSettings'] as Map<String, dynamic>?) ?? const {};
        final passwordSettings =
            (config['PasswordSettings'] as Map<String, dynamic>?) ?? const {};
        final service =
            (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};
        _enableSignUpWithEmail =
            teamSettings['EnableSignUpWithEmail'] as bool? ?? true;
        _enableSignInWithEmail =
            service['EnableSignInWithEmail'] as bool? ?? true;
        _enableSignInWithUsername =
            service['EnableSignInWithUsername'] as bool? ?? true;
        _enableGuestAccounts = service['EnableGuests'] as bool? ?? false;
        _minPasswordLength = TextEditingController(
          text: (passwordSettings['MinimumLength'] as num?)?.toString() ?? '8',
        );
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    final colors = AppTheme.of(context);
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final patch = {
        'TeamSettings': {
          'EnableSignUpWithEmail': _enableSignUpWithEmail,
        },
        'ServiceSettings': {
          'EnableSignInWithEmail': _enableSignInWithEmail,
          'EnableSignInWithUsername': _enableSignInWithUsername,
          'EnableGuests': _enableGuestAccounts,
        },
        'PasswordSettings': {
          'MinimumLength': int.tryParse(_minPasswordLength.text) ?? 8,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Authentication settings saved'),
            backgroundColor: colors.onlineIndicator,
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
    _minPasswordLength.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(color: colors.buttonBg),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load settings: $_error',
                    style: TextStyle(color: colors.errorTextColor),
                  ),
                )
              : _buildForm(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = AppTheme.of(context);
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.centerChannelColor.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline, color: colors.buttonBg, size: 20),
          const SizedBox(width: 10),
          Text(
            'Authentication Settings',
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final colors = AppTheme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminSettingSection(
            title: 'Sign Up & Sign In',
            children: [
              AdminSettingField(
                label: 'Enable account creation with email',
                child: Switch(
                  value: _enableSignUpWithEmail,
                  onChanged: (v) => setState(() => _enableSignUpWithEmail = v),
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                ),
              ),
              AdminSettingField(
                label: 'Enable sign in with email',
                child: Switch(
                  value: _enableSignInWithEmail,
                  onChanged: (v) => setState(() => _enableSignInWithEmail = v),
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                ),
              ),
              AdminSettingField(
                label: 'Enable sign in with username',
                child: Switch(
                  value: _enableSignInWithUsername,
                  onChanged: (v) =>
                      setState(() => _enableSignInWithUsername = v),
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                ),
              ),
              AdminSettingField(
                label: 'Enable guest accounts',
                description: 'Enterprise feature. Allows creating guest users.',
                child: Switch(
                  value: _enableGuestAccounts,
                  onChanged: (v) => setState(() => _enableGuestAccounts = v),
                  activeTrackColor: colors.buttonBg.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          AdminSettingSection(
            title: 'Password Settings',
            children: [
              AdminSettingField(
                label: 'Minimum password length',
                description:
                    'Minimum number of characters required in passwords.',
                child: SizedBox(
                  width: 120,
                  child: TextField(
                    controller: _minPasswordLength,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: colors.centerChannelColor, fontSize: 13),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: colors.mentionHighlightBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colors.centerChannelColor.withValues(alpha: 0.12),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colors.centerChannelColor.withValues(alpha: 0.12),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                'Save failed: $_error',
                style: TextStyle(color: colors.errorTextColor, fontSize: 13),
              ),
            ),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            style: FilledButton.styleFrom(backgroundColor: colors.buttonBg),
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
}
