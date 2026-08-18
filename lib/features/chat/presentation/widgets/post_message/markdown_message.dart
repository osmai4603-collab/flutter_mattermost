import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/code_block_widget.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/post_message/markdown_mentions.dart';
import 'package:flutter_mattermost/features/groups/domain/repositories/groups_repository.dart';
import 'package:flutter_mattermost/features/groups/presentation/widgets/group_popover.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_mattermost/features/users/presentation/pages/user_profile_modal.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

/// فتح بطاقة المستخدم عند الضغط على `@username` داخل نص الرسالة.
Future<void> openUserMention(BuildContext context, String username) async {
  final lower = username.toLowerCase();
  if (lower == 'all' || lower == 'channel' || lower == 'here') return;
  try {
    final user = await getIt<UserRepository>().getUserByUsername(username);
    if (!context.mounted) return;
    await showUserProfile(context, user.id);
  } catch (_) {
    // مستخدم غير موجود أو فشل الشبكة: تجاهل صامت.
  }
}

/// فتح بطاقة المجموعة عند الضغط على `@group-name` داخل نص الرسالة.
Future<void> openGroupMention(BuildContext context, String groupName) async {
  try {
    final groups = await getIt<GroupsRepository>().getGroupsByNames([
      groupName,
    ]);
    if (groups.isEmpty) return;
    if (!context.mounted) return;
    await showGroupPopover(context, groups.first);
  } catch (_) {
    // المجموعة غير موجودة أو الخادم لا يدعم Group Mentions: تجاهل صامت.
  }
}

/// الانتقال إلى قناة عند الضغط على `~channel` داخل نص الرسالة.
Future<void> openChannelMention(
  BuildContext context,
  String channelName,
) async {
  try {
    final teamState = context.read<TeamBloc>().state;
    final teamName = teamState is TeamsLoadedState
        ? teamState.selectedTeam?.name
        : null;
    if (teamName == null) return;
    if (!context.mounted) return;
    context.go('/$teamName/channels/$channelName');
  } catch (_) {
    // لا يوجد فريق محدد أو سياق توجيه: تجاهل صامت.
  }
}

/// خيار قائمة المهام `- [ ]`/`- [x]` — مربع اختيار مخصص بلون الرابط.
Widget _buildTaskCheckbox(bool checked, Color color) {
  return Container(
    width: 14,
    height: 14,
    decoration: BoxDecoration(
      color: checked ? color : Colors.transparent,
      borderRadius: BorderRadius.circular(3),
      border: Border.all(color: color.withValues(alpha: 0.85), width: 1.3),
    ),
    child: checked
        ? const Icon(Icons.check_rounded, size: 11, color: Colors.white)
        : null,
  );
}

Widget _safeMarkdownBody({
  required String data,
  required MarkdownStyleSheet styleSheet,
  ValueChanged<String>? onMentionTap,
  ValueChanged<String>? onGroupMentionTap,
  ValueChanged<String>? onChannelTap,
  required Widget Function(bool) checkboxBuilder,
  String currentUsername = '',
  String? currentUserId,
  int? mentionTime,
}) {
  return MarkdownBody(
    data: data.trim().isEmpty ? ' ' : data,
    onTapLink: (text, href, title) {
      if (href == null || href.isEmpty) return;
      final uri = Uri.tryParse(href);
      if (uri != null) {
        unawaited(launchUrl(uri, mode: LaunchMode.externalApplication));
      }
    },
    extensionSet: markdownExtensionSet,
    builders: {
      'pre': CodeBlockElementBuilder(),
      'mention': MentionElementBuilder(
        onTap: onMentionTap,
        onGroupTap: onGroupMentionTap,
        currentUsername: currentUsername,
        currentUserId: currentUserId,
        mentionTime: mentionTime,
      ),
      'channel': ChannelMentionElementBuilder(onTap: onChannelTap),
    },
    checkboxBuilder: checkboxBuilder,
    styleSheet: styleSheet,
    softLineBreak: true,
    selectable: false,
    listItemCrossAxisAlignment: MarkdownListItemCrossAxisAlignment.start,
  );
}

