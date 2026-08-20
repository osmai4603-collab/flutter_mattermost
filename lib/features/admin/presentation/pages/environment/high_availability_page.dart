import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class HighAvailabilityPage extends StatefulWidget {
  const HighAvailabilityPage({super.key});

  @override
  State<HighAvailabilityPage> createState() => _HighAvailabilityPageState();
}

class _HighAvailabilityPageState extends State<HighAvailabilityPage> {
  final _adminConfigRepository = getIt<AdminConfigRepository>();
  bool _isSaving = false;

  bool _enableHA = false;
  final _clusterNameController = TextEditingController();
  final _overrideHostnameController = TextEditingController();
  bool _useIPAddress = false;
  bool _enableGossipEncryption = false;
  bool _enableGossipCompression = false;
  final _gossipPortController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _clusterNameController.dispose();
    _overrideHostnameController.dispose();
    _gossipPortController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await _adminConfigRepository.getConfig();
    setState(() {
      _enableHA = config['ClusterSettings.Enable'] == 'true';
      _clusterNameController.text = config['ClusterSettings.ClusterName'] ?? '';
      _overrideHostnameController.text =
          config['ClusterSettings.OverrideHostname'] ?? '';
      _useIPAddress = config['ClusterSettings.UseIPAddress'] == 'true';
      _enableGossipEncryption =
          config['ClusterSettings.EnableGossipEncryption'] == 'true';
      _enableGossipCompression =
          config['ClusterSettings.EnableGossipCompression'] == 'true';
      _gossipPortController.text = config['ClusterSettings.GossipPort'] ?? '';
    });
  }

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      await _adminConfigRepository.patchConfig({
        'ClusterSettings.Enable': _enableHA.toString(),
        'ClusterSettings.ClusterName': _clusterNameController.text,
        'ClusterSettings.OverrideHostname': _overrideHostnameController.text,
        'ClusterSettings.UseIPAddress': _useIPAddress.toString(),
        'ClusterSettings.EnableGossipEncryption': _enableGossipEncryption
            .toString(),
        'ClusterSettings.EnableGossipCompression': _enableGossipCompression
            .toString(),
        'ClusterSettings.GossipPort': _gossipPortController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('High availability settings saved successfully'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MattermostColors>()!;

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
              'High Availability',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.buttonBg.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.buttonBg.withValues(alpha: 0.30),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colors.buttonBg, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Changing properties in this section will require a server restart before taking effect.',
                      style: TextStyle(
                        color: colors.centerChannelColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              colors,
              children: [
                _boolTile(
                  colors,
                  value: _enableHA,
                  onChanged: (v) => setState(() => _enableHA = v ?? false),
                  title: 'Enable High Availability Mode',
                  subtitle:
                      'When true, Mattermost will run in High Availability mode.',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _clusterNameController,
                  title: 'Cluster Name',
                  subtitle: 'The cluster to join by name.',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _overrideHostnameController,
                  title: 'Override Hostname',
                  subtitle: 'Default blank tries OS hostname or IP.',
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _useIPAddress,
                  onChanged: (v) => setState(() => _useIPAddress = v ?? false),
                  title: 'Use IP Address',
                  subtitle: 'When true, cluster communicates via IP Address.',
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _enableGossipEncryption,
                  onChanged: (v) =>
                      setState(() => _enableGossipEncryption = v ?? false),
                  title: 'Enable Gossip Encryption',
                  subtitle:
                      'When true, gossip protocol communication will be encrypted.',
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _enableGossipCompression,
                  onChanged: (v) =>
                      setState(() => _enableGossipCompression = v ?? false),
                  title: 'Enable Gossip Compression',
                  subtitle:
                      'When true, gossip protocol communication will be compressed.',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _gossipPortController,
                  title: 'Gossip Port',
                  subtitle: 'The port used for gossip protocol.',
                  placeholder: '8074',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
