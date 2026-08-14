import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password policy settings saved'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save settings: $e'),
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
    _minLengthController.dispose();
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
                            'Password Policy Settings',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Set minimum password requirements for system users.',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
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
                        const Text(
                          'Minimum Password Length:',
                          style: TextStyle(
                            color: Colors.white,
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFF212433),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Minimum characters required (default: 8, max: 64).',
                          style: TextStyle(color: Colors.white54, fontSize: 11),
                        ),
                        const Divider(color: Colors.white10, height: 28),

                        // Requirement Switches
                        SwitchListTile(
                          value: _requireLowercase,
                          onChanged: (val) =>
                              setState(() => _requireLowercase = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Require Lowercase Letters (a-z)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SwitchListTile(
                          value: _requireUppercase,
                          onChanged: (val) =>
                              setState(() => _requireUppercase = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Require Uppercase Letters (A-Z)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SwitchListTile(
                          value: _requireNumber,
                          onChanged: (val) =>
                              setState(() => _requireNumber = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Require Numbers (0-9)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SwitchListTile(
                          value: _requireSymbol,
                          onChanged: (val) =>
                              setState(() => _requireSymbol = val),
                          activeThumbColor: Colors.blueAccent,
                          title: const Text(
                            'Require Symbols (e.g. !@#\$%)',
                            style: TextStyle(
                              color: Colors.white,
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
