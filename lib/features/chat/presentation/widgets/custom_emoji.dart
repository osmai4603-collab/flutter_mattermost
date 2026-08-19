import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/utils/emoji_utils.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/emoji_remote_data_source.dart';
import 'package:flutter_mattermost/features/system/domain/entities/emoji_entity.dart';

/// ذاكرة مؤقتة للإيموجي المخصص (الاسم → Entity) — تُملأ عند أول استخدام.
Map<String, EmojiEntity>? _customEmojisCache;

/// جلب الإيموجي المخصص من الخادم (مرة واحدة مع تخزين مؤقت).
Future<Map<String, EmojiEntity>> loadCustomEmojis() async {
  if (_customEmojisCache != null) return _customEmojisCache!;
  try {
    final emojis = await getIt<EmojiRemoteDataSource>().getCustomEmojis();
    _customEmojisCache = {
      for (final e in emojis)
        if (e.name.isNotEmpty && e.id.isNotEmpty) e.name: e,
    };
  } catch (_) {
    _customEmojisCache = {};
  }
  return _customEmojisCache!;
}

/// هل القيمة نص يونيكود (وليست اسم إيموجي مخصص)؟
bool _isUnicodeEmoji(String value) =>
    value.runes.any((rune) => rune > 0x80);

/// رابط صورة إيموجي مخصص على الخادم.
String _emojiImageUrl(String emojiId) {
  final base = getIt<ServerManager>().activeServerUrl;
  return '$base/api/v4/emoji/$emojiId/image';
}

/// يعرض الإيموجي: نص لليونيكود، صورة للإيموجي المخصص المعروف،
/// وإلا النص الخام (كلمات مثل `:name:` قبل التحميل).
Widget emojiWidget(
  String value, {
  double size = 18,
  MattermostColors? theme,
}) {
  if (_isUnicodeEmoji(value)) {
    return Image.asset(
      EmojiUtils.emojiAssetPath(value),
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Text(value, style: TextStyle(fontSize: size));
      },
    );
  }

  // Resolve Mattermost shortcode (e.g. '+1', 'heart') to unicode for display.
  final resolved = EmojiUtils.resolveToUnicode(value);
  if (resolved != null) {
    return Image.asset(
      EmojiUtils.emojiAssetPath(resolved),
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Text(value, style: TextStyle(fontSize: size));
      },
    );
  }

  final emoji = _customEmojisCache?[value];
  if (emoji == null) {
    return Text(value, style: TextStyle(fontSize: size));
  }
  return CustomEmojiImage(emojiId: emoji.id, size: size);
}

/// صورة إيموجي مخصص من الخادم مع fallback لرمز ملف.
class CustomEmojiImage extends StatelessWidget {
  final String emojiId;
  final double size;

  const CustomEmojiImage({super.key, required this.emojiId, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MattermostColors>();
    final color = theme?.centerChannelColor.withValues(alpha: 0.5) ??
        Colors.black45;
    return CachedNetworkImage(
      imageUrl: _emojiImageUrl(emojiId),
      width: size,
      height: size,
      fit: BoxFit.contain,
      placeholder: (_, __) => SizedBox(
        width: size,
        height: size,
        child: Center(
          child: SizedBox(
            width: size * 0.5,
            height: size * 0.5,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: color,
            ),
          ),
        ),
      ),
      errorWidget: (_, __, ___) => Icon(Icons.image_outlined, size: size, color: color),
    );
  }
}

/// تحليل النص وبناء spans مع إيموجي مخصص (`:name:`) داخل [RichText].
List<InlineSpan> emojiAwareSpans(String text, TextStyle style) {
  if (_customEmojisCache == null || _customEmojisCache!.isEmpty) {
    return [TextSpan(text: text, style: style)];
  }
  final spans = <InlineSpan>[];
  final regex = RegExp(r':([a-zA-Z0-9_+-]+):');
  var last = 0;
  for (final match in regex.allMatches(text)) {
    if (match.start > last) {
      spans.add(TextSpan(text: text.substring(last, match.start), style: style));
    }
    final name = match.group(1);
    if (name != null && _customEmojisCache!.containsKey(name)) {
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: CustomEmojiImage(
            emojiId: _customEmojisCache![name]!.id,
            size: (style.fontSize ?? 14) * 1.25,
          ),
        ),
      );
    } else {
      spans.add(TextSpan(text: match.group(0), style: style));
    }
    last = match.end;
  }
  if (last < text.length) {
    spans.add(TextSpan(text: text.substring(last), style: style));
  }
  return spans;
}

/// إعادة تعيين الذاكرة المؤقتة (للاختبارات).
void clearCustomEmojisCache() => _customEmojisCache = null;
