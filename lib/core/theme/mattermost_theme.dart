import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'predefined_themes.dart';
import 'theme_utils.dart';

class MattermostTheme extends Equatable {
  final String type;
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

  const MattermostTheme({
    required this.type,
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

  factory MattermostTheme.fromJson(
    Map<String, dynamic> json, {
    MattermostTheme? defaults,
  }) {
    final base = defaults ?? PredefinedThemes.denim;

    Color color(String key) {
      final value = json[key];
      return value != null
          ? parseHexColor(value as String)
          : base._colorFor(key);
    }

    final sidebarHeaderBg = color('sidebarHeaderBg');
    final hasTeamBar = json['sidebarTeamBarBg'] != null;

    return MattermostTheme(
      type: json['type'] as String? ?? base.type,
      sidebarBg: color('sidebarBg'),
      sidebarText: color('sidebarText'),
      sidebarUnreadText: color('sidebarUnreadText'),
      sidebarTextHoverBg: color('sidebarTextHoverBg'),
      sidebarTextActiveBorder: color('sidebarTextActiveBorder'),
      sidebarTextActiveColor: color('sidebarTextActiveColor'),
      sidebarHeaderBg: sidebarHeaderBg,
      sidebarTeamBarBg: hasTeamBar
          ? color('sidebarTeamBarBg')
          : blendColors(sidebarHeaderBg, const Color(0xFF000000), 0.2),
      sidebarHeaderTextColor: color('sidebarHeaderTextColor'),
      onlineIndicator: color('onlineIndicator'),
      awayIndicator: color('awayIndicator'),
      dndIndicator: color('dndIndicator'),
      mentionBg: color('mentionBg'),
      mentionColor: color('mentionColor'),
      centerChannelBg: color('centerChannelBg'),
      centerChannelColor: color('centerChannelColor'),
      newMessageSeparator: color('newMessageSeparator'),
      linkColor: color('linkColor'),
      buttonBg: color('buttonBg'),
      buttonColor: color('buttonColor'),
      errorTextColor: color('errorTextColor'),
      mentionHighlightBg: color('mentionHighlightBg'),
      mentionHighlightLink: color('mentionHighlightLink'),
      codeTheme: json['codeTheme'] as String? ?? base.codeTheme,
    );
  }

  Color _colorFor(String key) {
    switch (key) {
      case 'sidebarBg':
        return sidebarBg;
      case 'sidebarText':
        return sidebarText;
      case 'sidebarUnreadText':
        return sidebarUnreadText;
      case 'sidebarTextHoverBg':
        return sidebarTextHoverBg;
      case 'sidebarTextActiveBorder':
        return sidebarTextActiveBorder;
      case 'sidebarTextActiveColor':
        return sidebarTextActiveColor;
      case 'sidebarHeaderBg':
        return sidebarHeaderBg;
      case 'sidebarTeamBarBg':
        return sidebarTeamBarBg;
      case 'sidebarHeaderTextColor':
        return sidebarHeaderTextColor;
      case 'onlineIndicator':
        return onlineIndicator;
      case 'awayIndicator':
        return awayIndicator;
      case 'dndIndicator':
        return dndIndicator;
      case 'mentionBg':
        return mentionBg;
      case 'mentionColor':
        return mentionColor;
      case 'centerChannelBg':
        return centerChannelBg;
      case 'centerChannelColor':
        return centerChannelColor;
      case 'newMessageSeparator':
        return newMessageSeparator;
      case 'linkColor':
        return linkColor;
      case 'buttonBg':
        return buttonBg;
      case 'buttonColor':
        return buttonColor;
      case 'errorTextColor':
        return errorTextColor;
      case 'mentionHighlightBg':
        return mentionHighlightBg;
      case 'mentionHighlightLink':
        return mentionHighlightLink;
      default:
        throw ArgumentError.value(key, 'key', 'Unknown theme color');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sidebarBg': colorToHex(sidebarBg),
      'sidebarText': colorToHex(sidebarText),
      'sidebarUnreadText': colorToHex(sidebarUnreadText),
      'sidebarTextHoverBg': colorToHex(sidebarTextHoverBg),
      'sidebarTextActiveBorder': colorToHex(sidebarTextActiveBorder),
      'sidebarTextActiveColor': colorToHex(sidebarTextActiveColor),
      'sidebarHeaderBg': colorToHex(sidebarHeaderBg),
      'sidebarTeamBarBg': colorToHex(sidebarTeamBarBg),
      'sidebarHeaderTextColor': colorToHex(sidebarHeaderTextColor),
      'onlineIndicator': colorToHex(onlineIndicator),
      'awayIndicator': colorToHex(awayIndicator),
      'dndIndicator': colorToHex(dndIndicator),
      'mentionBg': colorToHex(mentionBg),
      'mentionColor': colorToHex(mentionColor),
      'centerChannelBg': colorToHex(centerChannelBg),
      'centerChannelColor': colorToHex(centerChannelColor),
      'newMessageSeparator': colorToHex(newMessageSeparator),
      'linkColor': colorToHex(linkColor),
      'buttonBg': colorToHex(buttonBg),
      'buttonColor': colorToHex(buttonColor),
      'errorTextColor': colorToHex(errorTextColor),
      'mentionHighlightBg': colorToHex(mentionHighlightBg),
      'mentionHighlightLink': colorToHex(mentionHighlightLink),
      'codeTheme': codeTheme,
    };
  }

  MattermostTheme copyWith({
    String? type,
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
    return MattermostTheme(
      type: type ?? this.type,
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

  bool get isDark => isDarkColor(centerChannelBg);

  Brightness get brightness => isDark ? Brightness.dark : Brightness.light;

  @override
  List<Object?> get props => [
    type,
    sidebarBg,
    sidebarText,
    sidebarUnreadText,
    sidebarTextHoverBg,
    sidebarTextActiveBorder,
    sidebarTextActiveColor,
    sidebarHeaderBg,
    sidebarTeamBarBg,
    sidebarHeaderTextColor,
    onlineIndicator,
    awayIndicator,
    dndIndicator,
    mentionBg,
    mentionColor,
    centerChannelBg,
    centerChannelColor,
    newMessageSeparator,
    linkColor,
    buttonBg,
    buttonColor,
    errorTextColor,
    mentionHighlightBg,
    mentionHighlightLink,
    codeTheme,
  ];
}
