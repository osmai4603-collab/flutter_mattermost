import 'package:flutter/material.dart';

import 'app_font_sizes.dart';
import 'app_fonts.dart';
import 'mattermost_colors.dart';
import 'mattermost_theme.dart';
import 'predefined_themes.dart';
import 'theme_utils.dart';

sealed class AppTheme {
  static MattermostColors of(BuildContext context) {
    final colors = Theme.of(context).extension<MattermostColors>();
    if (colors == null) {
      throw FlutterError(
        'MattermostColors not found in the current Theme. '
        'Ensure the theme was created with AppTheme.buildTheme().',
      );
    }
    return colors;
  }

  static ThemeData get light => buildTheme(PredefinedThemes.denim);

  static ThemeData get dark => buildTheme(PredefinedThemes.indigo);

  static TextStyle textStyle(
    MattermostTheme theme,
    String family,
    FontWeight weight,
    double size,
  ) {
    return TextStyle(
      fontFamily: family,
      fontWeight: weight,
      fontSize: size,
      color: theme.centerChannelColor,
    );
  }

  static ThemeData buildTheme(MattermostTheme theme) {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: theme.buttonBg,
          brightness: theme.brightness,
        ).copyWith(
          primary: theme.buttonBg,
          onPrimary: theme.buttonColor,
          secondary: theme.linkColor,
          onSecondary: theme.centerChannelColor,
          error: theme.errorTextColor,
          onError: getContrastingSimpleColor(theme.errorTextColor),
          surface: theme.centerChannelBg,
          onSurface: theme.centerChannelColor,
          outline: changeOpacity(theme.centerChannelColor, 0.2),
        );

    final textTheme =
        ThemeData(useMaterial3: true, brightness: theme.brightness).textTheme
            .apply(
              fontFamily: AppFonts.notoNaskhArabic,
              bodyColor: theme.centerChannelColor,
              displayColor: theme.centerChannelColor,
            )
            .copyWith(
              displayLarge: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s48,
              ),
              displayMedium: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s40,
              ),
              displaySmall: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s36,
              ),
              headlineLarge: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s32,
              ),
              headlineMedium: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s28,
              ),
              headlineSmall: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s24,
              ),
              titleLarge: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s22,
              ),
              titleMedium: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s16,
              ),
              titleSmall: textStyle(
                theme,
                AppFonts.notoNaskhArabic,
                FontWeight.w600,
                AppFontSizes.s14,
              ),
            );

    return ThemeData(
      useMaterial3: true,
      brightness: theme.brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: theme.centerChannelBg,
      canvasColor: theme.centerChannelBg,
      fontFamily: AppFonts.notoNaskhArabic,
      fontFamilyFallback: const ['NotoNaskhArabic', 'Roboto', 'sans-serif'],
      appBarTheme: AppBarTheme(
        backgroundColor: theme.centerChannelBg,
        foregroundColor: theme.centerChannelColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: .circular(4),
            side: BorderSide(color: colorScheme.surface),
          ),
          foregroundColor: colorScheme.onSurface,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: changeOpacity(theme.centerChannelColor, 0.2),
      ),
      dividerColor: changeOpacity(theme.centerChannelColor, 0.2),
      extensions: [MattermostColors.fromTheme(theme)],
    );
  }
}
