import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';

/// إعدادات إشعارات القناة — مطابق channel_notifications في webapp:
/// مستوى الإشعارات (الكل/الإشارات فقط/لا شيء) لسطح المكتب والهاتف
/// مع حفظ على الخادم، وخيار كتم القناة تلقائياً (Auto-Mute).
class ChannelNotificationsModal extends StatefulWidget {
  /// القناة المستهدفة — عند غيابها تُستخدم القناة المحددة حالياً.
  final ChannelEntity? channel;

  const ChannelNotificationsModal({super.key, this.channel});

  @override
  State<ChannelNotificationsModal> createState() =>
      _ChannelNotificationsModalState();
}

class _ChannelNotificationsModalState extends State<ChannelNotificationsModal> {
  ChannelEntity? _channel;
  int _selectedDesktop = 0;
  int _selectedMobile = 0;
  bool _isMuted = false;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final state = context.read<ChannelBloc>().state;
    _channel =
        widget.channel ??
        (state is ChannelsLoadedState ? state.selectedChannel : null);
    final channel = _channel;
    final member = state is ChannelsLoadedState && channel != null
        ? state.members[channel.id]
        : null;
    _selectedDesktop = _levelIndex(member?.notifyProps['desktop'] ?? 'all');
    _selectedMobile = _levelIndex(member?.notifyProps['push'] ?? 'all');
    _isMuted = member?.notifyProps['mark_unread'] == 'mention';
  }

  int _levelIndex(Object? level) => switch (level) {
    'all' => 0,
    'mention' || 'mentions' => 1,
    'none' => 2,
    _ => 0,
  };

  String _levelValue(int index) => switch (index) {
    0 => 'all',
    1 => 'mention',
    _ => 'none',
  };

  Future<void> _save() async {
    final channel = _channel;
    if (channel == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await getIt<ChannelRepository>().updateChannel(
        channel.id,
        notifyProps: {
          'desktop': _levelValue(_selectedDesktop),
          'push': _levelValue(_selectedMobile),
        },
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
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
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
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _groupLabel(theme, l10n.channelNotificationsDesktopNotificationsTitle2),
                    const SizedBox(height: 8),
                    _option(
                      theme,
                      l10n.channelNotificationsAll,
                      l10n.channelNotificationsAllDescription,
                      _selectedDesktop,
                      0,
                      isMobile: false,
                    ),
                    const SizedBox(height: 8),
                    _option(
                      theme,
                      l10n.channelNotificationsMentions,
                      l10n.channelNotificationsMentionsDescription,
                      _selectedDesktop,
                      1,
                      isMobile: false,
                    ),
                    const SizedBox(height: 8),
                    _option(
                      theme,
                      l10n.channelNotificationsNone,
                      l10n.channelNotificationsNoneDescription,
                      _selectedDesktop,
                      2,
                      isMobile: false,
                    ),
                    const SizedBox(height: 24),
                    _groupLabel(theme, l10n.channelNotificationsMobileNotificationsTitle),
                    const SizedBox(height: 8),
                    _option(
                      theme,
                      l10n.channelNotificationsAll,
                      l10n.channelNotificationsAllDescription,
                      _selectedMobile,
                      0,
                      isMobile: true,
                    ),
                    const SizedBox(height: 8),
                    _option(
                      theme,
                      l10n.channelNotificationsMentions,
                      l10n.channelNotificationsMentionsDescription,
                      _selectedMobile,
                      1,
                      isMobile: true,
                    ),
                    const SizedBox(height: 8),
                    _option(
                      theme,
                      l10n.channelNotificationsNone,
                      l10n.channelNotificationsNoneDescription,
                      _selectedMobile,
                      2,
                      isMobile: true,
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _isMuted,
                      onChanged: _saving
                          ? null
                          : (value) {
                              final channel = _channel;
                              if (channel == null) return;
                              setState(() => _isMuted = value);
                              final userId =
                                  context.read<ChannelBloc>().state
                                          is ChannelsLoadedState
                                      ? (context
                                                  .read<ChannelBloc>()
                                                  .state
                                              as ChannelsLoadedState)
                                          .userId
                                      : '';
                              context.read<ChannelBloc>().add(
                                ToggleMuteEvent(
                                  channelId: channel.id,
                                  userId: userId,
                                ),
                              );
                            },
                      activeColor: theme.buttonBg,
                      title: Text(
                        l10n.channelNotificationsMuteChannelTitle,
                        style: TextStyle(
                          color: theme.centerChannelColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        l10n.channelNotificationsMuteChannelDesc,
                        style: TextStyle(
                          color: theme.centerChannelColor.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 16,
                            color: Colors.redAccent,
                          ),
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
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                l10n.channelNotificationsSave,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _groupLabel(MattermostColors theme, String title) {
    return Text(
      title,
      style: TextStyle(
        color: theme.centerChannelColor,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _option(
    MattermostColors theme,
    String title,
    String description,
    int selected,
    int index, {
    required bool isMobile,
  }) {
    final isSelected = (isMobile ? _selectedMobile : _selectedDesktop) == index;
    return InkWell(
      onTap: () => setState(() {
        if (isMobile) {
          _selectedMobile = index;
        } else {
          _selectedDesktop = index;
        }
      }),
      borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? theme.buttonBg
                : theme.centerChannelColor.withValues(alpha: 0.16),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 20,
              color: isSelected
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