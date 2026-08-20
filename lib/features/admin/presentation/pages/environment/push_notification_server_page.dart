import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class PushNotificationServerPage extends StatefulWidget {
  const PushNotificationServerPage({super.key});

  @override
  State<PushNotificationServerPage> createState() =>
      _PushNotificationServerPageState();
}

class _PushNotificationServerPageState
    extends State<PushNotificationServerPage> {
  final _adminConfigRepository = getIt<AdminConfigRepository>();
  bool _isSaving = false;

  String _sendPushNotifications = 'off';
  final _pushNotificationServerController = TextEditingController();
  final _maxNotificationsPerChannelController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _pushNotificationServerController.dispose();
    _maxNotificationsPerChannelController.dispose();
    super.dispose();
  }

  Future<void> _loadConfig() async {
    final config = await _adminConfigRepository.getConfig();
    setState(() {
      _sendPushNotifications = config['SendPushNotifications'] ?? 'off';
      _pushNotificationServerController.text =
          config['PushNotificationServer'] ?? '';
      _maxNotificationsPerChannelController.text =
          config['MaxNotificationsPerChannel'] ?? '';
    });
  }

  Future<void> _saveConfig() async {
    setState(() => _isSaving = true);
    try {
      await _adminConfigRepository.patchConfig({
        'SendPushNotifications': _sendPushNotifications,
        'PushNotificationServer': _pushNotificationServerController.text,
        'MaxNotificationsPerChannel':
            _maxNotificationsPerChannelController.text,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Push notification settings saved successfully'),
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
              'Push Notification Server',
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
            _sectionCard(
              colors,
              children: [
                Text(
                  'Push Notifications',
                  style: TextStyle(
                    color: colors.centerChannelColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _dropdownTile(
                  colors,
                  value: _sendPushNotifications,
                  onChanged: (v) =>
                      setState(() => _sendPushNotifications = v ?? 'off'),
                  title: 'Enable Push Notifications',
                  subtitle: 'Select how push notifications are sent.',
                  options: {
                    'off': 'Off',
                    'mhpns': 'Use HPNS (licensed only)',
                    'mtpns': 'Use TPNS',
                    'custom': 'Custom',
                  },
                ),
                _divider(colors),
                _textTile(
                  colors,
                  controller: _pushNotificationServerController,
                  title: 'Push Notification Server',
                  subtitle: 'The URL of the push notification server.',
                  placeholder: 'https://push-test.mattermost.com',
                ),
                _divider(colors),
                _numberTile(
                  colors,
                  controller: _maxNotificationsPerChannelController,
                  title: 'Large Channel Notification Threshold',
                  subtitle: 'Max users for @here/@all/@channel mentions.',
                  placeholder: '1000',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
