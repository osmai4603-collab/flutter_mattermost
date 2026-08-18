import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/groups/data/group_mention_names.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_mattermost/features/users/presentation/widgets/user_mention_popover.dart';
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

  /// وقت الإشارة (اختياري) لعرضه في الواجهة المنبثقة.
  final int? mentionTime;

  MentionElementBuilder({
    this.onTap,
    this.onGroupTap,
    this.currentUsername = '',
    this.currentUserId,
    this.mentionTime,
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
        style: base.copyWith(color: linkColor, fontWeight: FontWeight.w600),
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
            currentUsername.isNotEmpty &&
            lower == currentUsername.toLowerCase();

        if (isGroup) {
          final text = Text(
            '@$name',
            style: base.copyWith(color: linkColor, fontWeight: FontWeight.w600),
          );
          return GestureDetector(
            onTap: () => onGroupTap?.call(name),
            behavior: HitTestBehavior.opaque,
            child: text,
          );
        }

        return UserMentionWidget(
          name: name,
          isSelf: isSelf,
          linkColor: linkColor,
          highlightBg: theme?.mentionHighlightBg,
          highlightLink: theme?.mentionHighlightLink,
          baseStyle: base,
          onTap: onTap,
          mentionTime: mentionTime,
        );
      },
    );
  }
}

class UserMentionWidget extends StatefulWidget {
  final String name;
  final bool isSelf;
  final Color linkColor;
  final Color? highlightBg;
  final Color? highlightLink;
  final TextStyle baseStyle;
  final ValueChanged<String>? onTap;
  final int? mentionTime;

  const UserMentionWidget({
    super.key,
    required this.name,
    required this.isSelf,
    required this.linkColor,
    this.highlightBg,
    this.highlightLink,
    required this.baseStyle,
    this.onTap,
    this.mentionTime,
  });

  @override
  State<UserMentionWidget> createState() => _UserMentionWidgetState();
}

class _UserMentionWidgetState extends State<UserMentionWidget> {
  bool _isHovered = false;
  final MenuController _menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.isSelf
        ? (widget.highlightLink ?? widget.linkColor)
        : widget.linkColor;

    final text = Text(
      '@${widget.name}',
      style: widget.baseStyle.copyWith(
        color: effectiveColor,
        fontWeight: FontWeight.w600,
        decoration: _isHovered ? TextDecoration.underline : TextDecoration.none,
        decorationColor: effectiveColor,
      ),
    );

    Widget content = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: widget.isSelf
          ? DecoratedBox(
              decoration: BoxDecoration(
                color: (widget.highlightBg ?? widget.linkColor).withValues(
                  alpha: 1.0,
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

    return MenuAnchor(
      controller: _menuController,
      menuChildren: [
        FutureBuilder<UserEntity>(
          future: getIt<UserRepository>().getUserByUsername(widget.name),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                width: 320,
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox(
                width: 320,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('User not found'),
                ),
              );
            }
            return UserMentionPopover(
              user: snapshot.data!,
              mentionTime:
                  widget.mentionTime ?? DateTime.now().millisecondsSinceEpoch,
              onClose: () => _menuController.close(),
              onMessage: () {
                _menuController.close();
                widget.onTap?.call(widget.name);
              },
            );
          },
        ),
      ],
      builder: (context, controller, child) {
        return GestureDetector(
          onTap: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          child: content,
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
