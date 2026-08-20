import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_config_repository.dart';

class GifSettingsPage extends StatefulWidget {
  const GifSettingsPage({super.key});

  @override
  State<GifSettingsPage> createState() => _GifSettingsPageState();
}

class _GifSettingsPageState extends State<GifSettingsPage> {
  final AdminConfigRepository _repository = getIt<AdminConfigRepository>();

  bool _isLoading = true;
  bool _isSaving = false;

  bool _enableGifPicker = false;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    setState(() => _isLoading = true);
    try {
      final config = await _repository.getConfig();
      final serviceSettings =
          (config['ServiceSettings'] as Map<String, dynamic>?) ?? const {};

      _enableGifPicker = serviceSettings['EnableGifPicker'] == true;
    } catch (_) {
      // Keep defaults
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveConfig() async {
    final colors = AppTheme.of(context);
    setState(() => _isSaving = true);
    try {
      final patch = {
        'ServiceSettings': {'EnableGifPicker': _enableGifPicker},
      };
      await _repository.patchConfig(patch);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('GIF settings saved'),
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
              'GIF Settings',
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
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GIF',
                              style: TextStyle(
                                color: colors.centerChannelColor,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Configure GIF picker settings.',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.54,
                                ),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveConfig,
                        icon: _isSaving
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.centerChannelColor,
                                ),
                              )
                            : const Icon(Icons.save_rounded, size: 18),
                        label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.buttonBg,
                          foregroundColor: colors.buttonColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Settings
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: colors.centerChannelBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.10,
                        ),
                      ),
                    ),
                    child: SwitchListTile(
                      value: _enableGifPicker,
                      onChanged: (v) => setState(() => _enableGifPicker = v),
                      activeThumbColor: colors.buttonBg,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        'Enable GIF Picker',
                        style: TextStyle(
                          color: colors.centerChannelColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Allows users to select GIFs from the emoji picker.',
                        style: TextStyle(
                          color: colors.centerChannelColor.withValues(
                            alpha: 0.54,
                          ),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
