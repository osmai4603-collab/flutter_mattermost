import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/i18n/app_settings_cubit.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/design_tokens.dart';
import 'package:flutter_mattermost/core/widgets/matter_button.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/preference_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_preferences_bloc.dart';
import 'package:flutter_mattermost/features/users/presentation/bloc/user_profile_bloc.dart';
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
class ProfileSettingsTab extends StatefulWidget {
  const ProfileSettingsTab({super.key});

  @override
  State<ProfileSettingsTab> createState() => _ProfileSettingsTabState();
}

class _ProfileSettingsTabState extends State<ProfileSettingsTab> {
  final _usernameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _positionController = TextEditingController();
  final _emailController = TextEditingController();

  bool _saving = false;
  bool _loadedOnce = false;
  bool _uploaded = false;

  @override
  void initState() {
    super.initState();
    final user = _currentUser();
    _syncFromUser(user);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UserProfileBloc>().add(LoadMyProfileEvent());
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicknameController.dispose();
    _positionController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  UserEntity? _currentUser() {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthenticatedState ? authState.user : null;
  }

  void _syncFromUser(UserEntity? user) {
    if (user == null) return;
    _usernameController.text = user.username;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _nicknameController.text = user.nickname;
    _positionController.text = user.position;
    _emailController.text = user.email;
  }

  Future<void> _pickAndUploadImage() async {
    if (_saving) return;
    final result = await FilePicker.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: false,
    );
    if (!mounted) return;
    if (result == null || result.files.isEmpty) return;
    final path = result.files.single.path;
    if (path == null) return;
    setState(() => _uploaded = false);
    context.read<UserProfileBloc>().add(UploadProfileImageEvent(path));
  }

