import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/preference_entity.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

/// أسماء تفضيلات شائعة قابلة للاستخدام في الواجهات.
const String preferenceCategoryTheme = 'theme';
const String preferenceNameTheme = 'theme_preference';
const String preferenceCategoryVisual = 'display_settings';
const String preferenceNameCollapsedThreads = 'collapsed_reply_threads';

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
