import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class CacheSettingsPage extends StatefulWidget {
  const CacheSettingsPage({super.key});

  @override
  State<CacheSettingsPage> createState() => _CacheSettingsPageState();
}

class _CacheSettingsPageState extends State<CacheSettingsPage> {
  final _adminConfigRepository = getIt<AdminConfigRepository>();
  bool _isSaving = false;

  String _cacheType = 'lru';
  final _redisAddressController = TextEditingController();
  final _redisPasswordController = TextEditingController();
  final _redisDBController = TextEditingController();
  bool _disableClientCache = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _redisAddressController.dispose();
    _redisPasswordController.dispose();
    _redisDBController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await _adminConfigRepository.getConfig();
    setState(() {
      _cacheType = config['CacheSettings.CacheType'] ?? 'lru';
      _redisAddressController.text = config['CacheSettings.RedisAddress'] ?? '';
      _redisPasswordController.text =
          config['CacheSettings.RedisPassword'] ?? '';
      _redisDBController.text = config['CacheSettings.RedisDB'] ?? '';
      _disableClientCache =
          config['CacheSettings.DisableClientCache'] == 'true';
    });
  }

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      await _adminConfigRepository.patchConfig({
        'CacheSettings.CacheType': _cacheType,
        'CacheSettings.RedisAddress': _redisAddressController.text,
        'CacheSettings.RedisPassword': _redisPasswordController.text,
        'CacheSettings.RedisDB': _redisDBController.text,
        'CacheSettings.DisableClientCache': _disableClientCache.toString(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache settings saved successfully')),
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
              'Cache Settings',
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
                _dropdownTile(
                  colors,
                  value: _cacheType,
                  onChanged: (v) => setState(() => _cacheType = v ?? 'lru'),
                  title: 'Cache Type',
                  subtitle: 'The type of cache backend.',
                  options: {'lru': 'LRU', 'redis': 'Redis'},
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _redisAddressController,
                  title: 'Redis Address',
                  subtitle: 'The hostname:port of the Redis server.',
                  placeholder: 'localhost:6379',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _redisPasswordController,
                  title: 'Redis Password',
                  subtitle: 'The password of the Redis server.',
                ),
                _divider(colors),
                _numberTile(
                  colors,
                  controller: _redisDBController,
                  title: 'Redis DB',
                  subtitle: 'The database of the Redis server.',
                  placeholder: '0',
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _disableClientCache,
                  onChanged: (v) =>
                      setState(() => _disableClientCache = v ?? false),
                  title: 'Disable Client Cache',
                  subtitle: 'When true, client-side caching is disabled.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
