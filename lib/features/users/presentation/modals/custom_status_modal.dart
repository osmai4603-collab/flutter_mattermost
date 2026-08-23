import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/generic_modal.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_status_bloc.dart';

enum CustomStatusDurationOption {
  dontClear,
  thirtyMinutes,
  oneHour,
  fourHours,
  today,
  thisWeek,
  customDateTime,
}

class CustomStatusSuggestionItem {
  final String emoji;
  final String text;
  final CustomStatusDurationOption duration;

  const CustomStatusSuggestionItem({
    required this.emoji,
    required this.text,
    required this.duration,
  });
}

class CustomStatusModal extends StatefulWidget {
  const CustomStatusModal({super.key});

  @override
  State<CustomStatusModal> createState() => _CustomStatusModalState();
}

class _CustomStatusModalState extends State<CustomStatusModal> {
  late final TextEditingController _textController;
  String _selectedEmoji = '💬';
  CustomStatusDurationOption _selectedDuration =
      CustomStatusDurationOption.today;
  DateTime? _customExpiryTime;
  bool _isLoading = false;

  static const List<CustomStatusSuggestionItem> _defaultSuggestions = [
    CustomStatusSuggestionItem(
      emoji: '📅',
      text: 'In a meeting',
      duration: CustomStatusDurationOption.oneHour,
    ),
    CustomStatusSuggestionItem(
      emoji: '🍔',
      text: 'Out for lunch',
      duration: CustomStatusDurationOption.thirtyMinutes,
    ),
    CustomStatusSuggestionItem(
      emoji: '🤧',
      text: 'Out sick',
      duration: CustomStatusDurationOption.today,
    ),
    CustomStatusSuggestionItem(
      emoji: '🏠',
      text: 'Working from home',
      duration: CustomStatusDurationOption.today,
    ),
    CustomStatusSuggestionItem(
      emoji: '🌴',
      text: 'On a vacation',
      duration: CustomStatusDurationOption.thisWeek,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  String _durationLabel(
    AppLocalizations l10n,
    CustomStatusDurationOption option,
  ) {
    switch (option) {
      case CustomStatusDurationOption.dontClear:
        return 'Don\'t clear';
      case CustomStatusDurationOption.thirtyMinutes:
        return '30 mins';
      case CustomStatusDurationOption.oneHour:
        return '1 hour';
      case CustomStatusDurationOption.fourHours:
        return '4 hours';
      case CustomStatusDurationOption.today:
        return 'Today';
      case CustomStatusDurationOption.thisWeek:
        return 'This week';
      case CustomStatusDurationOption.customDateTime:
        return 'Choose date and time';
    }
  }

  String? _durationValueString(CustomStatusDurationOption option) {
    switch (option) {
      case CustomStatusDurationOption.dontClear:
        return null;
      case CustomStatusDurationOption.thirtyMinutes:
        return 'thirty_minutes';
      case CustomStatusDurationOption.oneHour:
        return 'one_hour';
      case CustomStatusDurationOption.fourHours:
        return 'four_hours';
      case CustomStatusDurationOption.today:
        return 'today';
      case CustomStatusDurationOption.thisWeek:
        return 'this_week';
      case CustomStatusDurationOption.customDateTime:
        return 'date_and_time';
    }
  }

  String? _calculateExpiresAt(CustomStatusDurationOption option) {
    final now = DateTime.now();
    DateTime? dt;
    switch (option) {
      case CustomStatusDurationOption.dontClear:
        return null;
      case CustomStatusDurationOption.thirtyMinutes:
        dt = now.add(const Duration(minutes: 30));
        break;
      case CustomStatusDurationOption.oneHour:
        dt = now.add(const Duration(hours: 1));
        break;
      case CustomStatusDurationOption.fourHours:
        dt = now.add(const Duration(hours: 4));
        break;
      case CustomStatusDurationOption.today:
        dt = DateTime(now.year, now.month, now.day, 23, 59, 59);
        break;
      case CustomStatusDurationOption.thisWeek:
        final daysUntilEndOfWeek = 7 - now.weekday;
        dt = DateTime(
          now.year,
          now.month,
          now.day + daysUntilEndOfWeek,
          23,
          59,
          59,
        );
        break;
      case CustomStatusDurationOption.customDateTime:
        dt = _customExpiryTime;
        break;
    }
    return dt?.toUtc().toIso8601String();
  }

  void _onSuggestionTap(CustomStatusSuggestionItem suggestion) {
    setState(() {
      _selectedEmoji = suggestion.emoji;
      _textController.text = suggestion.text;
      _selectedDuration = suggestion.duration;
    });
  }

  Future<void> _handleSaveStatus() async {
    final text = _textController.text.trim();
    if (text.length > 100) return;

    setState(() => _isLoading = true);
    try {
      final expiresAt = _calculateExpiresAt(_selectedDuration);
      final durationStr = _durationValueString(_selectedDuration);

      await getIt<UserRepository>().updateMyCustomStatus(
        emoji: _selectedEmoji,
        text: text,
        duration: durationStr,
        expiresAt: expiresAt,
      );

      if (mounted) {
        context.read<UserStatusBloc>().add(const LoadMyStatusEvent('me'));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleClearStatus() async {
    setState(() => _isLoading = true);
    try {
      await getIt<UserRepository>().unsetMyCustomStatus();
      if (mounted) {
        context.read<UserStatusBloc>().add(const LoadMyStatusEvent('me'));
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showCustomDateTimePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _customExpiryTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _selectedDuration = CustomStatusDurationOption.customDateTime;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final isTextValid = _textController.text.length <= 100;

    return GenericModal(
      title: 'Set a status',
      confirmLabel: _isLoading ? 'Saving...' : 'Set Status',
      dismissLabel: 'Clear Status',
      onConfirm: isTextValid && !_isLoading ? _handleSaveStatus : null,
      onDismiss: _handleClearStatus,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emoji + Text Input Bar
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.centerChannelColor.withValues(alpha: 0.2),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      final emojis = [
                        '💬',
                        '📅',
                        '🍔',
                        '🤧',
                        '🏠',
                        '🌴',
                        '🚀',
                        '⭐',
                        '💡',
                        '☕',
                      ];
                      final currentIndex = emojis.indexOf(_selectedEmoji);
                      final nextIndex = (currentIndex + 1) % emojis.length;
                      setState(() {
                        _selectedEmoji = emojis[nextIndex];
                      });
                    },
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        _selectedEmoji,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLength: 100,
                      onChanged: (_) => setState(() {}),
                      style: TextStyle(
                        color: theme.centerChannelColor,
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Set a status',
                        hintStyle: TextStyle(
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 14,
                        ),
                        counterText: '',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                  if (_textController.text.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 16,
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                      ),
                      onPressed: () {
                        setState(() {
                          _textController.clear();
                          _selectedDuration = CustomStatusDurationOption.today;
                        });
                      },
                    ),
                ],
              ),
            ),

            const SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${_textController.text.length}/100',
                style: TextStyle(
                  fontSize: 11,
                  color: _textController.text.length > 100
                      ? Colors.red
                      : theme.centerChannelColor.withValues(alpha: 0.5),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Clear After / Expiry Dropdown
            Row(
              children: [
                Text(
                  'Clear after: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: theme.centerChannelColor.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<CustomStatusDurationOption>(
                    initialValue: _selectedDuration,
                    isDense: true,
                    dropdownColor: theme.centerChannelBg,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.centerChannelColor,
                    ),
                    items: CustomStatusDurationOption.values.map((opt) {
                      return DropdownMenuItem(
                        value: opt,
                        child: Text(_durationLabel(l10n, opt)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val == CustomStatusDurationOption.customDateTime) {
                        _showCustomDateTimePicker();
                      } else if (val != null) {
                        setState(() => _selectedDuration = val);
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Suggestions List Section
            Text(
              'SUGGESTIONS',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.8,
                color: theme.centerChannelColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),

            Column(
              children: _defaultSuggestions.map((item) {
                return InkWell(
                  onTap: () => _onSuggestionTap(item),
                  borderRadius: BorderRadius.circular(4),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Text(item.emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.text,
                            style: TextStyle(
                              fontSize: 14,
                              color: theme.centerChannelColor,
                            ),
                          ),
                        ),
                        Text(
                          _durationLabel(l10n, item.duration),
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.centerChannelColor.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
