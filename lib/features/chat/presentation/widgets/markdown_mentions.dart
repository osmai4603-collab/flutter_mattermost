import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/groups/data/group_mention_names.dart';
import 'package:markdown/markdown.dart' as md;

/// يحوّل `@username` داخل نص الـ Markdown إلى عنصر `mention`
/// (بما فيها التنبيهات الخاصة @all/@channel/@here ومنشنات المجموعات).
class MentionInlineSyntax extends md.InlineSyntax {
  MentionInlineSyntax()
      : super(r'(?:\B|\b_+)@([a-zA-Z0-9_.-]+)', startCharacter: 0x40);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final name = match[1] ?? '';
    if (name.isEmpty) return false;
    final element = md.Element('mention', [md.Text('@$name')]);
    element.attributes['name'] = name;
    parser.addNode(element);
    return true;
  }
}

/// يحوّل `~channel_name` داخل نص الـ Markdown إلى عنصر `channel`.
class ChannelMentionInlineSyntax extends md.InlineSyntax {
  ChannelMentionInlineSyntax()
      : super(r'(?:\B|\b_+)~([a-zA-Z0-9_.-]+)', startCharacter: 0x7E);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final name = match[1] ?? '';
    if (name.isEmpty) return false;
    final element = md.Element('channel', [md.Text('~$name')]);
    element.attributes['name'] = name;
    parser.addNode(element);
    return true;
  }
}

/// مجموعة الامتدادات المخصصة — القاعدة نفسها الموجودة في gitHubFlavored
/// مع إضافة منشنات المستخدمين والقنوات.
///
/// ملاحظة: تُدرج أنماط المنشنات قبل `StrikethroughSyntax` لأن نمطه `~+`
/// يستهلك `~` البادئة لرابط القناة إن جاء بعده.
final md.ExtensionSet markdownExtensionSet = md.ExtensionSet(
  List<md.BlockSyntax>.unmodifiable(
    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
  ),
  List<md.InlineSyntax>.unmodifiable([
    MentionInlineSyntax(),
    ChannelMentionInlineSyntax(),
    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
  ]),
);

/// يُرجع نص `@name` بأسلوب المنشن — لون الرابط، بدون سطر سفلي.
///
/// - تنبيه خاص (@all/@channel/@here) → خلفية Pill مظللة بدون نقر.
/// - منشن المستخدم الحالي (Self-Mention) → تظليل `mention--highlight`.
/// - منشن مجموعة `@group-name` → لون رابط فقط (`group-mention-link`)
///   مع فتح [onGroupTap] عند النقر.
/// - منشن مستخدم عادي → رابط يفتح [onTap].
class MentionElementBuilder extends MarkdownElementBuilder {
  /// اسم مستخدم الحساب الحالي — لتظليل منشن المستخدم نفسه.
  final String currentUsername;

  /// معرف الحساب الحالي (احتياطي مستقبلي للمقارنات حسب المعرّف).
  final String? currentUserId;

  /// أسماء المجموعات القابلة للإشارة — لتمييز `@group-name` عن منشنات
  /// المستخدمين. الافتراضي: [cachedGroupMentionNames] (يُجلب من الخادم).
  final Future<Set<String>> groupNames;

  /// استدعاء عند النقر على منشن مستخدم — يُمرَّر الاسم (بدون `@`).
  final ValueChanged<String>? onTap;

  /// استدعاء عند النقر على منشن مجموعة — يُمرَّر اسم المجموعة (بدون `@`).
  final ValueChanged<String>? onGroupTap;

  MentionElementBuilder({
    this.onTap,
    this.onGroupTap,
    this.currentUsername = '',
    this.currentUserId,
    Future<Set<String>>? groupNames,
  }) : groupNames = groupNames ?? cachedGroupMentionNames();

  @override
  bool isBlockElement() => false;

  static const Set<String> _specialMentions = {'all', 'channel', 'here'};

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final name = element.attributes['name'] ?? '';
    if (name.isEmpty) return null;

    final theme = Theme.of(context).extension<MattermostColors>();
    final linkColor = theme?.linkColor ?? Theme.of(context).colorScheme.primary;
    final base = parentStyle ?? const TextStyle(fontSize: 14, height: 1.55);
    final lower = name.toLowerCase();

    final isSpecial = _specialMentions.contains(lower);
    if (isSpecial) {
      final text = Text(
        '@$name',
        style: base.copyWith(
          color: linkColor,
          fontWeight: FontWeight.w600,
        ),
      );
      return DecoratedBox(
        decoration: BoxDecoration(
          color: (theme?.mentionHighlightBg ?? linkColor).withValues(
            alpha: 0.35,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
          child: text,
        ),
      );
    }

    return FutureBuilder<Set<String>>(
      future: groupNames,
      builder: (context, snapshot) {
        final names = snapshot.data ?? const <String>{};
        final isGroup = names.contains(lower);
        final isSelf =
            currentUsername.isNotEmpty && lower == currentUsername.toLowerCase();

        if (isGroup) {
          final text = Text(
            '@$name',
            style: base.copyWith(
              color: linkColor,
              fontWeight: FontWeight.w600,
            ),
          );
          return GestureDetector(
            onTap: () => onGroupTap?.call(name),
            behavior: HitTestBehavior.opaque,
            child: text,
          );
        }

        final text = Text(
          '@$name',
          style: base.copyWith(
            color: isSelf
                ? (theme?.mentionHighlightLink ?? linkColor)
                : linkColor,
            fontWeight: FontWeight.w600,
          ),
        );

        return GestureDetector(
          onTap: () => onTap?.call(name),
          behavior: HitTestBehavior.opaque,
          child: isSelf
              ? DecoratedBox(
                  decoration: BoxDecoration(
                    color: (theme?.mentionHighlightBg ?? linkColor).withValues(
                      alpha: 1,
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 0.5,
                    ),
                    child: text,
                  ),
                )
              : text,
        );
      },
    );
  }
}

/// يُرجع نص `~channel` بأسلوب رابط القناة — لون الرابط مع سطر سفلي خفيف.
class ChannelMentionElementBuilder extends MarkdownElementBuilder {
  final ValueChanged<String>? onTap;

  ChannelMentionElementBuilder({this.onTap});

  @override
  bool isBlockElement() => false;

  @override
  Widget? visitElementAfterWithContext(
    BuildContext context,
    md.Element element,
    TextStyle? preferredStyle,
    TextStyle? parentStyle,
  ) {
    final name = element.attributes['name'] ?? '';
    if (name.isEmpty) return null;

    final theme = Theme.of(context).extension<MattermostColors>();
    final linkColor = theme?.linkColor ?? Theme.of(context).colorScheme.primary;
    final base = parentStyle ?? const TextStyle(fontSize: 14, height: 1.55);

    return GestureDetector(
      onTap: () => onTap?.call(name),
      behavior: HitTestBehavior.opaque,
      child: Text(
        '~$name',
        style: base.copyWith(
          color: linkColor,
          fontWeight: FontWeight.w600,
          decoration: TextDecoration.underline,
          decorationColor: linkColor.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
