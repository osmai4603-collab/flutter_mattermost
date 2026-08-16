import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/preference_entity.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

/// أسماء تفضيلات شائعة قابلة للاستخدام في الواجهات — مطابقة ثوابت
/// preference/xxx في webapp.
const String preferenceCategoryTheme = 'theme';
const String preferenceNameTheme = 'theme_preference';
const String preferenceCategoryVisual = 'display_settings';
const String preferenceNameCollapsedThreads = 'collapsed_reply_threads';

/// display_settings
const String preferenceCategoryDisplay = 'display_settings';
const String preferenceNameMilitaryTime = 'use_military_time';
const String preferenceNameMessageDisplay = 'message_display';
const String preferenceNameChannelGrouping = 'channel_grouping';
const String preferenceNameTimezone = 'timezone';
const String preferenceNameNameFormat = 'name_format';

/// sidebar_settings
const String preferenceCategorySidebar = 'sidebar_settings';
const String preferenceNameShowUnreadSection = 'show_unread_section';
const String preferenceNameSortChannels = 'sort_channels_by';
const String preferenceNameLimitVisibleDmsGms = 'limit_visible_dms_gms';

/// advanced_settings
const String preferenceCategoryAdvanced = 'advanced_settings';
const String preferenceNameSendOnCtrlEnter = 'send_on_ctrl_enter';
const String preferenceNameJoinLeaveMessages = 'join_leave_messages';
const String preferenceNameCodeBlockFormatting = 'code_block_formatting';
const String preferenceNameChannelHeaderTooltips = 'channel_header_tooltips';

/// notifications (فاصل البريد الإلكتروني)
const String preferenceCategoryNotifications = 'notifications';
const String preferenceNameEmailInterval = 'email_interval';

// Events
abstract class UserPreferencesEvent extends Equatable {
  const UserPreferencesEvent();
  @override
  List<Object?> get props => [];
}

class LoadPreferencesEvent extends UserPreferencesEvent {}

class SavePreferenceEvent extends UserPreferencesEvent {
  final PreferenceEntity preference;
  const SavePreferenceEvent(this.preference);
  @override
  List<Object?> get props => [preference];
}

// States
abstract class UserPreferencesState extends Equatable {
  const UserPreferencesState();
  @override
  List<Object?> get props => [];
}

class UserPreferencesLoadedState extends UserPreferencesState {
  final List<PreferenceEntity> preferences;

  const UserPreferencesLoadedState(this.preferences);

  String? valueOf(String category, String name) {
    for (final p in preferences) {
      if (p.category == category && p.name == name) return p.value;
    }
    return null;
  }

  String get themePreference {
    final value = valueOf(preferenceCategoryTheme, preferenceNameTheme);
    return value == null || value.isEmpty ? 'default' : value;
  }

  bool get collapsedThreads =>
      valueOf(preferenceCategoryTheme, preferenceNameCollapsedThreads) ==
      'true';

  // ==== display_settings ====
  bool get useMilitaryTime =>
      valueOf(preferenceCategoryDisplay, preferenceNameMilitaryTime) == 'true';

  /// 'clean' (Standard) أو 'compact'.
  String get messageDisplay =>
      valueOf(preferenceCategoryDisplay, preferenceNameMessageDisplay) ??
      'clean';

  bool get channelGrouping =>
      valueOf(preferenceCategoryDisplay, preferenceNameChannelGrouping) ==
      'true';

  String get timezone =>
      valueOf(preferenceCategoryDisplay, preferenceNameTimezone) ??
      'automatic';

  /// 'full_name' | 'username' | 'nickname_full_name'.
  String get nameFormat =>
      valueOf(preferenceCategoryDisplay, preferenceNameNameFormat) ??
      'full_name';

  // ==== sidebar_settings ====
  bool get showUnreadSection =>
      valueOf(preferenceCategorySidebar, preferenceNameShowUnreadSection) !=
      'false';

  /// 'alpha' | 'recent'.
  String get sortChannelsBy =>
      valueOf(preferenceCategorySidebar, preferenceNameSortChannels) ?? 'alpha';

  // ==== notifications ====
  /// 'immediately' | 'every15' | 'never'.
  String get emailInterval =>
      valueOf(preferenceCategoryNotifications, preferenceNameEmailInterval) ??
      'immediately';

  // ==== advanced_settings ====
  bool advancedPref(String name) =>
      valueOf(preferenceCategoryAdvanced, name) != 'false';

  @override
  List<Object?> get props => [preferences];
}

@LazySingleton()
class UserPreferencesBloc
    extends Bloc<UserPreferencesEvent, UserPreferencesState> {
  final UserRepository _userRepository;

  UserPreferencesBloc(this._userRepository)
    : super(const UserPreferencesLoadedState([])) {
    on<LoadPreferencesEvent>(_onLoad);
    on<SavePreferenceEvent>(_onSave);
  }

  Future<void> _onLoad(
    LoadPreferencesEvent event,
    Emitter<UserPreferencesState> emit,
  ) async {
    try {
      final preferences = await _userRepository.getMyPreferences();
      emit(UserPreferencesLoadedState(preferences));
    } catch (_) {}
  }

  Future<void> _onSave(
    SavePreferenceEvent event,
    Emitter<UserPreferencesState> emit,
  ) async {
    final current = state is UserPreferencesLoadedState
        ? (state as UserPreferencesLoadedState).preferences
        : const <PreferenceEntity>[];
    try {
      await _userRepository.saveMyPreferences([event.preference]);
      final next = [
        for (final p in current)
          if (p.category != event.preference.category ||
              p.name != event.preference.name)
            p,
        event.preference,
      ];
      emit(UserPreferencesLoadedState(next));
    } catch (_) {}
  }
}
