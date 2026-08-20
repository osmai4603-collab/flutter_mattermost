import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _dataSourceController = TextEditingController();
  final TextEditingController _maxIdleConnsController = TextEditingController();
  final TextEditingController _maxOpenConnsController = TextEditingController();
  final TextEditingController _queryTimeoutController = TextEditingController();
  final TextEditingController _analyticsQueryTimeoutController =
      TextEditingController();
  final TextEditingController _connMaxLifetimeMillisecondsController =
      TextEditingController();
  final TextEditingController _connMaxIdleTimeMillisecondsController =
      TextEditingController();
  final TextEditingController _minimumHashtagLengthController =
      TextEditingController();
  bool _trace = false;
  bool _disableDatabaseSearch = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _driverNameController.dispose();
    _dataSourceController.dispose();
    _maxIdleConnsController.dispose();
    _maxOpenConnsController.dispose();
    _queryTimeoutController.dispose();
    _analyticsQueryTimeoutController.dispose();
    _connMaxLifetimeMillisecondsController.dispose();
    _connMaxIdleTimeMillisecondsController.dispose();
    _minimumHashtagLengthController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final sqlSettings =
          (config['SqlSettings'] as Map<String, dynamic>?) ?? const {};
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _driverNameController.text = (sqlSettings['DriverName'] as String?) ?? '';
      _dataSourceController.text = (sqlSettings['DataSource'] as String?) ?? '';
      _maxIdleConnsController.text =
          (sqlSettings['MaxIdleConns'] as int?)?.toString() ?? '';
      _maxOpenConnsController.text =
          (sqlSettings['MaxOpenConns'] as int?)?.toString() ?? '';
      _queryTimeoutController.text =
          (sqlSettings['QueryTimeout'] as int?)?.toString() ?? '';
      _analyticsQueryTimeoutController.text =
          (sqlSettings['AnalyticsQueryTimeout'] as int?)?.toString() ?? '';
      _connMaxLifetimeMillisecondsController.text =
          (sqlSettings['ConnMaxLifetimeMilliseconds'] as int?)?.toString() ??
          '';
      _connMaxIdleTimeMillisecondsController.text =
          (sqlSettings['ConnMaxIdleTimeMilliseconds'] as int?)?.toString() ??
          '';
      _minimumHashtagLengthController.text =
          (serviceSettings['MinimumHashtagLength'] as int?)?.toString() ?? '';
      _trace = sqlSettings['Trace'] == true;
      _disableDatabaseSearch = sqlSettings['DisableDatabaseSearch'] == true;
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
        'SqlSettings': {
          'MaxIdleConns':
              int.tryParse(_maxIdleConnsController.text.trim()) ?? 10,
          'MaxOpenConns':
              int.tryParse(_maxOpenConnsController.text.trim()) ?? 10,
          'QueryTimeout':
              int.tryParse(_queryTimeoutController.text.trim()) ?? 30,
          'AnalyticsQueryTimeout':
              int.tryParse(_analyticsQueryTimeoutController.text.trim()) ?? 300,
          'ConnMaxLifetimeMilliseconds':
              int.tryParse(
                _connMaxLifetimeMillisecondsController.text.trim(),
              ) ??
              3600000,
          'ConnMaxIdleTimeMilliseconds':
              int.tryParse(
                _connMaxIdleTimeMillisecondsController.text.trim(),
              ) ??
              300000,
          'Trace': _trace,
          'DisableDatabaseSearch': _disableDatabaseSearch,
        },
        'ServiceSettings': {
          'MinimumHashtagLength':
              int.tryParse(_minimumHashtagLengthController.text.trim()) ?? 3,
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
              'Database',
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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.amber.shade700,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Changing properties in this section will require a server restart before taking effect.',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _sectionCard(
                    colors,
                    children: [
                      _textTile(
                        colors,
                        controller: _driverNameController,
                        title: 'Driver Name',
                        subtitle:
                            'Set the database driver in config.json file.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _dataSourceController,
                        title: 'Data Source',
                        subtitle:
                            'Set the database source in config.json file.',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _maxIdleConnsController,
                        title: 'Maximum Idle Connections',
                        subtitle:
                            'Maximum number of idle connections held open.',
                        placeholder: '10',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _maxOpenConnsController,
                        title: 'Maximum Open Connections',
                        subtitle: 'Maximum number of open connections.',
                        placeholder: '10',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _queryTimeoutController,
                        title: 'Query Timeout',
                        subtitle: 'Seconds to wait for database response.',
                        placeholder: '30',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _analyticsQueryTimeoutController,
                        title: 'Analytics Query Timeout',
                        subtitle: 'Seconds to wait for analytics queries.',
                        placeholder: '300',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _connMaxLifetimeMillisecondsController,
                        title: 'Maximum Connection Lifetime',
                        subtitle:
                            'Maximum lifetime for a connection in milliseconds.',
                        placeholder: '3600000',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _connMaxIdleTimeMillisecondsController,
                        title: 'Maximum Connection Idle Time',
                        subtitle:
                            'Maximum idle time for a connection in milliseconds.',
                        placeholder: '300000',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _minimumHashtagLengthController,
                        title: 'Minimum Hashtag Length',
                        subtitle:
                            'Minimum characters in a hashtag. Default: 3.',
                        placeholder: '3',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _trace,
                        onChanged: (v) {
                          if (v != null) setState(() => _trace = v);
                        },
                        title: 'SQL Statement Logging',
                        subtitle:
                            'When true, SQL statements are written to the log.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _disableDatabaseSearch,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _disableDatabaseSearch = v);
                        },
                        title: 'Disable Database Search',
                        subtitle:
                            'Disables database search. Only use when other search engines are configured.',
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
