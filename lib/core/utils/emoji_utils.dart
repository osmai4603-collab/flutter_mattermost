// Copyright (c) 2015-present Mattermost, Inc. All Rights Reserved.
// See LICENSE.txt for license information.

import 'package:flutter_mattermost/core/utils/mattermost_emoji_map.dart';

/// Utilities for handling emoji characters and asset filenames.
class EmojiUtils {
  EmojiUtils._();

  /// Converts an emoji unicode string to its corresponding filename in assets.
  /// Example: '😀' -> '1f600.png'
  /// Example: '👨‍⚕️' -> '1f468-200d-2695-fe0f.png'
  static String emojiToFilename(String emoji) {
    final runes = emoji.runes;
    final parts = runes.map((rune) {
      final hex = rune.toRadixString(16).toLowerCase();
      // Pad to 4 digits if it's in the Basic Multilingual Plane (<= 0xFFFF).
      // Standard for many emoji asset sets including Mattermost's.
      if (rune <= 0xFFFF) {
        return hex.padLeft(4, '0');
      }
      return hex;
    });
    return '${parts.join('-')}.png';
  }

  /// Returns the full asset path for a unicode emoji.
  static String emojiAssetPath(String emoji) {
    return 'assets/images/emoji/${emojiToFilename(emoji)}';
  }

  /// Resolves an emoji string to its Mattermost-compatible shortcode name.
  ///
  /// Handles three input formats:
  /// 1. Unicode characters (e.g., '👍') -> 'thumbsup' or '+1'
  /// 2. Colon-wrapped names (e.g., ':thumbsup:') -> 'thumbsup'
  /// 3. Bare shortcode names (e.g., 'thumbsup') -> 'thumbsup' (passthrough)
  ///
  /// Returns the Mattermost shortcode name suitable for the REST API,
  /// or the original input if no mapping is found.
  static String resolveToMattermostName(String emoji) {
    var cleaned = emoji.trim();
    if (cleaned.isEmpty) return cleaned;

    // Strip surrounding colons: ':thumbsup:' -> 'thumbsup'
    if (cleaned.startsWith(':') &&
        cleaned.endsWith(':') &&
        cleaned.length > 2) {
      cleaned = cleaned.substring(1, cleaned.length - 1).toLowerCase();
      return cleaned;
    }

    // If it looks like an already-resolved shortcode (ascii only, no spaces),
    // return as-is.
    if (_isAsciiShortcode(cleaned)) {
      return cleaned.toLowerCase();
    }

    // Try to resolve unicode character(s) to Mattermost shortcode.
    final resolved = kUnicodeToMattermostEmoji[cleaned];
    if (resolved != null) {
      return resolved;
    }

    // Fallback: return the cleaned input (best effort).
    return cleaned;
  }

  /// Resolves a Mattermost shortcode name to its unicode character(s).
  ///
  /// Returns the unicode emoji string (e.g. '+1' -> '👍') or null
  /// if the shortcode is not a known system emoji.
  static String? resolveToUnicode(String shortcode) {
    final cleaned = shortcode.trim();
    if (cleaned.isEmpty) return null;
    return kMattermostEmojiToUnicode[cleaned];
  }

  /// Returns true if the string is a plain ASCII shortcode like 'thumbsup'.
  static bool _isAsciiShortcode(String s) {
    for (var i = 0; i < s.length; i++) {
      if (s.codeUnitAt(i) > 127) return false;
    }
    return true;
  }
}
