import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';

extension StateUtils on State {
  AppLocalizations get localization => AppLocalizations.of(context);
  ColorScheme get colors => ColorScheme.of(context);
  TextTheme get textTheme => TextTheme.of(context);
}
