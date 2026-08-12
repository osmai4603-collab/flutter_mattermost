import 'package:flutter/material.dart';

import 'mattermost_theme.dart';
import 'theme_utils.dart';

class MattermostColors extends ThemeExtension<MattermostColors> {
  final Color sidebarBg;
  final Color sidebarText;
  final Color sidebarUnreadText;
  final Color sidebarTextHoverBg;
  final Color sidebarTextActiveBorder;
  final Color sidebarTextActiveColor;
  final Color sidebarHeaderBg;
  final Color sidebarTeamBarBg;
  final Color sidebarHeaderTextColor;
  final Color onlineIndicator;
  final Color awayIndicator;
  final Color dndIndicator;
  final Color mentionBg;
  final Color mentionColor;
  final Color centerChannelBg;
  final Color centerChannelColor;
  final Color newMessageSeparator;
  final Color linkColor;
  final Color buttonBg;
  final Color buttonColor;
  final Color errorTextColor;
  final Color mentionHighlightBg;
  final Color mentionHighlightLink;
  final String codeTheme;

  const MattermostColors({
    required this.sidebarBg,
    required this.sidebarText,
    required this.sidebarUnreadText,
    required this.sidebarTextHoverBg,
    required this.sidebarTextActiveBorder,
    required this.sidebarTextActiveColor,
    required this.sidebarHeaderBg,
    required this.sidebarTeamBarBg,
    required this.sidebarHeaderTextColor,
    required this.onlineIndicator,
    required this.awayIndicator,
    required this.dndIndicator,
    required this.mentionBg,
    required this.mentionColor,
    required this.centerChannelBg,
    required this.centerChannelColor,
    required this.newMessageSeparator,
    required this.linkColor,
    required this.buttonBg,
    required this.buttonColor,
    required this.errorTextColor,
    required this.mentionHighlightBg,
    required this.mentionHighlightLink,
    required this.codeTheme,
  });

  factory MattermostColors.fromTheme(MattermostTheme theme) {
    return MattermostColors(
      sidebarBg: theme.sidebarBg,
      sidebarText: theme.sidebarText,
      sidebarUnreadText: theme.sidebarUnreadText,
      sidebarTextHoverBg: theme.sidebarTextHoverBg,
      sidebarTextActiveBorder: theme.sidebarTextActiveBorder,
      sidebarTextActiveColor: theme.sidebarTextActiveColor,
      sidebarHeaderBg: theme.sidebarHeaderBg,
      sidebarTeamBarBg: theme.sidebarTeamBarBg,
      sidebarHeaderTextColor: theme.sidebarHeaderTextColor,
      onlineIndicator: theme.onlineIndicator,
      awayIndicator: theme.awayIndicator,
      dndIndicator: theme.dndIndicator,
      mentionBg: theme.mentionBg,
      mentionColor: theme.mentionColor,
      centerChannelBg: theme.centerChannelBg,
      centerChannelColor: theme.centerChannelColor,
      newMessageSeparator: theme.newMessageSeparator,
      linkColor: theme.linkColor,
      buttonBg: theme.buttonBg,
      buttonColor: theme.buttonColor,
      errorTextColor: theme.errorTextColor,
      mentionHighlightBg: theme.mentionHighlightBg,
      mentionHighlightLink: theme.mentionHighlightLink,
      codeTheme: theme.codeTheme,
    );
  }

  Color get mentionHighlightBgMixed =>
      blendColors(centerChannelBg, mentionHighlightBg, 0.5);

  Color get pinnedHighlightBgMixed =>
      blendColors(centerChannelBg, mentionHighlightBg, 0.24);

  Color get ownHighlightBg =>
      blendColors(mentionHighlightBg, centerChannelColor, 0.05);

