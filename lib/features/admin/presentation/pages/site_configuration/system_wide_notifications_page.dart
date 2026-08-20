import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class SystemWideNotificationsPage extends StatefulWidget {
  const SystemWideNotificationsPage({super.key});

  @override
  State<SystemWideNotificationsPage> createState() =>
      _SystemWideNotificationsPageState();
}

class _SystemWideNotificationsPageState
    extends State<SystemWideNotificationsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableBanner = false;
  final TextEditingController _bannerTextController = TextEditingController();
  Color _bannerColor = const Color(0xFFFFFFFF);
  Color _bannerTextColor = const Color(0xFFFFFFFF);
  bool _allowBannerDismissal = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  @override
  void dispose() {
    _bannerTextController.dispose();
    super.dispose();
  }

  Color _colorFromHex(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final announcementSettings =
          (config['AnnouncementSettings'] as Map<String, dynamic>?) ?? const {};

      _enableBanner = announcementSettings['EnableBanner'] == true;
      _bannerTextController.text =
          (announcementSettings['BannerText'] as String?) ?? '';
      _bannerColor = _colorFromHex(
        (announcementSettings['BannerColor'] as String?) ?? '#fff',
      );
      _bannerTextColor = _colorFromHex(
        (announcementSettings['BannerTextColor'] as String?) ?? '#fff',
      );
      _allowBannerDismissal =
          announcementSettings['AllowBannerDismissal'] == true;
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
        'AnnouncementSettings': {
          'EnableBanner': _enableBanner,
          'BannerText': _bannerTextController.text.trim(),
          'BannerColor': _colorToHex(_bannerColor),
          'BannerTextColor': _colorToHex(_bannerTextColor),
          'AllowBannerDismissal': _allowBannerDismissal,
        },
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('System-wide Notification settings saved'),
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

  Future<void> _pickColor({required bool isBackground}) async {
    final initialColor = isBackground ? _bannerColor : _bannerTextColor;
    final picked = await showColorPicker(initialColor: initialColor);
    if (picked != null) {
      setState(() {
        if (isBackground) {
          _bannerColor = picked;
        } else {
          _bannerTextColor = picked;
        }
      });
    }
  }

  Future<Color?> showColorPicker({required Color initialColor}) async {
    return showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            initialColor: initialColor,
            onColorSelected: (color) => Navigator.of(context).pop(color),
          ),
        ),
      ),
    );
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
              'System Wide Notifications',
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
                  _buildBannerSection(colors),
                  const SizedBox(height: 20),
                  _buildAppearanceSection(colors),
                ],
              ),
            ),
    );
  }

  Widget _buildBannerSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _boolTile(
          colors,
          value: _enableBanner,
          onChanged: (v) {
            if (v != null) setState(() => _enableBanner = v);
          },
          title: 'Enable System-wide Notifications',
          subtitle:
              'Enable an announcement banner across all teams. When enabled, a banner is displayed at the top of the screen for all users.',
        ),
        if (_enableBanner) ...[
          _divider(colors),
          _textTile(
            colors,
            controller: _bannerTextController,
            title: 'Banner Text',
            subtitle:
                'Text to display in the announcement banner. This supports basic text formatting.',
            placeholder: 'Enter announcement text...',
          ),
        ],
      ],
    );
  }

  Widget _buildAppearanceSection(MattermostColors colors) {
    return _sectionCard(
      colors,
      children: [
        _colorTile(
          colors,
          title: 'Banner Color',
          color: _bannerColor,
          onTap: _enableBanner ? () => _pickColor(isBackground: true) : null,
        ),
        _divider(colors),
        _colorTile(
          colors,
          title: 'Banner Text Color',
          color: _bannerTextColor,
          onTap: _enableBanner ? () => _pickColor(isBackground: false) : null,
        ),
        _divider(colors),
        _boolTile(
          colors,
          value: _allowBannerDismissal,
          onChanged: _enableBanner
              ? (v) {
                  if (v != null) setState(() => _allowBannerDismissal = v);
                }
              : null,
          title: 'Allow Banner Dismissal',
          subtitle:
              'When true, users can dismiss the banner. When false, the banner is permanently visible until disabled.',
        ),
      ],
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

  Widget _colorTile(
    MattermostColors colors, {
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: colors.centerChannelColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: colors.centerChannelColor.withValues(alpha: 0.20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ColorPicker extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPicker({
    super.key,
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _selectedColor;
  late TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _hexController = TextEditingController(
      text:
          '#${_selectedColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _hexController,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              labelText: 'Hex Color',
              hintText: '#FFFFFF',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              try {
                final hex = value.replaceAll('#', '');
                if (hex.length == 6 || hex.length == 8) {
                  setState(
                    () => _selectedColor = Color(
                      int.parse(
                        'FF${hex.padLeft(8, 'FF').substring(hex.length > 6 ? 2 : 0)}',
                        radix: 16,
                      ),
                    ),
                  );
                }
              } catch (_) {}
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                [
                      Colors.red,
                      Colors.pink,
                      Colors.purple,
                      Colors.deepPurple,
                      Colors.indigo,
                      Colors.blue,
                      Colors.teal,
                      Colors.green,
                      Colors.orange,
                      Colors.amber,
                      Colors.brown,
                      Colors.grey,
                    ]
                    .map(
                      (c) => GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedColor = c;
                            _hexController.text =
                                '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(4),
                            border: _selectedColor.toARGB32() == c.toARGB32()
                                ? Border.all(width: 2)
                                : null,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => widget.onColorSelected(_selectedColor),
                child: const Text('Select'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
