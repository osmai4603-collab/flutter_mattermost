import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class LoggingPage extends StatefulWidget {
  const LoggingPage({super.key});

  @override
  State<LoggingPage> createState() => _LoggingPageState();
}

class _LoggingPageState extends State<LoggingPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableConsole = false;
  String _consoleLevel = 'INFO';
  bool _consoleJson = false;
  bool _enableFile = true;
  String _fileLevel = 'INFO';
  bool _fileJson = false;
  final TextEditingController _fileLocationController = TextEditingController();
  bool _enableWebhookDebugging = false;
  bool _enableDiagnostics = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _fileLocationController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final logSettings =
          (config['LogSettings'] as Map<String, dynamic>?) ?? const {};

      _enableConsole = logSettings['EnableConsole'] == true;
      _consoleLevel = (logSettings['ConsoleLevel'] as String?) ?? 'INFO';
      _consoleJson = logSettings['ConsoleJson'] == true;
      _enableFile = logSettings['EnableFile'] == true;
      _fileLevel = (logSettings['FileLevel'] as String?) ?? 'INFO';
      _fileJson = logSettings['FileJson'] == true;
      _fileLocationController.text =
          (logSettings['FileLocation'] as String?) ?? '';
      _enableWebhookDebugging = logSettings['EnableWebhookDebugging'] == true;
      _enableDiagnostics = logSettings['EnableDiagnostics'] == true;
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
        'LogSettings': {
          'EnableConsole': _enableConsole,
          'ConsoleLevel': _consoleLevel,
          'ConsoleJson': _consoleJson,
          'EnableFile': _enableFile,
          'FileLevel': _fileLevel,
          'FileJson': _fileJson,
          'FileLocation': _fileLocationController.text.trim(),
          'EnableWebhookDebugging': _enableWebhookDebugging,
          'EnableDiagnostics': _enableDiagnostics,
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
              'Logging',
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
                        'Console Logging',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _enableConsole,
                        onChanged: (v) {
                          if (v != null) setState(() => _enableConsole = v);
                        },
                        title: 'Output Logs to Console',
                        subtitle:
                            'Typically false in production. Set to true to output log messages to stdout.',
                      ),
                      _divider(colors),
                      _dropdownTile(
                        colors,
                        value: _consoleLevel,
                        onChanged: (v) {
                          if (v != null) setState(() => _consoleLevel = v);
                        },
                        title: 'Console Log Level',
                        subtitle:
                            'ERROR=only errors; INFO=errors+startup; DEBUG=high detail.',
                        options: {
                          'ERROR': 'ERROR',
                          'WARN': 'WARN',
                          'INFO': 'INFO',
                          'DEBUG': 'DEBUG',
                        },
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _consoleJson,
                        onChanged: (v) {
                          if (v != null) setState(() => _consoleJson = v);
                        },
                        title: 'Output Console Logs as JSON',
                        subtitle:
                            'When true, logged events are written in JSON format.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionCard(
                    colors,
                    children: [
                      Text(
                        'File Logging',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _enableFile,
                        onChanged: (v) {
                          if (v != null) setState(() => _enableFile = v);
                        },
                        title: 'Output Logs to File',
                        subtitle: 'Typically true in production.',
                      ),
                      _divider(colors),
                      _dropdownTile(
                        colors,
                        value: _fileLevel,
                        onChanged: (v) {
                          if (v != null) setState(() => _fileLevel = v);
                        },
                        title: 'File Log Level',
                        subtitle: 'Same as Console but for file output.',
                        options: {
                          'ERROR': 'ERROR',
                          'WARN': 'WARN',
                          'INFO': 'INFO',
                          'DEBUG': 'DEBUG',
                        },
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _fileJson,
                        onChanged: (v) {
                          if (v != null) setState(() => _fileJson = v);
                        },
                        title: 'Output File Logs as JSON',
                        subtitle: 'When true, file logs are in JSON format.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _fileLocationController,
                        title: 'File Log Directory',
                        subtitle: 'Location of log files.',
                        placeholder: 'Enter your file location',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionCard(
                    colors,
                    children: [
                      Text(
                        'Advanced',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _enableWebhookDebugging,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _enableWebhookDebugging = v);
                        },
                        title: 'Enable Webhook Debugging',
                        subtitle:
                            'When true, sends webhook debug messages to server logs.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _enableDiagnostics,
                        onChanged: (v) {
                          if (v != null) setState(() => _enableDiagnostics = v);
                        },
                        title: 'Enable Diagnostics and Error Reporting',
                        subtitle:
                            'Enable to improve quality by sending error reporting.',
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
