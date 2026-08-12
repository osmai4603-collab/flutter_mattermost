import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/i18n/app_settings_cubit.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/preference_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_preferences_bloc.dart';
import 'package:go_router/go_router.dart';

/// محتوى تبويبات إعدادات المستخدم — مطابقة user_settings/* في webapp:
/// كل تبويب مقسم لأقسام بعناوين uppercase صغيرة بفواصل، وعناصر تحكم
/// (مفاتيح/قوائم منسدلة/أزرار راديو) بأسلوب Compass.

/// عنوان قسم داخل تبويب (webapp .section-title: 1.2rem/600 uppercase).
class SettingsSectionHeader extends StatelessWidget {
  final String label;
  const SettingsSectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.centerChannelColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: theme.centerChannelColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

/// مجموعة أقسام داخل التبويب مع تباعد.
class SettingsSectionGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const SettingsSectionGroup({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          SettingsSectionHeader(label: title!),
          const SizedBox(height: 16),
        ],
        for (final child in children) child,
      ],
    );
  }
}

/// صف تبديل (Toggle) — مفتاح Compass مع تسمية.
class SettingsToggleRow extends StatefulWidget {
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingsToggleRow({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  State<SettingsToggleRow> createState() => _SettingsToggleRowState();
}

class _SettingsToggleRowState extends State<SettingsToggleRow> {
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: theme.centerChannelColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (widget.description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    widget.description!,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch(
            value: widget.value,
            onChanged: widget.onChanged,
            activeTrackColor: theme.buttonBg,
            activeThumbColor: theme.buttonColor,
          ),
        ],
      ),
    );
  }
}