  @override
  MattermostColors copyWith({
    Color? sidebarBg,
    Color? sidebarText,
    Color? sidebarUnreadText,
    Color? sidebarTextHoverBg,
    Color? sidebarTextActiveBorder,
    Color? sidebarTextActiveColor,
    Color? sidebarHeaderBg,
    Color? sidebarTeamBarBg,
    Color? sidebarHeaderTextColor,
    Color? onlineIndicator,
    Color? awayIndicator,
    Color? dndIndicator,
    Color? mentionBg,
    Color? mentionColor,
    Color? centerChannelBg,
    Color? centerChannelColor,
    Color? newMessageSeparator,
    Color? linkColor,
    Color? buttonBg,
    Color? buttonColor,
    Color? errorTextColor,
    Color? mentionHighlightBg,
    Color? mentionHighlightLink,
    String? codeTheme,
  }) {
    return MattermostColors(
      sidebarBg: sidebarBg ?? this.sidebarBg,
      sidebarText: sidebarText ?? this.sidebarText,
      sidebarUnreadText: sidebarUnreadText ?? this.sidebarUnreadText,
      sidebarTextHoverBg: sidebarTextHoverBg ?? this.sidebarTextHoverBg,
      sidebarTextActiveBorder:
          sidebarTextActiveBorder ?? this.sidebarTextActiveBorder,
      sidebarTextActiveColor:
          sidebarTextActiveColor ?? this.sidebarTextActiveColor,
      sidebarHeaderBg: sidebarHeaderBg ?? this.sidebarHeaderBg,
      sidebarTeamBarBg: sidebarTeamBarBg ?? this.sidebarTeamBarBg,
      sidebarHeaderTextColor:
          sidebarHeaderTextColor ?? this.sidebarHeaderTextColor,
      onlineIndicator: onlineIndicator ?? this.onlineIndicator,
      awayIndicator: awayIndicator ?? this.awayIndicator,
      dndIndicator: dndIndicator ?? this.dndIndicator,
      mentionBg: mentionBg ?? this.mentionBg,
      mentionColor: mentionColor ?? this.mentionColor,
      centerChannelBg: centerChannelBg ?? this.centerChannelBg,
      centerChannelColor: centerChannelColor ?? this.centerChannelColor,
      newMessageSeparator: newMessageSeparator ?? this.newMessageSeparator,
      linkColor: linkColor ?? this.linkColor,
      buttonBg: buttonBg ?? this.buttonBg,
      buttonColor: buttonColor ?? this.buttonColor,
      errorTextColor: errorTextColor ?? this.errorTextColor,
      mentionHighlightBg: mentionHighlightBg ?? this.mentionHighlightBg,
      mentionHighlightLink: mentionHighlightLink ?? this.mentionHighlightLink,
      codeTheme: codeTheme ?? this.codeTheme,
    );
  }

  @override
  MattermostColors lerp(ThemeExtension<MattermostColors>? other, double t) {
    if (other is! MattermostColors) {
      return this;
    }
    return MattermostColors(
      sidebarBg: Color.lerp(sidebarBg, other.sidebarBg, t)!,
      sidebarText: Color.lerp(sidebarText, other.sidebarText, t)!,
      sidebarUnreadText: Color.lerp(
        sidebarUnreadText,
        other.sidebarUnreadText,
        t,
      )!,
      sidebarTextHoverBg: Color.lerp(
        sidebarTextHoverBg,
        other.sidebarTextHoverBg,
        t,
      )!,
      sidebarTextActiveBorder: Color.lerp(
        sidebarTextActiveBorder,
        other.sidebarTextActiveBorder,
        t,
      )!,
      sidebarTextActiveColor: Color.lerp(
        sidebarTextActiveColor,
        other.sidebarTextActiveColor,
        t,
      )!,
      sidebarHeaderBg: Color.lerp(sidebarHeaderBg, other.sidebarHeaderBg, t)!,
      sidebarTeamBarBg: Color.lerp(
        sidebarTeamBarBg,
        other.sidebarTeamBarBg,
        t,
      )!,
      sidebarHeaderTextColor: Color.lerp(
        sidebarHeaderTextColor,
        other.sidebarHeaderTextColor,
        t,
      )!,
      onlineIndicator: Color.lerp(onlineIndicator, other.onlineIndicator, t)!,
      awayIndicator: Color.lerp(awayIndicator, other.awayIndicator, t)!,
      dndIndicator: Color.lerp(dndIndicator, other.dndIndicator, t)!,
      mentionBg: Color.lerp(mentionBg, other.mentionBg, t)!,
      mentionColor: Color.lerp(mentionColor, other.mentionColor, t)!,
      centerChannelBg: Color.lerp(centerChannelBg, other.centerChannelBg, t)!,
      centerChannelColor: Color.lerp(
        centerChannelColor,
        other.centerChannelColor,
        t,
      )!,
      newMessageSeparator: Color.lerp(
        newMessageSeparator,
        other.newMessageSeparator,
        t,
      )!,
      linkColor: Color.lerp(linkColor, other.linkColor, t)!,
      buttonBg: Color.lerp(buttonBg, other.buttonBg, t)!,
      buttonColor: Color.lerp(buttonColor, other.buttonColor, t)!,
      errorTextColor: Color.lerp(errorTextColor, other.errorTextColor, t)!,
      mentionHighlightBg: Color.lerp(
        mentionHighlightBg,
        other.mentionHighlightBg,
        t,
      )!,
      mentionHighlightLink: Color.lerp(
        mentionHighlightLink,
        other.mentionHighlightLink,
        t,
      )!,
      codeTheme: t < 0.5 ? codeTheme : other.codeTheme,
    );
  }
}
