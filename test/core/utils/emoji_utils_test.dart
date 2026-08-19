import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_mattermost/core/utils/emoji_utils.dart';

void main() {
  group('EmojiUtils.resolveToMattermostName', () {
    test('converts unicode thumbs up to +1', () {
      expect(EmojiUtils.resolveToMattermostName('👍'), '+1');
    });

    test('converts unicode heart to heart', () {
      expect(EmojiUtils.resolveToMattermostName('❤️'), 'heart');
    });

    test('converts unicode clap to clap', () {
      expect(EmojiUtils.resolveToMattermostName('👏'), 'clap');
    });

    test('converts unicode fire to fire', () {
      expect(EmojiUtils.resolveToMattermostName('🔥'), 'fire');
    });

    test('converts unicode 100 to 100', () {
      expect(EmojiUtils.resolveToMattermostName('💯'), '100');
    });

    test('converts unicode grinning face to grinning', () {
      expect(EmojiUtils.resolveToMattermostName('😀'), 'grinning');
    });

    test('converts unicode party to party', () {
      expect(EmojiUtils.resolveToMattermostName('🎉'), 'tada');
    });

    test('converts unicode thinking to thinking_face', () {
      expect(EmojiUtils.resolveToMattermostName('🤔'), 'thinking_face');
    });

    test('converts unicode thumbs down to -1', () {
      expect(EmojiUtils.resolveToMattermostName('👎'), '-1');
    });

    test('strips colons from shortcode', () {
      expect(EmojiUtils.resolveToMattermostName(':thumbsup:'), 'thumbsup');
    });

    test('lowercases bare shortcode', () {
      expect(EmojiUtils.resolveToMattermostName('ThumbsUp'), 'thumbsup');
    });

    test('passes through already-resolved lowercase shortcode', () {
      expect(EmojiUtils.resolveToMattermostName('thumbsup'), 'thumbsup');
    });

    test('handles empty string', () {
      expect(EmojiUtils.resolveToMattermostName(''), '');
    });

    test('handles whitespace', () {
      expect(EmojiUtils.resolveToMattermostName('  👍  '), '+1');
    });

    test('converts unicode crying face to joy', () {
      expect(EmojiUtils.resolveToMattermostName('😂'), 'joy');
    });

    test('converts unicode party face to partying_face', () {
      expect(EmojiUtils.resolveToMattermostName('🥳'), 'partying_face');
    });

    test('converts unicode ok hand to ok_hand', () {
      expect(EmojiUtils.resolveToMattermostName('👌'), 'ok_hand');
    });

    test('converts unicode sparkle to sparkles', () {
      expect(EmojiUtils.resolveToMattermostName('✨'), 'sparkles');
    });

    test('converts unicode folded hands to pray', () {
      expect(EmojiUtils.resolveToMattermostName('🙏'), 'pray');
    });

    test('converts unicode wave to wave', () {
      expect(EmojiUtils.resolveToMattermostName('👋'), 'wave');
    });
  });

  group('EmojiUtils.resolveToUnicode', () {
    test('resolves +1 shortcode to thumbs up unicode', () {
      final result = EmojiUtils.resolveToUnicode('+1');
      expect(result, isNotNull);
      expect(result!.runes.first, 0x1F44D); // 👍
    });

    test('resolves heart shortcode to red heart unicode', () {
      final result = EmojiUtils.resolveToUnicode('heart');
      expect(result, isNotNull);
      expect(result!.runes.first, 0x2764); // ❤
    });

    test('resolves grinning shortcode to grinning face unicode', () {
      final result = EmojiUtils.resolveToUnicode('grinning');
      expect(result, isNotNull);
      expect(result!.runes.first, 0x1F600); // 😀
    });

    test('resolves -1 shortcode to thumbs down unicode', () {
      final result = EmojiUtils.resolveToUnicode('-1');
      expect(result, isNotNull);
      expect(result!.runes.first, 0x1F44E); // 👎
    });

    test('returns null for unknown shortcode', () {
      expect(EmojiUtils.resolveToUnicode('not_a_real_emoji'), isNull);
    });

    test('returns null for empty string', () {
      expect(EmojiUtils.resolveToUnicode(''), isNull);
    });

    test('handles whitespace around shortcode', () {
      final result = EmojiUtils.resolveToUnicode('  +1  ');
      expect(result, isNotNull);
      expect(result!.runes.first, 0x1F44D);
    });

    test('resolves praying hands shortcode', () {
      final result = EmojiUtils.resolveToUnicode('pray');
      expect(result, isNotNull);
      expect(result!.runes.first, 0x1F64F); // 🙏
    });
  });

  group('EmojiUtils.emojiToFilename', () {
    test('converts simple emoji to filename', () {
      expect(EmojiUtils.emojiToFilename('😀'), '1f600.png');
    });

    test('converts thumbs up to filename', () {
      expect(EmojiUtils.emojiToFilename('👍'), '1f44d.png');
    });
  });
}
