import 'dart:math' as math;

/// نتيجة فحص المنشنات الخاصة في النص.
///
/// نظير `specialMentionsInText` في webapp
/// (webapp/channels/src/utils/post_utils.ts).
class SpecialMentions {
  final bool all;
  final bool channel;
  final bool here;

  const SpecialMentions({this.all = false, this.channel = false, this.here = false});

  bool get hasAny => all || channel || here;

  /// الأسماء المعروضة مثل `@all` — تُستخدم في نافذة التأكيد.
  List<String> get names {
    final names = <String>[];
    if (all) names.add('@all');
    if (channel) names.add('@channel');
    if (here) names.add('@here');
    return names;
  }

  @override
  String toString() => 'SpecialMentions(all: $all, channel: $channel, here: $here)';
}

// نفس الأنماط في webapp utils/constants.tsx:
// ALL_MENTION_REGEX = /(?:\B|\b_+)@(all)(?!(\.|-|_)*[^\W_])/gi
final RegExp _allMentionRegex = RegExp(
  r'(?:\B|\b_+)@(all)(?!(\.|-|_)*[^\W_])',
  caseSensitive: false,
);
final RegExp _channelMentionRegex = RegExp(
  r'(?:\B|\b_+)@(channel)(?!(\.|-|_)*[^\W_])',
  caseSensitive: false,
);
final RegExp _hereMentionRegex = RegExp(
  r'(?:\B|\b_+)@(here)(?!(\.|-|_)*[^\W_])',
  caseSensitive: false,
);

final RegExp _emojiNameRegex = RegExp(r'(?<!\w)(:([\w+-]+):)(?!\w)');
final RegExp _codeBlockRegex = RegExp(r'```[\s\S]*?```');
final RegExp _codeSpanRegex = RegExp(r'`[^`\n]*`');
final RegExp _linkOrImageRegex = RegExp(r'!?\[([^\]]*)\]\([^)]*\)');

/// يحوّل النص إلى نص "قابل للفحص": يزيل الإيموجي وكتل الكود والروابط
/// بحيث لا تُحتسب المنشنات داخل الكود أو روابط markdown.
///
/// نظير `MentionableRenderer` (webapp/channels/src/utils/markdown/mentionable_renderer.tsx).
String mentionableText(String text) {
  var result = text.replaceAll(_emojiNameRegex, '');
  result = result.replaceAll(_codeBlockRegex, '\n');
  result = result.replaceAll(_codeSpanRegex, ' ');
  result = result.replaceAllMapped(
    _linkOrImageRegex,
    (m) => ' ${m.group(1) ?? ''} ',
  );
  return result;
}

/// يكشف @all و @channel و @here خارج كتل الكود والروابط.
/// لا يعمل مع أوامر slash (تبدأ بـ /) — نفس سلوك webapp.
SpecialMentions specialMentionsInText(String text) {
  if (text.isEmpty || text.startsWith('/')) {
    return const SpecialMentions();
  }
  final mentionable = mentionableText(text);
  return SpecialMentions(
    all: _allMentionRegex.hasMatch(mentionable),
    channel: _channelMentionRegex.hasMatch(mentionable),
    here: _hereMentionRegex.hasMatch(mentionable),
  );
}

/// جميع المنشنات `@name` في النص (بما فيها @all/@channel/@here).
List<String> allAtMentions(String text) {
  if (text.isEmpty || text.startsWith('/')) return const [];
  final mentionable = mentionableText(text);
  final matches = RegExp(r'(?:\B|\b_+)@([a-zA-Z0-9_.-]+)')
      .allMatches(mentionable)
      .map((m) => m.group(1) ?? '')
      .where((name) => name.isNotEmpty)
      .toList();
  return matches;
}

/// تعداد طبيعي للأسماء (رقمي + حساسية الحالة) — نظير localeCompare(numeric: true).
int naturalCompare(String a, String b) {
  final aTokens = RegExp(r'\d+|\D+').allMatches(a).map((m) => m.group(0)!).toList();
  final bTokens = RegExp(r'\d+|\D+').allMatches(b).map((m) => m.group(0)!).toList();

  final length = math.min(aTokens.length, bTokens.length);
  for (var i = 0; i < length; i++) {
    final at = aTokens[i];
    final bt = bTokens[i];
    final aNum = int.tryParse(at);
    final bNum = int.tryParse(bt);
    if (aNum != null && bNum != null) {
      if (aNum != bNum) return aNum.compareTo(bNum);
    } else {
      final cmp = at.toLowerCase().compareTo(bt.toLowerCase());
      if (cmp != 0) return cmp;
    }
  }
  return a.length.compareTo(b.length);
}

/// ينشئ معرّف عميل فريد لعمليات الرفع — نظير generateId في webapp.
String generateClientId() =>
    '${DateTime.now().microsecondsSinceEpoch}_${DateTime.now().millisecondsSinceEpoch % 1000}';

/// منشن مُستخرج من النص مع موقعه.
class MentionOccurrence {
  final int start;
  final int end;
  final String name;

  const MentionOccurrence({
    required this.start,
    required this.end,
    required this.name,
  });

  /// هل هو تنبيه خاص (@all/@channel/@here)؟
  bool get isSpecial =>
      name.toLowerCase() == 'all' ||
      name.toLowerCase() == 'channel' ||
      name.toLowerCase() == 'here';
}

/// الاسم المعروض للمستخدم: اللقب إن وُجد، وإلا الاسم الكامل،
/// وإلا username — نظير getDisplayNameByUser في webapp.
String getMentionDisplayName({
  required String username,
  String nickname = '',
  String firstName = '',
  String lastName = '',
}) {
  if (nickname.trim().isNotEmpty) return nickname;
  final full = '$firstName $lastName'.trim();
  if (full.isNotEmpty) return full;
  return username;
}

/// هل يذكر النص أيّاً من مفاتيح الإشارة المحددة؟ — نظير فحص
/// `Post Mention Highlight` في webapp: يطابق `@key` أو `key` مباشرة
/// خارج كتل الكود والروابط (عبر [mentionableText]).
bool textMentionsKeys(String text, List<String> keys) {
  if (text.isEmpty || keys.isEmpty) return false;
  final mentionable = mentionableText(text);
  final pattern = RegExp(
    keys.map((k) => '(?:@?${RegExp.escape(k)})').join('|'),
    caseSensitive: false,
  );
  return pattern.hasMatch(mentionable);
}

/// يستخرج جميع المنشنات `@name` مع مواقعها (بما فيها @all/@channel/@here) —
/// يتجاهل المنشنات داخل كتل الكود والأكواد السطرية.
List<MentionOccurrence> parseMentionsInText(String text) {
  if (text.isEmpty) return const [];
  final excluded = <({int start, int end})>[];
  for (final m in _codeBlockRegex.allMatches(text)) {
    excluded.add((start: m.start, end: m.end));
  }
  for (final m in _codeSpanRegex.allMatches(text)) {
    excluded.add((start: m.start, end: m.end));
  }
  bool isExcluded(int position) =>
      excluded.any((e) => position >= e.start && position < e.end);

  final matchRegex = RegExp(r'(?:\B|\b_+)@([a-zA-Z0-9_.-]+)');
  return matchRegex
      .allMatches(text)
      .where((m) => !isExcluded(m.start) && !isExcluded(m.end))
      .map(
        (m) => MentionOccurrence(
          start: m.start + 1,
          end: m.end,
          name: m.group(1) ?? '',
        ),
      )
      .where((o) => o.name.isNotEmpty)
      .toList();
}
