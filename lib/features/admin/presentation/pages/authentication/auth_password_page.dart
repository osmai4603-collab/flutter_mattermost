import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

/// صفحة إعدادات كلمة المرور (Password Settings Page)
class AdminConsoleAuthPasswordPage extends StatefulWidget {
  const AdminConsoleAuthPasswordPage({super.key});

  @override
  State<AdminConsoleAuthPasswordPage> createState() =>
      _AdminConsoleAuthPasswordPageState();
}

class _AdminConsoleAuthPasswordPageState
    extends State<AdminConsoleAuthPasswordPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;
  final TextEditingController _minLengthController = TextEditingController(
    text: '8',
  );
  bool _requireLowercase = true;
  bool _requireUppercase = true;
  bool _requireNumber = true;
  bool _requireSymbol = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final passwordSettings =
          (config['PasswordSettings'] as Map<String, dynamic>?) ?? const {};

      _minLengthController.text =
          (passwordSettings['MinimumLength'] as num?)?.toString() ?? '8';
      _requireLowercase = passwordSettings['Lowercase'] as bool? ?? true;
      _requireUppercase = passwordSettings['Uppercase'] as bool? ?? true;
      _requireNumber = passwordSettings['Number'] as bool? ?? true;
      _requireSymbol = passwordSettings['Symbol'] as bool? ?? false;
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
        'PasswordSettings': {
          'MinimumLength': int.tryParse(_minLengthController.text) ?? 8,
          'Lowercase': _requireLowercase,
          'Uppercase': _requireUppercase,
          'Number': _requireNumber,
          'Symbol': _requireSymbol,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password policy settings saved'),
            backgroundColor: colors.onlineIndicator,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final colors = AppTheme.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
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
    _minLengthController.dispose();
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
              'Password',
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
                        Text(
                          'Minimum Password Length:',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 160,
                          child: TextField(
                            controller: _minLengthController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
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
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Minimum characters required (default: 8, max: 64).',
                          style: TextStyle(
                            color: colors.centerChannelColor.withValues(
                              alpha: 0.54,
                            ),
                            fontSize: 11,
                          ),
                        ),
                        Divider(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.10,
                          ),
                          height: 28,
                        ),

                        // Requirement Switches
                        SwitchListTile(
                          value: _requireLowercase,
                          onChanged: (val) =>
                              setState(() => _requireLowercase = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Require Lowercase Letters (a-z)',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SwitchListTile(
                          value: _requireUppercase,
                          onChanged: (val) =>
                              setState(() => _requireUppercase = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Require Uppercase Letters (A-Z)',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SwitchListTile(
                          value: _requireNumber,
                          onChanged: (val) =>
                              setState(() => _requireNumber = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Require Numbers (0-9)',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SwitchListTile(
                          value: _requireSymbol,
                          onChanged: (val) =>
                              setState(() => _requireSymbol = val),
                          activeThumbColor: colors.buttonBg,
                          title: Text(
                            'Require Symbols (e.g. !@#\$%)',
                            style: TextStyle(
                              color: colors.centerChannelColor,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
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
