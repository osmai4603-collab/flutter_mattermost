import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class ElasticsearchPage extends StatefulWidget {
  const ElasticsearchPage({super.key});

  @override
  State<ElasticsearchPage> createState() => _ElasticsearchPageState();
}

class _ElasticsearchPageState extends State<ElasticsearchPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  // Indexing
  bool _enableIndexing = false;
  final TextEditingController _backendController = TextEditingController();
  final TextEditingController _connectionUrlController =
      TextEditingController();
  final TextEditingController _caController = TextEditingController();
  final TextEditingController _clientCertController = TextEditingController();
  final TextEditingController _clientKeyController = TextEditingController();
  bool _skipTlsVerification = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _sniff = false;

  // Search Queries
  bool _enableSearching = false;
  bool _enableAutocomplete = false;
  bool _enableSearchPublicChannelsWithoutMembership = false;
  final TextEditingController _ignoredPurgeIndexesController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _backendController.dispose();
    _connectionUrlController.dispose();
    _caController.dispose();
    _clientCertController.dispose();
    _clientKeyController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _ignoredPurgeIndexesController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final esSettings =
          (config['ElasticsearchSettings'] as Map<String, dynamic>?) ??
          const {};

      _enableIndexing = esSettings['EnableIndexing'] == true;
      _backendController.text = (esSettings['Backend'] as String?) ?? '';
      _connectionUrlController.text =
          (esSettings['ConnectionURL'] as String?) ?? '';
      _caController.text = (esSettings['CA'] as String?) ?? '';
      _clientCertController.text = (esSettings['ClientCert'] as String?) ?? '';
      _clientKeyController.text = (esSettings['ClientKey'] as String?) ?? '';
      _skipTlsVerification = esSettings['SkipTLSVerification'] == true;
      _usernameController.text = (esSettings['Username'] as String?) ?? '';
      _passwordController.text = (esSettings['Password'] as String?) ?? '';
      _sniff = esSettings['Sniff'] == true;
      _enableSearching = esSettings['EnableSearching'] == true;
      _enableAutocomplete = esSettings['EnableAutocomplete'] == true;
      _enableSearchPublicChannelsWithoutMembership =
          esSettings['EnableSearchPublicChannelsWithoutMembership'] == true;
      _ignoredPurgeIndexesController.text =
          (esSettings['IgnoredPurgeIndexes'] as String?) ?? '';
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
        'ElasticsearchSettings': {
          'EnableIndexing': _enableIndexing,
          'Backend': _backendController.text.trim(),
          'ConnectionURL': _connectionUrlController.text.trim(),
          'CA': _caController.text.trim(),
          'ClientCert': _clientCertController.text.trim(),
          'ClientKey': _clientKeyController.text.trim(),
          'SkipTLSVerification': _skipTlsVerification,
          'Username': _usernameController.text.trim(),
          'Password': _passwordController.text.trim(),
          'Sniff': _sniff,
          'EnableSearching': _enableSearching,
          'EnableAutocomplete': _enableAutocomplete,
          'EnableSearchPublicChannelsWithoutMembership':
              _enableSearchPublicChannelsWithoutMembership,
          'IgnoredPurgeIndexes': _ignoredPurgeIndexesController.text.trim(),
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
              'Elasticsearch',
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
                        'Indexing',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _enableIndexing,
                        onChanged: (v) {
                          if (v != null) setState(() => _enableIndexing = v);
                        },
                        title: 'Enable Elasticsearch Indexing',
                        subtitle:
                            'When true, indexing of new posts occurs automatically.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _backendController,
                        title: 'Backend Type',
                        subtitle: 'The type of search backend.',
                        placeholder: 'elasticsearch',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _connectionUrlController,
                        title: 'Server Connection Address',
                        subtitle: 'The address of the Elasticsearch server.',
                        placeholder: 'https://elasticsearch.example.org:9200',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _caController,
                        title: 'CA Path',
                        subtitle: 'Custom Certificate Authority certificates.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _clientCertController,
                        title: 'Client Certificate Path',
                        subtitle: 'The client certificate in PEM format.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _clientKeyController,
                        title: 'Client Certificate Key Path',
                        subtitle:
                            'The key for the client certificate in PEM format.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _skipTlsVerification,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _skipTlsVerification = v);
                        },
                        title: 'Skip TLS Verification',
                        subtitle:
                            'When true, will not require certificate to be signed by a trusted CA.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _usernameController,
                        title: 'Server Username',
                        subtitle: 'Username to authenticate to Elasticsearch.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _passwordController,
                        title: 'Server Password',
                        subtitle: 'Password to authenticate to Elasticsearch.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _sniff,
                        onChanged: (v) {
                          if (v != null) setState(() => _sniff = v);
                        },
                        title: 'Enable Cluster Sniffing',
                        subtitle:
                            'When true, finds and connects to all data nodes automatically.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _sectionCard(
                    colors,
                    children: [
                      Text(
                        'Search Queries',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _boolTile(
                        colors,
                        value: _enableSearching,
                        onChanged: (v) {
                          if (v != null) setState(() => _enableSearching = v);
                        },
                        title: 'Enable Elasticsearch for Search Queries',
                        subtitle:
                            'When true, Elasticsearch is used for all search queries.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _enableAutocomplete,
                        onChanged: (v) {
                          if (v != null)
                            setState(() => _enableAutocomplete = v);
                        },
                        title: 'Enable Elasticsearch for Autocomplete',
                        subtitle:
                            'When true, used for all autocompletion queries.',
                      ),
                      _divider(colors),
                      _boolTile(
                        colors,
                        value: _enableSearchPublicChannelsWithoutMembership,
                        onChanged: (v) {
                          if (v != null)
                            setState(
                              () =>
                                  _enableSearchPublicChannelsWithoutMembership =
                                      v,
                            );
                        },
                        title:
                            'Allow Searching Public Channels Without Membership',
                        subtitle:
                            'When enabled, users can find messages in public channels they have not joined.',
                      ),
                      _divider(colors),
                      _textTile(
                        colors,
                        controller: _ignoredPurgeIndexesController,
                        title: 'Indexes to Skip While Purging',
                        subtitle:
                            'Comma-separated indexes to ignore during purge.',
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
