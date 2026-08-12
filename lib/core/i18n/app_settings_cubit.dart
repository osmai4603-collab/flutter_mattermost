import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

/// تفضيلات العرض العامة للتطبيق: اللغة (EN/AR) والنمط (فاتح/داكن).
/// المقابل في webapp: state.views.i18n + تفضيل Theme preferences.
class AppLocaleState extends Equatable {
  final Locale locale;
  final ThemeMode themeMode;

  const AppLocaleState({
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.light,
  });

  bool get isArabic => locale.languageCode == 'ar';

  AppLocaleState copyWith({Locale? locale, ThemeMode? themeMode}) {
    return AppLocaleState(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props => [locale, themeMode];
}

/// إدارة تفضيلات الواجهة (اللغة + الوضع).
class AppSettingsCubit extends Cubit<AppLocaleState> {
  AppSettingsCubit() : super(const AppLocaleState());

  void setLocale(Locale locale) {
    emit(state.copyWith(locale: locale));
  }

  void toggleThemeMode() {
    emit(
      state.copyWith(
        themeMode: state.themeMode == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark,
      ),
    );
  }

  void setThemeMode(ThemeMode mode) {
    emit(state.copyWith(themeMode: mode));
  }
}