  void _saveProfile() {
    if (_saving) return;
    context.read<UserProfileBloc>().add(
      UpdateMyProfileEvent(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        nickname: _nicknameController.text.trim(),
        position: _positionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = AppTheme.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileSavingState) {
          if (mounted) setState(() => _saving = true);
        } else if (state is UserProfileSaveSuccessState) {
          if (!mounted) return;
          setState(() {
            _saving = false;
            _uploaded = state.message.contains('picture');
          });
          _syncFromUser(state.myProfile);
          if (state.myProfile != null) {
            context.read<AuthBloc>().add(
              AuthUserUpdatedEvent(state.myProfile!),
            );
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserProfileSaveErrorState) {
          if (!mounted) return;
          setState(() => _saving = false);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserProfileLoadedState && !_loadedOnce) {
          _loadedOnce = true;
          _syncFromUser(state.myProfile);
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionHeader(label: l10n.userSettingsProfileSectionPicture),
          const SizedBox(height: 16),
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ProfilePicture.xl(
                  userId: user?.id,
                  username: user?.username ?? '?',
                  avatarUrl: user == null ? null : serverUserAvatarUrl(user.id),
                  status: null,
                ),
                if (_saving)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.centerChannelBg.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: MatterButtonOutlined(
              label: _uploaded
                  ? l10n.userSettingsGeneralPictureUploaded
                  : l10n.userSettingsGeneralSelect,
              onPressed: _saving ? null : _pickAndUploadImage,
            ),
          ),
          const SizedBox(height: 24),
          SettingsTextFieldRow(
            label: l10n.userSettingsGeneralUsername,
            controller: _usernameController,
            readOnly: true,
          ),
          SettingsTextFieldRow(
            label: l10n.userSettingsGeneralFirstName,
            controller: _firstNameController,
          ),
          SettingsTextFieldRow(
            label: l10n.userSettingsGeneralLastName,
            controller: _lastNameController,
          ),
          SettingsTextFieldRow(
            label: l10n.userSettingsGeneralNickname,
            controller: _nicknameController,
          ),
          SettingsTextFieldRow(
            label: l10n.userSettingsGeneralPosition,
            controller: _positionController,
          ),
          SettingsTextFieldRow(
            label: l10n.userSettingsGeneralEmail,
            controller: _emailController,
            readOnly: true,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: MatterButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.generic_btnSave),
                ),
              ),
            ],
          ),
        ],
      ),
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
  String _duration = '30s';

  UserEntity? _currentUser() {
    final authState = context.read<AuthBloc>().state;
    return authState is AuthenticatedState ? authState.user : null;
  }

  void _saveNotifyProps(UserNotifyPropsEntity changes) {
    context.read<UserProfileBloc>().add(UpdateNotifyPropsEvent(changes));
  }

  void _saveEmailInterval(String value) {
    final user = _currentUser();
    if (user == null) return;
    context.read<UserPreferencesBloc>().add(
      SavePreferenceEvent(
        PreferenceEntity(
          userId: user.id,
          category: preferenceCategoryNotifications,
          name: preferenceNameEmailInterval,
          value: value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final prefs = context.watch<UserPreferencesBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;
    if (user == null) return Container();

    final desktopEnabled = user.notifyProps.desktop == 'all';
    final soundEnabled = user.notifyProps.desktopSound == true;
    final pushValue = user.notifyProps.push;
    final directEnabled = pushValue;
    final emailOff = user.notifyProps.email == false;
    final emailInterval = prefs is UserPreferencesLoadedState
        ? prefs.emailInterval
        : 'immediately';
    final emailValue = emailOff || emailInterval == 'never'
        ? 'never'
        : (emailInterval == 'every15' ? 'every15' : 'immediately');
    final triggerEnabled = user.notifyProps.mentionKeys.isNotEmpty;

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileSaveSuccessState) {
          if (state.myProfile != null) {
            context.read<AuthBloc>().add(
              AuthUserUpdatedEvent(state.myProfile!),
            );
          }
        } else if (state is UserProfileSaveErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SettingsSectionGroup(
            title: l10n.userSettingsNotificationsDesktopTitle,
            children: [
              SettingsToggleRow(
                label: l10n.userSettingsNotificationsDesktopEnable,
                value: desktopEnabled,
                onChanged: (v) => _saveNotifyProps(
                  user.notifyProps.copyWith(desktop: v ? 'all' : 'none'),
                ),
              ),
              SettingsToggleRow(
                label: l10n.userSettingsNotificationsDesktopSound,
                value: soundEnabled,
                onChanged: (v) => _saveNotifyProps(
                  user.notifyProps.copyWith(desktopSound: v),
                ),
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
                value: emailValue,
                values: const ['immediately', 'every15', 'never'],
                labelOf: (v) => switch (v) {
                  'immediately' => l10n.userSettingsNotificationsImmediately,
                  'every15' => l10n.userSettingsNotificationsEvery15,
                  _ => l10n.userSettingsNotificationsNever,
                },
                onChanged: (v) {
                  _saveNotifyProps(
                    user.notifyProps.copyWith(email: v == 'never'),
                  );
                  _saveEmailInterval(v);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsSectionGroup(
            title: l10n.userSettingsNotificationsPushTitle,
            children: [
              SettingsDropdownRow<PushType>(
                label: l10n.userSettingsNotificationsPushSend,
                value: pushValue,
                values: PushType.values,
                labelOf: (v) => switch (v) {
                  .all => l10n.userSettingsNotificationsPushAll,
                  .mention => l10n.userSettingsNotificationsPushMentions,
                  _ => l10n.userSettingsNotificationsNever,
                },
                onChanged: (v) =>
                    _saveNotifyProps(user.notifyProps.copyWith(push: v)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SettingsSectionGroup(
            title: l10n.userSettingsNotificationsKeywordsTitle,
            children: [
              SettingsToggleRow(
                label: l10n.userSettingsNotificationsWhenContains,
                value: triggerEnabled,
                onChanged: (v) => _saveNotifyProps(
                  user.notifyProps.copyWith(
                    mentionKeys: v ? user.username : '',
                  ),
                ),
              ),
              SettingsToggleRow(
                label: l10n.userSettingsNotificationsWhenDirect,
                value: directEnabled == .mention,
                onChanged: (v) => _saveNotifyProps(
                  user.notifyProps.copyWith(
                    push: v
                        ? (pushValue == .none
                              ? .mention
                              : user.notifyProps.push)
                        : .none,
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

/// ===== تبويب العرض (webapp user_settings_display) =====
class DisplaySettingsTab extends StatefulWidget {
  const DisplaySettingsTab({super.key});

  @override
  State<DisplaySettingsTab> createState() => _DisplaySettingsTabState();
}

class _DisplaySettingsTabState extends State<DisplaySettingsTab> {
  String? _currentUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthenticatedState) return null;
    return authState.user.id;
  }

  void _savePref(String category, String name, String value) {
    final userId = _currentUserId();
    if (userId == null) return;
    context.read<UserPreferencesBloc>().add(
      SavePreferenceEvent(
        PreferenceEntity(
          userId: userId,
          category: category,
          name: name,
          value: value,
        ),
      ),
    );
  }

  void _saveDisplay(String name, String value) =>
      _savePref(preferenceCategoryDisplay, name, value);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settings = context.watch<AppSettingsCubit>().state;
    final prefsState = context.watch<UserPreferencesBloc>().state;
    final prefs = prefsState is UserPreferencesLoadedState
        ? prefsState
        : const UserPreferencesLoadedState([]);

    final clock = prefs.useMilitaryTime ? '24h' : '12h';
    final messageDisplay = prefs.messageDisplay;
    final timezone = prefs.timezone;
    final groupUnreads = prefs.channelGrouping;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionHeader(label: l10n.userSettingsDisplayThemeSection),
        const SizedBox(height: 16),
        _ThemeSelector(
          themeMode: settings.themeMode,
          onChanged: (mode) {
            context.read<AppSettingsCubit>().setThemeMode(mode);
            _savePref(preferenceCategoryTheme, 'theme', mode.name);
          },
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayClockSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsDisplayClockSection,
              value: clock,
              values: const ['12h', '24h'],
              labelOf: (v) => v == '12h'
                  ? l10n.userSettingsDisplayClock12h
                  : l10n.userSettingsDisplayClock24h,
              onChanged: (v) => _saveDisplay(
                preferenceNameMilitaryTime,
                v == '24h' ? 'true' : 'false',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayMessageSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsDisplayMessageSection,
              value: messageDisplay,
              values: const ['clean', 'compact'],
              labelOf: (v) => v == 'compact'
                  ? l10n.userSettingsDisplayCompact
                  : l10n.userSettingsDisplayStandard,
              onChanged: (v) => _saveDisplay(preferenceNameMessageDisplay, v),
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
              value: timezone,
              values: const ['automatic', 'UTC', 'GMT+3'],
              labelOf: (v) => v == 'automatic'
                  ? l10n.userSettingsDisplayTimezoneAutomatic
                  : v,
              onChanged: (v) => _saveDisplay(preferenceNameTimezone, v),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsDisplayChannelGrouping,
          children: [
            SettingsToggleRow(
              label: l10n.userSettingsDisplayGroupUnreads,
              value: groupUnreads,
              onChanged: (v) => _saveDisplay(
                preferenceNameChannelGrouping,
                v ? 'true' : 'false',
              ),
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
  String? _currentUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthenticatedState) return null;
    return authState.user.id;
  }

  void _savePref(String category, String name, String value) {
    final userId = _currentUserId();
    if (userId == null) return;
    context.read<UserPreferencesBloc>().add(
      SavePreferenceEvent(
        PreferenceEntity(
          userId: userId,
          category: category,
          name: name,
          value: value,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prefsState = context.watch<UserPreferencesBloc>().state;
    final prefs = prefsState is UserPreferencesLoadedState
        ? prefsState
        : const UserPreferencesLoadedState([]);

    final grouping = prefs.showUnreadSection ? 'grouped' : 'ungrouped';
    final sort = prefs.sortChannelsBy;
    final nameDisplay = prefs.nameFormat;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsSectionGroup(
          title: l10n.userSettingsSidebarGroupingSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsSidebarGroupingSection,
              value: grouping,
              values: const ['grouped', 'ungrouped'],
              labelOf: (v) => v == 'grouped'
                  ? l10n.userSettingsSidebarUnreadsGrouped
                  : l10n.userSettingsSidebarUngrouped,
              onChanged: (v) => _savePref(
                preferenceCategorySidebar,
                preferenceNameShowUnreadSection,
                v == 'grouped' ? 'true' : 'false',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsSidebarSortSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsSidebarSortSection,
              value: sort,
              values: const ['alpha', 'recent'],
              labelOf: (v) => v == 'alpha'
                  ? l10n.userSettingsSidebarSortAlphabetical
                  : l10n.userSettingsSidebarSortRecency,
              onChanged: (v) => _savePref(
                preferenceCategorySidebar,
                preferenceNameSortChannels,
                v,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SettingsSectionGroup(
          title: l10n.userSettingsSidebarNameSection,
          children: [
            SettingsRadioGroup<String>(
              label: l10n.userSettingsSidebarNameSection,
              value: nameDisplay,
              values: const ['full_name', 'username', 'nickname_full_name'],
              labelOf: (v) => switch (v) {
                'full_name' => l10n.userSettingsSidebarNameFull,
                'username' => l10n.userSettingsSidebarNameUsername,
                _ => l10n.userSettingsSidebarNameStandard,
              },
              onChanged: (v) => _savePref(
                preferenceCategoryDisplay,
                preferenceNameNameFormat,
                v,
              ),
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
  String _userId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticatedState) return authState.user.id;
    return 'me';
  }

  void _savePreference(BuildContext context, String name, bool value) {
    context.read<UserPreferencesBloc>().add(
      SavePreferenceEvent(
        PreferenceEntity(
          userId: _userId(),
          category: preferenceCategoryAdvanced,
          name: name,
          value: value ? 'true' : 'false',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final prefsState = context.watch<UserPreferencesBloc>().state;
    final prefs = prefsState is UserPreferencesLoadedState
        ? prefsState
        : const UserPreferencesLoadedState([]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedCtrlEnter,
          value: prefs.advancedPref(preferenceNameSendOnCtrlEnter),
          onChanged: (v) {
            _savePreference(context, preferenceNameSendOnCtrlEnter, v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedJoinLeave,
          value: prefs.advancedPref(preferenceNameJoinLeaveMessages),
          onChanged: (v) {
            _savePreference(context, preferenceNameJoinLeaveMessages, v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedCodeBlock,
          value: prefs.advancedPref(preferenceNameCodeBlockFormatting),
          onChanged: (v) {
            _savePreference(context, preferenceNameCodeBlockFormatting, v);
          },
        ),
        SettingsToggleRow(
          label: l10n.userSettingsAdvancedHeaderTooltips,
          value: prefs.advancedPref(preferenceNameChannelHeaderTooltips),
          onChanged: (v) {
            _savePreference(context, preferenceNameChannelHeaderTooltips, v);
          },
        ),
      ],
    );
  }
}

/// ===== تبويب الأمان (webapp user_settings_security) =====
class SecuritySettingsTab extends StatefulWidget {
  const SecuritySettingsTab({super.key});

  @override
  State<SecuritySettingsTab> createState() => _SecuritySettingsTabState();
}

class _SecuritySettingsTabState extends State<SecuritySettingsTab> {
  Future<void> _showChangePasswordDialog() async {
    final result = await showDialog<({String current, String newPassword})>(
      context: context,
      builder: (_) => const _ChangePasswordDialog(),
    );
    if (result == null || !mounted) return;
    context.read<UserProfileBloc>().add(
      ChangePasswordEvent(
        currentPassword: result.current,
        newPassword: result.newPassword,
      ),
    );
  }

  Future<void> _showRemoveMfaDialog() async {
    final l10n = AppLocalizations.of(context);
    final codeController = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final theme = AppTheme.of(dialogContext);
        return AlertDialog(
          backgroundColor: theme.centerChannelBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusM),
          ),
          title: Text(
            l10n.userSettingsMfaRemove,
            style: TextStyle(
              color: theme.centerChannelColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: TextField(
            controller: codeController,
            autofocus: true,
            keyboardType: TextInputType.number,
            style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'MFA Code',
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(l10n.generic_modalCancel),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(codeController.text.trim()),
              child: Text(l10n.generic_modalConfirm),
            ),
          ],
        );
      },
    );
    codeController.dispose();
    if (code == null || code.isEmpty || !mounted) return;
    context.read<UserProfileBloc>().add(
      UpdateMfaEvent(activate: false, code: code),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState is AuthenticatedState ? authState.user : null;

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileSaveSuccessState) {
          if (state.myProfile != null) {
            context.read<AuthBloc>().add(
              AuthUserUpdatedEvent(state.myProfile!),
            );
          }
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is UserProfileSaveErrorState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Column(
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
                      (user?.mfaActive ?? false)
                          ? l10n.userSettingsSecurityActive
                          : l10n.userSettingsSecurityMfaNotActive,
                      style: TextStyle(
                        color: theme.centerChannelColor.withValues(alpha: 0.75),
                        fontSize: 13,
                      ),
                    ),
                  ),
                  if (user?.mfaActive ?? false)
                    MatterButtonOutlined(
                      label: l10n.userSettingsMfaRemove,
                      onPressed: _showRemoveMfaDialog,
                    )
                  else
                    MatterButtonOutlined(
                      label: l10n.userSettingsSecurityMfaSetup,
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/mfa');
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
                    onPressed: _showChangePasswordDialog,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _currentError;
  String? _newError;
  String? _confirmError;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    final current = _currentController.text;
    final newPassword = _newController.text;
    final confirm = _confirmController.text;

    String? currentError;
    String? newError;
    String? confirmError;

    if (current.isEmpty) {
      currentError = l10n.userSettingsSecurityCurrentPasswordError;
    }
    if (newPassword.length < 5) {
      newError = l10n.userSettingsSecurityPasswordError(64, 5);
    }
    if (confirm.isEmpty) {
      confirmError = l10n.userSettingsSecurityRetypePassword;
    } else if (confirm != newPassword) {
      confirmError = l10n.userSettingsSecurityPasswordMatchError;
    }

    if (currentError != null || newError != null || confirmError != null) {
      setState(() {
        _currentError = currentError;
        _newError = newError;
        _confirmError = confirmError;
      });
      return;
    }

    Navigator.of(context).pop((current: current, newPassword: newPassword));
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      backgroundColor: theme.centerChannelBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusM),
      ),
      title: Text(
        l10n.userSettingsSecurityPasswordChange,
        style: TextStyle(
          color: theme.centerChannelColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _PasswordField(
                label: l10n.userSettingsSecurityCurrentPassword,
                controller: _currentController,
                errorText: _currentError,
              ),
              _PasswordField(
                label: l10n.userSettingsSecurityNewPassword,
                controller: _newController,
                errorText: _newError,
              ),
              _PasswordField(
                label: l10n.userSettingsSecurityRetypePassword,
                controller: _confirmController,
                errorText: _confirmError,
                onSubmitted: (_) => _submit(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.generic_modalCancel),
        ),
        TextButton(onPressed: _submit, child: Text(l10n.generic_modalConfirm)),
      ],
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;

  const _PasswordField({
    required this.label,
    required this.controller,
    this.errorText,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: true,
        onSubmitted: onSubmitted,
        style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(DesignTokens.radiusSm),
          ),
        ),
      ),
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
