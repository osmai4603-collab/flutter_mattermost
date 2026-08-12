import 'package:flutter/material.dart';

/// أرقام التصميم المطابقة لمتغيرات scss في webapp
/// (--radius-m/l/pill, --elevation-*, --icon-opacity, حدود وتباعدات).
abstract class DesignTokens {
  static const double radiusSm = 4;
  static const double radiusM = 8;
  static const double radiusL = 12;
  static const double radiusPill = 999;
  static const double radiusCircle = 50;

  static const double iconOpacity = 0.56;

  static const double globalHeaderHeight = 44;
  static const double teamSidebarWidth = 65;
  static const double sidebarHeaderHeight = 55;
  static const double sidebarRowHeight = 32;
  static const double sidebarCategoryHeaderHeight = 32;
  static const double channelHeaderHeight = 56;
  static const double rhsHeaderHeight = 56;
  static const double rhsDefaultWidth = 400;
  static const double rhsMinWidth = 304;
  static const double rhsMaxWidth = 776;
  static const double lhsDefaultWidth = 264;
  static const double lhsMinWidth = 200;
  static const double lhsMaxWidth = 304;
  static const double lhsSnapSize = 16;
  static const double threadPaneHeaderHeight = 56;

  static const double dialogRadius = 12;
  static const double elevation1 = 1;
  static const double elevation2 = 2;
  static const double elevation4 = 4;

  static BorderRadius get radiusMValue => BorderRadius.circular(radiusM);
  static BorderRadius get radiusLValue => BorderRadius.circular(radiusL);
  static BorderRadius get radiusPillValue => BorderRadius.circular(radiusPill);

  /// شبكة التباعد الموحدة (px) المطابقة لمسافات webapp.
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 20;
  static const double space6 = 24;
  static const double space8 = 32;
  static const double space10 = 40;

  /// تباعدات أفقية داخل صف القناة (webapp: padding 7px 16px 7px 19px).
  static const EdgeInsets sidebarRowPadding = EdgeInsets.fromLTRB(19, 7, 16, 7);

  /// زمن انتقالات الـ webapp (sass transition durations).
  static const Duration sidebarCollapseDuration = Duration(milliseconds: 180);
  static const Duration rhsSlideDuration = Duration(milliseconds: 250);
  static const Duration modalFadeDuration = Duration(milliseconds: 200);
  static const Duration hoverFadeDuration = Duration(milliseconds: 150);
}
