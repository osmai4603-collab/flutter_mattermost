import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class FileStoragePage extends StatefulWidget {
  const FileStoragePage({super.key});

  @override
  State<FileStoragePage> createState() => _FileStoragePageState();
}

class _FileStoragePageState extends State<FileStoragePage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  // Storage
  String _driverName = 'local';
  final TextEditingController _directoryController = TextEditingController();
  final TextEditingController _maxFileSizeController = TextEditingController();
  bool _extractContent = false;
  final TextEditingController _extractContentTimeoutController =
      TextEditingController();
  bool _archiveRecursion = false;

  // Amazon S3 Settings
  final TextEditingController _amazonS3BucketController =
      TextEditingController();
  final TextEditingController _amazonS3PathPrefixController =
      TextEditingController();
  final TextEditingController _amazonS3RegionController =
      TextEditingController();
  final TextEditingController _amazonS3AccessKeyIdController =
      TextEditingController();
  final TextEditingController _amazonS3EndpointController =
      TextEditingController();
  final TextEditingController _amazonS3SecretAccessKeyController =
      TextEditingController();
  bool _amazonS3SSL = true;
  bool _amazonS3Trace = false;
  final TextEditingController _amazonS3StorageClassController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _directoryController.dispose();
    _maxFileSizeController.dispose();
    _extractContentTimeoutController.dispose();
    _amazonS3BucketController.dispose();
    _amazonS3PathPrefixController.dispose();
    _amazonS3RegionController.dispose();
    _amazonS3AccessKeyIdController.dispose();
    _amazonS3EndpointController.dispose();
    _amazonS3SecretAccessKeyController.dispose();
    _amazonS3StorageClassController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final fileSettings =
          (config['FileSettings'] as Map<String, dynamic>?) ?? const {};

      _driverName = (fileSettings['DriverName'] as String?) ?? 'local';
      _directoryController.text = (fileSettings['Directory'] as String?) ?? '';
      _maxFileSizeController.text =
          (fileSettings['MaxFileSize'] as int?)?.toString() ?? '';
      _extractContent = fileSettings['ExtractContent'] == true;
      _extractContentTimeoutController.text =
          (fileSettings['ExtractContentTimeout'] as int?)?.toString() ?? '';
      _archiveRecursion = fileSettings['ArchiveRecursion'] == true;

      _amazonS3BucketController.text =
          (fileSettings['AmazonS3Bucket'] as String?) ?? '';
      _amazonS3PathPrefixController.text =
          (fileSettings['AmazonS3PathPrefix'] as String?) ?? '';
      _amazonS3RegionController.text =
          (fileSettings['AmazonS3Region'] as String?) ?? '';
      _amazonS3AccessKeyIdController.text =
          (fileSettings['AmazonS3AccessKeyId'] as String?) ?? '';
      _amazonS3EndpointController.text =
          (fileSettings['AmazonS3Endpoint'] as String?) ?? '';
      _amazonS3SecretAccessKeyController.text =
          (fileSettings['AmazonS3SecretAccessKey'] as String?) ?? '';
      _amazonS3SSL = fileSettings['AmazonS3SSL'] != false;
      _amazonS3Trace = fileSettings['AmazonS3Trace'] == true;
      _amazonS3StorageClassController.text =
          (fileSettings['AmazonS3StorageClass'] as String?) ?? '';
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
        'FileSettings': {
          'DriverName': _driverName,
          'Directory': _directoryController.text.trim(),
          'MaxFileSize': int.tryParse(_maxFileSizeController.text.trim()) ?? 50,
          'ExtractContent': _extractContent,
          'ExtractContentTimeout':
              int.tryParse(_extractContentTimeoutController.text.trim()) ?? 10,
          'ArchiveRecursion': _archiveRecursion,
          'AmazonS3Bucket': _amazonS3BucketController.text.trim(),
          'AmazonS3PathPrefix': _amazonS3PathPrefixController.text.trim(),
          'AmazonS3Region': _amazonS3RegionController.text.trim(),
          'AmazonS3AccessKeyId': _amazonS3AccessKeyIdController.text.trim(),
          'AmazonS3Endpoint': _amazonS3EndpointController.text.trim(),
          'AmazonS3SecretAccessKey': _amazonS3SecretAccessKeyController.text
              .trim(),
          'AmazonS3SSL': _amazonS3SSL,
          'AmazonS3Trace': _amazonS3Trace,
          'AmazonS3StorageClass': _amazonS3StorageClassController.text.trim(),
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
              'File Storage',
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
                        'Storage',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _dropdownTile(
                        colors,
                        value: _driverName,
                        onChanged: (v) {
                          if (v != null) setState(() => _driverName = v);
                        },
                        title: 'Drive',
                        subtitle: 'Sets the storage system.',
                        options: {
                          'local': 'Local File System',
                          'amazons3': 'Amazon S3',
                          'azureblob': 'Azure Blob Storage',
                        },
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _directoryController,
                        title: 'Local Storage Directory',
                        subtitle: 'Directory to which files are written.',
                        placeholder: './data/',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _maxFileSizeController,
                        title: 'Maximum File Size (MB)',
                        subtitle: 'Maximum file size in megabytes.',
                        placeholder: '50',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _extractContent,
                        onChanged: (v) {
                          if (v != null) setState(() => _extractContent = v);
                        },
                        title: 'Enable Document Search by Content',
                        subtitle:
                            'When enabled, document types are searchable by content.',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _extractContentTimeoutController,
                        title: 'Document Content Extraction Timeout',
                        subtitle: 'Maximum seconds for content extraction.',
                        placeholder: '10',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _archiveRecursion,
                        onChanged: (v) {
                          if (v != null) setState(() => _archiveRecursion = v);
                        },
                        title: 'Enable Searching Content Within ZIP Files',
                        subtitle:
                            'When enabled, content of documents within ZIP files will be searchable.',
                      ),
                    ],
                  ),
                  if (_driverName == 'amazons3') ...[
                    const SizedBox(height: 20),
                    _sectionCard(
                      colors,
                      children: [
                        Text(
                          'Amazon S3 Settings',
                          style: TextStyle(
                            color: colors.centerChannelColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _textTile(
                          colors,
                          controller: _amazonS3BucketController,
                          title: 'Amazon S3 Bucket',
                          subtitle: 'Name of your S3 bucket.',
                        ),
                        _divider(colors),
                        _textTile(
                          colors,
                          controller: _amazonS3PathPrefixController,
                          title: 'Amazon S3 Path Prefix',
                          subtitle: 'Prefix for your S3 bucket.',
                        ),
                        _divider(colors),
                        _textTile(
                          colors,
                          controller: _amazonS3RegionController,
                          title: 'Amazon S3 Region',
                          subtitle: 'AWS region.',
                          placeholder: 'us-east-1',
                        ),
                        _divider(colors),
                        _textTile(
                          colors,
                          controller: _amazonS3AccessKeyIdController,
                          title: 'Amazon S3 Access Key ID',
                          subtitle: 'Optional, required if not using IAM role.',
                        ),
                        _divider(colors),
                        _textTile(
                          colors,
                          controller: _amazonS3EndpointController,
                          title: 'Amazon S3 Endpoint',
                          subtitle: 'Hostname of S3 provider.',
                          placeholder: 's3.amazonaws.com',
                        ),
                        _divider(colors),
                        _textTile(
                          colors,
                          controller: _amazonS3SecretAccessKeyController,
                          title: 'Amazon S3 Secret Access Key',
                          subtitle: 'The secret access key.',
                        ),
                        _divider(colors),
                        _boolTile(
                          colors,
                          value: _amazonS3SSL,
                          onChanged: (v) {
                            if (v != null) setState(() => _amazonS3SSL = v);
                          },
                          title: 'Enable Secure Amazon S3 Connections',
                          subtitle: 'When false, allows insecure connections.',
                        ),
                        _divider(colors),
                        _boolTile(
                          colors,
                          value: _amazonS3Trace,
                          onChanged: (v) {
                            if (v != null) setState(() => _amazonS3Trace = v);
                          },
                          title: 'Enable Amazon S3 Debugging',
                          subtitle:
                              'When true, log additional debugging information.',
                        ),
                        _divider(colors),
                        _textTile(
                          colors,
                          controller: _amazonS3StorageClassController,
                          title: 'Amazon S3 Storage Class',
                          subtitle: 'Storage class, defaults to empty.',
                        ),
                      ],
                    ),
                  ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
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
