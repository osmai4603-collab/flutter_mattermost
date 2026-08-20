import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class WebServerPage extends StatefulWidget {
  const WebServerPage({super.key});

  @override
  State<WebServerPage> createState() => _WebServerPageState();
}

class _WebServerPageState extends State<WebServerPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  final TextEditingController _siteUrlController = TextEditingController();
  final TextEditingController _listenAddressController =
      TextEditingController();
  bool _forward80To443 = false;
  String _connectionSecurity = '';
  final TextEditingController _tlsCertFileController = TextEditingController();
  final TextEditingController _tlsKeyFileController = TextEditingController();
  bool _useLetsEncrypt = false;
  final TextEditingController _letsEncryptCacheFileController =
      TextEditingController();
  final TextEditingController _readTimeoutController = TextEditingController();
  final TextEditingController _writeTimeoutController = TextEditingController();
  final TextEditingController _maximumPayloadSizeBytesController =
      TextEditingController();
  String _webserverMode = 'gzip';
  bool _enableInsecureOutgoingConnections = false;
  final TextEditingController _managedResourcePathsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _siteUrlController.dispose();
    _listenAddressController.dispose();
    _tlsCertFileController.dispose();
    _tlsKeyFileController.dispose();
    _letsEncryptCacheFileController.dispose();
    _readTimeoutController.dispose();
    _writeTimeoutController.dispose();
    _maximumPayloadSizeBytesController.dispose();
    _managedResourcePathsController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _siteUrlController.text = (serviceSettings['SiteURL'] as String?) ?? '';
      _listenAddressController.text =
          (serviceSettings['ListenAddress'] as String?) ?? '';
      _forward80To443 = serviceSettings['Forward80To443'] == true;
      _connectionSecurity =
          (serviceSettings['ConnectionSecurity'] as String?) ?? '';
      _tlsCertFileController.text =
          (serviceSettings['TLSCertFile'] as String?) ?? '';
      _tlsKeyFileController.text =
          (serviceSettings['TLSKeyFile'] as String?) ?? '';
      _useLetsEncrypt = serviceSettings['UseLetsEncrypt'] == true;
      _letsEncryptCacheFileController.text =
          (serviceSettings['LetsEncryptCertificateCacheFile'] as String?) ?? '';
      _readTimeoutController.text =
          (serviceSettings['ReadTimeout'] as int?)?.toString() ?? '';
      _writeTimeoutController.text =
          (serviceSettings['WriteTimeout'] as int?)?.toString() ?? '';
      _maximumPayloadSizeBytesController.text =
          (serviceSettings['MaximumPayloadSizeBytes'] as int?)?.toString() ??
          '';
      _webserverMode = (serviceSettings['WebserverMode'] as String?) ?? 'gzip';
      _enableInsecureOutgoingConnections =
          serviceSettings['EnableInsecureOutgoingConnections'] == true;
      _managedResourcePathsController.text =
          (serviceSettings['ManagedResourcePaths'] as String?) ?? '';
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
          'SiteURL': _siteUrlController.text.trim(),
          'ListenAddress': _listenAddressController.text.trim(),
          'Forward80To443': _forward80To443,
          'ConnectionSecurity': _connectionSecurity,
          'TLSCertFile': _tlsCertFileController.text.trim(),
          'TLSKeyFile': _tlsKeyFileController.text.trim(),
          'UseLetsEncrypt': _useLetsEncrypt,
          'LetsEncryptCertificateCacheFile': _letsEncryptCacheFileController
              .text
              .trim(),
          'ReadTimeout': int.tryParse(_readTimeoutController.text.trim()) ?? 0,
          'WriteTimeout':
              int.tryParse(_writeTimeoutController.text.trim()) ?? 0,
          'MaximumPayloadSizeBytes':
              int.tryParse(_maximumPayloadSizeBytesController.text.trim()) ??
              104857600,
          'WebserverMode': _webserverMode,
          'EnableInsecureOutgoingConnections':
              _enableInsecureOutgoingConnections,
          'ManagedResourcePaths': _managedResourcePathsController.text.trim(),
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
              'Web Server',
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
                        controller: _siteUrlController,
                        title: 'Site URL',
                        subtitle:
                            'The URL that users will use to access Mattermost.',
                        placeholder: 'http://example.com:8065',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _listenAddressController,
                        title: 'Listen Address',
                        subtitle: 'The address and port to bind and listen on.',
                        placeholder: ':8065',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _forward80To443,
                        onChanged: (v) {
                          if (v != null) setState(() => _forward80To443 = v);
                        },
                        title: 'Forward port 80 to 443',
                        subtitle:
                            'Forwards all insecure traffic from port 80 to secure port 443. Not recommended when using a proxy server.',
                      ),
                      _divider(colors),
                      _dropdownTile(
                        colors,
                        value: _connectionSecurity,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _connectionSecurity = v);
                        },
                        title: 'Connection Security',
                        subtitle: 'The connection security method.',
                        options: {'': 'None', 'TLS': 'TLS (Recommended)'},
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _tlsCertFileController,
                        title: 'TLS Certificate File',
                        subtitle: 'The certificate file to use.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _tlsKeyFileController,
                        title: 'TLS Key File',
                        subtitle: 'The private key file to use.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _useLetsEncrypt,
                        onChanged: (v) {
                          if (v != null) setState(() => _useLetsEncrypt = v);
                        },
                        title: "Use Let's Encrypt",
                        subtitle:
                            "Enable automatic retrieval of certificates from Let's Encrypt.",
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _letsEncryptCacheFileController,
                        title: "Let's Encrypt Cache File",
                        subtitle:
                            'Certificates retrieved and other data about Let\'s Encrypt will be stored here.',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _readTimeoutController,
                        title: 'Read Timeout',
                        subtitle:
                            'Maximum time from connection accepted to request body fully read.',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _writeTimeoutController,
                        title: 'Write Timeout',
                        subtitle:
                            'Maximum time from reading request headers to response written.',
                      ),
                      _divider(colors),
                      _numberTile(
                        colors,
                        controller: _maximumPayloadSizeBytesController,
                        title: 'Maximum Payload Size (Bytes)',
                        subtitle:
                            'The maximum number of bytes allowed in the payload of incoming HTTP calls.',
                      ),
                      _divider(colors),
                      _dropdownTile(
                        colors,
                        value: _webserverMode,
                        onChanged: (v) {
                          if (v != null) setState(() => _webserverMode = v);
                        },
                        title: 'Webserver Mode',
                        subtitle: 'Gzip compression on static files.',
                        options: {
                          'gzip': 'Gzip',
                          'uncompressed': 'Uncompressed',
                          'disabled': 'Disabled',
                        },
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _enableInsecureOutgoingConnections,
                        onChanged: (v) {
                          if (v != null)
                            setState(
                              () => _enableInsecureOutgoingConnections = v,
                            );
                        },
                        title: 'Enable Insecure Outgoing Connections',
                        subtitle:
                            'When true, outgoing HTTPS requests accept unverified, self-signed certificates.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _managedResourcePathsController,
                        title: 'Managed Resource Paths',
                        subtitle: 'Comma-separated list of managed paths.',
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
