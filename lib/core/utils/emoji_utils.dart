// Copyright (c) 2015-present Mattermost, Inc. All Rights Reserved.
// See LICENSE.txt for license information.

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
}
