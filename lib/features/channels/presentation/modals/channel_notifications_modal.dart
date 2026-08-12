import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';

/// إعدادات إشعارات القناة — مطابق channel_notifications في webapp:
/// مستوى الإشعارات (الكل/الإشارات فقط/لا شيء) مع حفظ على الخادم.
class ChannelNotificationsModal extends StatefulWidget {
  const ChannelNotificationsModal({super.key});

  @override
  State<ChannelNotificationsModal> createState() =>
      _ChannelNotificationsModalState();
}

class _ChannelNotificationsModalState
    extends State<ChannelNotificationsModal> {
  int _selected = 0;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final state = context.read<ChannelBloc>().state;
    final channel = state is ChannelsLoadedState ? state.selectedChannel : null;
    final level = channel == null ? 'all' : 'all';
    _selected = switch (level) {
      'all' => 0,
      'mentions' => 1,
      'none' => 2,
      _ => 0,
    };
  }

  Future<void> _save() async {
    final state = context.read<ChannelBloc>().state;
    final channel = state is ChannelsLoadedState ? state.selectedChannel : null;
    if (channel == null) return;
    final level = switch (_selected) {
      0 => 'all',
      1 => 'mentions',
      _ => 'none',
    };
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await getIt<ChannelRepository>().updateChannel(
        channel.id,
        {'notify_props': {'desktop': level}},
      );
      if (mounted) {
        setState(() => _saving = false);
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Save failed';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: theme.centerChannelBg,
      insetPadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.channelNotificationsTitle,
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: theme.centerChannelColor.withValues(alpha: 0.7),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.channelNotificationsLevel,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _option(
                    theme,
                    l10n.channelNotificationsAll,
                    l10n.channelNotificationsAllDescription,
                    0,
                  ),
                  const SizedBox(height: 8),
                  _option(
                    theme,
                    l10n.channelNotificationsMentions,
                    l10n.channelNotificationsMentionsDescription,
                    1,
                  ),
                  const SizedBox(height: 8),
                  _option(
                    theme,
                    l10n.channelNotificationsNone,
                    l10n.channelNotificationsNoneDescription,
                    2,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.error_outline,
                            size: 16, color: Colors.redAccent),
                        const SizedBox(width: 6),
                        Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.redAccent,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.buttonBg,
                        foregroundColor: theme.buttonColor,
                      ),
                      child: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child:
                                  CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              l10n.channelNotificationsSave,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _option(
    MattermostColors theme,
    String title,
    String description,
    int index,
  ) {
    final selected = _selected == index;
    return InkWell(
      onTap: () => setState(() => _selected = index),
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: selected
                ? theme.buttonBg
                : theme.centerChannelColor.withValues(alpha: 0.16),
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              size: 20,
              color: selected
                  ? theme.buttonBg
                  : theme.centerChannelColor.withValues(alpha: 0.4),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: theme.centerChannelColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