/// صف قائمة منسدلة — تسمية + DropdownButton بأسلوب webapp.
class SettingsDropdownRow<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const SettingsDropdownRow({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: theme.centerChannelColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.centerChannelColor.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                value: value,
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                icon: Icon(
                  Icons.expand_more,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.7),
                ),
                style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
                dropdownColor: theme.centerChannelBg,
                items: [
                  for (final v in values)
                    DropdownMenuItem<T>(value: v, child: Text(labelOf(v))),
                ],
                onChanged: (v) {
                  if (v != null) onChanged(v);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// صف أزرار راديو — خيارات أفقية (webapp radio-group).
class SettingsRadioGroup<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  const SettingsRadioGroup({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.centerChannelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              for (final v in values)
                InkWell(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                  onTap: () => onChanged(v),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          v == value
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                          size: 18,
                          color: v == value
                              ? theme.buttonBg
                              : theme.centerChannelColor.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          labelOf(v),
                          style: TextStyle(
                            color: theme.centerChannelColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// صف حقل نصي — تسمية + TextField (webapp .form-control height 40).
class SettingsTextFieldRow extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool readOnly;

  const SettingsTextFieldRow({
    super.key,
    required this.label,
    required this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.centerChannelColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 40,
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===== تبويب الملف الشخصي (webapp user_settings_general) =====
class ProfileSettingsTab extends StatelessWidget {
  const ProfileSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;

    final usernameController = TextEditingController(
      text: user?.username ?? '',
    );
    final firstNameController = TextEditingController(
      text: user?.firstName ?? '',
    );
    final lastNameController = TextEditingController(
      text: user?.lastName ?? '',
    );
    final nicknameController = TextEditingController(
      text: user?.nickname ?? '',
    );
    final emailController = TextEditingController(text: user?.email ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(label: l10n.userSettingsProfileSectionPicture),
        const SizedBox(height: 16),
        Center(
          child: ProfilePicture.xl(
            username: user?.username ?? '?',
            avatarUrl: null,
            status: null,
          ),
        ),
        const SizedBox(height: 24),
        SettingsTextFieldRow(
          label: l10n.userSettingsGeneralUsername,
          controller: usernameController,
          readOnly: true,
        ),
        SettingsTextFieldRow(
          label: l10n.userSettingsGeneralFirstName,
          controller: firstNameController,
        ),
        SettingsTextFieldRow(
          label: l10n.userSettingsGeneralLastName,
          controller: lastNameController,
        ),
        SettingsTextFieldRow(
          label: l10n.userSettingsGeneralNickname,
          controller: nicknameController,
        ),
        SettingsTextFieldRow(
          label: l10n.userSettingsGeneralEmail,
          controller: emailController,
          readOnly: true,
        ),
      ],
    );
  }
}

/// ===== تبويب الإشعارات (webapp user_settings_notifications) =====
class NotificationsSettingsTab extends StatefulWidget {
  const NotificationsSettingsTab({super.key});

  @override
  State<NotificationsSettingsTab> createState() =>
      _NotificationsSettingsTabState();
}

class _NotificationsSettingsTabState extends State<NotificationsSettingsTab> {
  bool _desktop = true;
  bool _sound = true;
  bool _triggerWordMessage = true;
  bool _directMessage = true;
  String _duration = '30s';
  String _email = 'immediately';
  String _push = 'mentions';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionGroup(
          title: l10n.userSettingsNotificationsDesktopTitle,
          children: [
            SettingsToggleRow(
              label: l10n.userSettingsNotificationsDesktopEnable,
              value: _desktop,
              onChanged: (v) => setState(() => _desktop = v),
            ),
            SettingsToggleRow(
              label: l10n.userSettingsNotificationsDesktopSound,
              value: _sound,
              onChanged: (v) => setState(() => _sound = v),
            ),
            SettingsDropdownRow<String>(
              label: l10n.userSettingsNotificationsDesktopDuration,
              value: _duration,
              values: const ['3s', '10s', '30s', '1m'],
              labelOf: (v) => switch (v) {
                '3s' => l10n.userSettingsNotificationsDuration3s,
                '10s' => l10n.userSettingsNotificationsDuration10s,
                '30s' => l10n.userSettingsNotificationsDuration30s,
                _ => l10n.userSettingsNotificationsDuration1m,
              },
              onChanged: (v) => setState(() => _duration = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsNotificationsEmailTitle,
          children: [
            SettingsDropdownRow<String>(
              label: l10n.userSettingsNotificationsEmailSend,
              value: _email,
              values: const ['immediately', 'every15', 'never'],
              labelOf: (v) => switch (v) {
                'immediately' => l10n.userSettingsNotificationsImmediately,
                'every15' => l10n.userSettingsNotificationsEvery15,
                _ => l10n.userSettingsNotificationsNever,
              },
              onChanged: (v) => setState(() => _email = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsNotificationsPushTitle,
          children: [
            SettingsDropdownRow<String>(
              label: l10n.userSettingsNotificationsPushSend,
              value: _push,
              values: const ['all', 'mentions', 'never'],
              labelOf: (v) => switch (v) {
                'all' => l10n.userSettingsNotificationsPushAll,
                'mentions' => l10n.userSettingsNotificationsPushMentions,
                _ => l10n.userSettingsNotificationsNever,
              },
              onChanged: (v) => setState(() => _push = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsNotificationsKeywordsTitle,
          children: [
            SettingsToggleRow(
              label: l10n.userSettingsNotificationsWhenContains,
              value: _triggerWordMessage,
              onChanged: (v) => setState(() => _triggerWordMessage = v),
            ),
            SettingsToggleRow(
              label: l10n.userSettingsNotificationsWhenDirect,
              value: _directMessage,
              onChanged: (v) => setState(() => _directMessage = v),
            ),
          ],
        ),
      ],
    );
  }
}

/// ===== تبويب العرض (webapp user_settings_display) =====
class DisplaySettingsTab extends StatefulWidget {
  const DisplaySettingsTab({super.key});

  @override
  State<DisplaySettingsTab> createState() => _DisplaySettingsTabState();
}

class _DisplaySettingsTabState extends State<DisplaySettingsTab> {
  String _clock = '12h';
  String _messageDisplay = 'standard';
  String _timezone = 'automatic';
  bool _groupUnreads = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<AppSettingsCubit>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(label: l10n.userSettingsDisplayThemeSection),
        const SizedBox(height: 16),
        _ThemeSelector(
          themeMode: settings.themeMode,
          onChanged: (mode) {
            context.read<AppSettingsCubit>().setThemeMode(mode);
          },
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayClockSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsDisplayClockSection,
              value: _clock,
              values: const ['12h', '24h'],
              labelOf: (v) => v == '12h'
                  ? l10n.userSettingsDisplayClock12h
                  : l10n.userSettingsDisplayClock24h,
              onChanged: (v) => setState(() => _clock = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayMessageSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsDisplayMessageSection,
              value: _messageDisplay,
              values: const ['standard', 'compact'],
              labelOf: (v) => v == 'compact'
                  ? l10n.userSettingsDisplayCompact
                  : l10n.userSettingsDisplayStandard,
              onChanged: (v) => setState(() => _messageDisplay = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayLanguageSection,
          children: [
            SettingsDropdownRow<String>(
              label: l10n.userSettingsDisplayLanguageSection,
              value: settings.locale.languageCode,
              values: const ['en', 'ar'],
              labelOf: (v) => v == 'ar' ? 'العربية' : 'English',
              onChanged: (v) {
                context.read<AppSettingsCubit>().setLocale(Locale(v));
              },
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayTimezoneSection,
          children: [
            SettingsDropdownRow<String>(
              label: l10n.userSettingsDisplayTimezoneSection,
              value: _timezone,
              values: const ['automatic', 'UTC', 'GMT+3'],
              labelOf: (v) => v == 'automatic'
                  ? l10n.userSettingsDisplayTimezoneAutomatic
                  : v,
              onChanged: (v) => setState(() => _timezone = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayChannelGrouping,
          children: [
            SettingsToggleRow(
              label: l10n.userSettingsDisplayGroupUnreads,
              value: _groupUnreads,
              onChanged: (v) => setState(() => _groupUnreads = v),
            ),
          ],
        ),
      ],
    );
  }
}

/// بطاقات الثيم — مطابقة theme_card في webapp (عرض ألوان + اسم، اختيار واحد).
class _ThemeSelector extends StatelessWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onChanged;
  const _ThemeSelector({required this.themeMode, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    final cards = <_ThemeCardData>[
      _ThemeCardData(
        key: ThemeMode.light,
        label: l10n.settingsLightMode,
        sidebar: const Color(0xFF1E325C),
        center: const Color(0xFFFFFFFF),
        text: const Color(0xFF3F4350),
        button: const Color(0xFF1C58D9),
      ),
      _ThemeCardData(
        key: ThemeMode.dark,
        label: l10n.settingsDarkMode,
        sidebar: const Color(0xFF151E32),
        center: const Color(0xFF111827),
        text: const Color(0xFFDDDFE4),
        button: const Color(0xFF4A7CE8),
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final card in cards)
          InkWell(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
            onTap: () => onChanged(card.key),
            child: Container(
              width: 160,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.centerChannelBg,
                border: Border.all(
                  color: card.key == themeMode
                      ? theme.buttonBg
                      : theme.centerChannelColor.withValues(alpha: 0.16),
                  width: card.key == themeMode ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(DesignTokens.radiusM),
                boxShadow: card.key == themeMode
                    ? [
                        BoxShadow(
                          color: theme.buttonBg.withValues(alpha: 0.2),
                          blurRadius: 8,
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 36,
                    decoration: BoxDecoration(
                      color: card.sidebar,
                      borderRadius: BorderRadius.circular(
                        DesignTokens.radiusSm,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 14,
                          margin: const EdgeInsets.only(left: 6, right: 4),
                          decoration: BoxDecoration(
                            color: card.sidebar.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          width: 40,
                          height: 14,
                          decoration: BoxDecoration(
                            color: card.center,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 4,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: card.sidebar,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(2),
                                    bottomLeft: Radius.circular(2),
                                  ),
                                ),
                              ),
                              Container(
                                width: 8,
                                height: 4,
                                margin: const EdgeInsets.only(left: 2),
                                decoration: BoxDecoration(
                                  color: card.button,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card.label,
                          style: TextStyle(
                            color: theme.centerChannelColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (card.key == themeMode)
                        Icon(
                          Icons.check_circle,
                          size: 18,
                          color: theme.buttonBg,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ThemeCardData {
  final ThemeMode key;
  final String label;
  final Color sidebar;
  final Color center;
  final Color text;
  final Color button;

  const _ThemeCardData({
    required this.key,
    required this.label,
    required this.sidebar,
    required this.center,
    required this.text,
    required this.button,
  });
}

/// ===== تبويب الشريط الجانبي (webapp user_settings_sidebar) =====
class SidebarSettingsTab extends StatefulWidget {
  const SidebarSettingsTab({super.key});

  @override
  State<SidebarSettingsTab> createState() => _SidebarSettingsTabState();
}

class _SidebarSettingsTabState extends State<SidebarSettingsTab> {
  String _grouping = 'grouped';
  String _sort = 'alphabetical';
  String _nameDisplay = 'full';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionGroup(
          title: l10n.userSettingsSidebarGroupingSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsSidebarGroupingSection,
              value: _grouping,
              values: const ['grouped', 'ungrouped'],
              labelOf: (v) => v == 'grouped'
                  ? l10n.userSettingsSidebarUnreadsGrouped
                  : l10n.userSettingsSidebarUngrouped,
              onChanged: (v) => setState(() => _grouping = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsSidebarSortSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsSidebarSortSection,
              value: _sort,
              values: const ['alphabetical', 'recency'],
              labelOf: (v) => v == 'alphabetical'
                  ? l10n.userSettingsSidebarSortAlphabetical
                  : l10n.userSettingsSidebarSortRecency,
              onChanged: (v) => setState(() => _sort = v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsSidebarNameSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsSidebarNameSection,
              value: _nameDisplay,
              values: const ['full', 'username', 'standard'],
              labelOf: (v) => switch (v) {
                'full' => l10n.userSettingsSidebarNameFull,
                'username' => l10n.userSettingsSidebarNameUsername,
                _ => l10n.userSettingsSidebarNameStandard,
              },
              onChanged: (v) => setState(() => _nameDisplay = v),
            ),
          ],
        ),
      ],
    );
  }
}

/// ===== تبويب المتقدم (webapp user_settings_advanced) =====
class AdvancedSettingsTab extends StatefulWidget {
  const AdvancedSettingsTab({super.key});

  @override
  State<AdvancedSettingsTab> createState() => _AdvancedSettingsTabState();
}

class _AdvancedSettingsTabState extends State<AdvancedSettingsTab> {
  bool _ctrlEnter = false;
  bool _joinLeave = true;
  bool _codeBlock = true;
  bool _groupChannels = true;
  bool _headerTooltips = true;
  bool _timeSpent = true;

  void _savePreference(BuildContext context, String name, bool value) {
    context.read<UserPreferencesBloc>().add(
      SavePreferenceEvent(
        PreferenceEntity(
          serverId: '',
          userId: 'me',
          category: 'advanced_settings',
          name: name,
          value: value ? 'true' : 'false',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedCtrlEnter,
          value: _ctrlEnter,
          onChanged: (v) {
            setState(() => _ctrlEnter = v);
            _savePreference(context, 'send_on_ctrl_enter', v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedJoinLeave,
          value: _joinLeave,
          onChanged: (v) {
            setState(() => _joinLeave = v);
            _savePreference(context, 'join_leave_messages', v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedCodeBlock,
          value: _codeBlock,
          onChanged: (v) {
            setState(() => _codeBlock = v);
            _savePreference(context, 'code_block_formatting', v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedGroupChannels,
          value: _groupChannels,
          onChanged: (v) {
            setState(() => _groupChannels = v);
            _savePreference(context, 'group_unread_messages', v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedHeaderTooltips,
          value: _headerTooltips,
          onChanged: (v) {
            setState(() => _headerTooltips = v);
            _savePreference(context, 'channel_header_tooltips', v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedTimeSpent,
          value: _timeSpent,
          onChanged: (v) {
            setState(() => _timeSpent = v);
            _savePreference(context, 'time_spent_in_app', v);
          },
        ),
      ],
    );
  }
}

/// ===== تبويب الأمان (webapp user_settings_security) =====
class SecuritySettingsTab extends StatelessWidget {
  const SecuritySettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionGroup(
          title: l10n.userSettingsSecurityMfaSection,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.userSettingsSecurityMfaNotActive,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                ),
                MatterButtonOutlined(
                  label: l10n.userSettingsSecurityMfaSetup,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/mfa/setup');
                  },
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsSecurityPasswordSection,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 20,
                  color: theme.centerChannelColor.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.userSettingsSecurityPasswordChange,
                    style: TextStyle(
                      color: theme.centerChannelColor.withValues(alpha: 0.75),
                      fontSize: 13,
                    ),
                  ),
                ),
                MatterButtonOutlined(
                  label: l10n.userSettingsSecurityPasswordChange,
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.go('/reset_password');
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// زر ثانوي بإطار — مطابق tertiary button في webapp.
class MatterButtonOutlined extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const MatterButtonOutlined({super.key, required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: theme.buttonBg, width: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        foregroundColor: theme.buttonBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
        ),
        textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
