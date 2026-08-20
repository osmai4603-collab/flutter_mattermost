import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class RateLimitingPage extends StatefulWidget {
  const RateLimitingPage({super.key});

  @override
  State<RateLimitingPage> createState() => _RateLimitingPageState();
}

class _RateLimitingPageState extends State<RateLimitingPage> {
  final _adminConfigRepository = getIt<AdminConfigRepository>();
  bool _isSaving = false;

  bool _enableRateLimiting = false;
  final _perSecController = TextEditingController();
  final _maxBurstController = TextEditingController();
  final _memoryStoreSizeController = TextEditingController();
  bool _varyByRemoteAddr = false;
  bool _varyByUser = false;
  final _varyByHeaderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _perSecController.dispose();
    _maxBurstController.dispose();
    _memoryStoreSizeController.dispose();
    _varyByHeaderController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await _adminConfigRepository.getConfig();
    setState(() {
      _enableRateLimiting = config['RateLimitSettings.Enable'] == 'true';
      _perSecController.text = config['RateLimitSettings.PerSec'] ?? '';
      _maxBurstController.text = config['RateLimitSettings.MaxBurst'] ?? '';
      _memoryStoreSizeController.text =
          config['RateLimitSettings.MemoryStoreSize'] ?? '';
      _varyByRemoteAddr =
          config['RateLimitSettings.VaryByRemoteAddr'] == 'true';
      _varyByUser = config['RateLimitSettings.VaryByUser'] == 'true';
      _varyByHeaderController.text =
          config['RateLimitSettings.VaryByHeader'] ?? '';
    });
  }

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      await _adminConfigRepository.patchConfig({
        'RateLimitSettings.Enable': _enableRateLimiting.toString(),
        'RateLimitSettings.PerSec': _perSecController.text,
        'RateLimitSettings.MaxBurst': _maxBurstController.text,
        'RateLimitSettings.MemoryStoreSize': _memoryStoreSizeController.text,
        'RateLimitSettings.VaryByRemoteAddr': _varyByRemoteAddr.toString(),
        'RateLimitSettings.VaryByUser': _varyByUser.toString(),
        'RateLimitSettings.VaryByHeader': _varyByHeaderController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rate limiting settings saved successfully'),
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
              'Rate Limiting',
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
                  value: _enableRateLimiting,
                  onChanged: (v) =>
                      setState(() => _enableRateLimiting = v ?? false),
                  title: 'Enable Rate Limiting',
                  subtitle: 'When true, APIs are throttled at specified rates.',
                ),
                _divider(colors),
                _numberTile(
                  colors,
                  controller: _perSecController,
                  title: 'Maximum Queries per Second',
                  subtitle: 'Throttles API at this rate.',
                  placeholder: '10',
                ),
                _divider(colors),
                _numberTile(
                  colors,
                  controller: _maxBurstController,
                  title: 'Maximum Burst Size',
                  subtitle:
                      'Maximum number of requests beyond per second limit.',
                  placeholder: '100',
                ),
                _divider(colors),
                _numberTile(
                  colors,
                  controller: _memoryStoreSizeController,
                  title: 'Memory Store Size',
                  subtitle: 'Maximum number of user sessions.',
                  placeholder: '10000',
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _varyByRemoteAddr,
                  onChanged: (v) =>
                      setState(() => _varyByRemoteAddr = v ?? false),
                  title: 'Vary Rate Limit by Remote Address',
                  subtitle: 'Rate limit by IP address.',
                ),
                _divider(colors),
                _boolTile(
                  colors,
                  value: _varyByUser,
                  onChanged: (v) => setState(() => _varyByUser = v ?? false),
                  title: 'Vary Rate Limit by User',
                  subtitle: 'Rate limit by user authentication token.',
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _varyByHeaderController,
                  title: 'Vary Rate Limit by HTTP Header',
                  subtitle: 'Vary by HTTP header field.',
                  placeholder: 'X-Real-IP, X-Forwarded-For',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