class MarkdownMessage extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final int? mentionTime;

  /// استدعاء عند الضغط على `@username` — يُمرَّر اسم المستخدم (بدون `@`).
  /// الافتراضي: فتح بطاقة المستخدم عبر [openUserMention].
  final ValueChanged<String>? onMentionTap;

  /// استدعاء عند الضغط على `@group-name` — يُمرَّر اسم المجموعة (بدون `@`).
  /// الافتراضي: فتح بطاقة المجموعة عبر [openGroupMention].
  final ValueChanged<String>? onGroupMentionTap;

  /// استدعاء عند الضغط على `~channel` — يُمرَّر اسم القناة (بدون `~`).
  /// الافتراضي: الانتقال إلى القناة عبر [openChannelMention].
  final ValueChanged<String>? onChannelTap;

  const MarkdownMessage({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.onMentionTap,
    this.onGroupMentionTap,
    this.onChannelTap,
    this.mentionTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<MattermostColors>();
    final textColor =
        theme?.centerChannelColor ?? Theme.of(context).colorScheme.onSurface;
    final linkColor = theme?.linkColor ?? Theme.of(context).colorScheme.primary;
    final strongBackground =
        theme?.centerChannelColor.withValues(alpha: 0.12) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12);
    final quoteBackground =
        theme?.centerChannelColor.withValues(alpha: 0.05) ??
        Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05);
    final codeBlockBackground = const Color(0xFF111827);

    // بيانات الحساب الحالي لتظليل منشن المستخدم نفسه داخل النص.
    final authState = context.read<AuthBloc>().state;
    final currentUser = authState is AuthenticatedState ? authState.user : null;
    final currentUsername = currentUser?.username ?? '';
    final currentUserId = currentUser?.id;

    if (text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    final markdownStyleSheet = MarkdownStyleSheet(
      p:
          style ??
          TextStyle(
            color: textColor.withValues(alpha: 0.96),
            fontSize: 14,
            height: 1.55,
          ),
      a: TextStyle(
        color: linkColor,
        fontWeight: FontWeight.w600,
        decoration: TextDecoration.underline,
        decorationColor: linkColor,
        decorationThickness: 2,
        backgroundColor: linkColor.withValues(alpha: 0.08),
      ),
      strong: TextStyle(fontWeight: FontWeight.w800, color: textColor),
      em: TextStyle(
        fontStyle: FontStyle.italic,
        color: textColor.withValues(alpha: 0.94),
      ),
      code: TextStyle(
        fontFamily: 'monospace',
        fontSize: 12.5,
        color: const Color(0xFFE2E8F0),
        backgroundColor: strongBackground,
      ),
      codeblockDecoration: BoxDecoration(
        color: codeBlockBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      blockquoteDecoration: BoxDecoration(
        color: quoteBackground,
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: linkColor, width: 3)),
      ),
      h1: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w800,
        fontSize: 22,
        height: 1.3,
      ),
      h2: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 19,
        height: 1.35,
      ),
      h3: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 17,
        height: 1.4,
      ),
      blockSpacing: 8,
      listBullet: TextStyle(color: linkColor),
      listIndent: 20,
      tableHead: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w700,
        fontSize: 13,
      ),
      tableBody: TextStyle(
        color: textColor.withValues(alpha: 0.92),
        fontSize: 13,
      ),
      tableBorder: TableBorder.all(color: textColor.withValues(alpha: 0.18)),
      tableColumnWidth: const IntrinsicColumnWidth(),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: textColor.withValues(alpha: 0.14), width: 1),
        ),
      ),
    );

    if (maxLines != null) {
      return Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: markdownStyleSheet.p,
      );
    }

    return _safeMarkdownBody(
      data: text,
      styleSheet: markdownStyleSheet,
      onMentionTap:
          onMentionTap ?? (username) => openUserMention(context, username),
      onGroupMentionTap:
          onGroupMentionTap ?? (group) => openGroupMention(context, group),
      onChannelTap:
          onChannelTap ?? (channel) => openChannelMention(context, channel),
      currentUsername: currentUsername,
      currentUserId: currentUserId,
      mentionTime: mentionTime,
      checkboxBuilder: (checked) => _buildTaskCheckbox(checked, linkColor),
    );
  }
}
