import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/network/server_manager.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/widgets/profile_picture.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_controller.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_item.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/commands/slash_commands_registry.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/custom_emoji.dart';

/// قائمة الإكمال التلقائي — مربعة صغيرة تُعرض داخل [OverlayEntry] فوق المحرر.
/// كل عنصر قابل للنقر: النقر يُدرج النص (اسم المستخدم/الأمر/...) في المحرر.
class AutocompleteOverlay extends StatefulWidget {
  final AutocompleteController controller;

  /// حجم المربع (الطول = العرض).
  final double size;

  const AutocompleteOverlay({
    super.key,
    required this.controller,
    required this.size,
  });

  @override
  State<AutocompleteOverlay> createState() => _AutocompleteOverlayState();
}

class _AutocompleteOverlayState extends State<AutocompleteOverlay> {
  @override
  void initState() {
    super.initState();
    // تحميل الإيموجي المخصص للعرض في القائمة (يُخزَّن مؤقتاً).
    loadCustomEmojis();
  }

  String _avatarUrlForUser(String? userId) {
    if (userId == null || userId.isEmpty) return '';
    final base = getIt<ServerManager>().activeServerUrl;
    return '$base/api/v4/users/$userId/image';
  }

  String _subtitleFor(AutocompleteItem item, AppLocalizations l10n) {
    if (item.subtitle != null && item.subtitle!.isNotEmpty) {
      return item.subtitle!;
    }
    if (item.kind == AutocompleteKind.command) {
      final cmd = SlashCommandsRegistry.match(item.title.substring(1));
      if (cmd != null) return cmd.description(l10n);
      return '';
    }
    if (item.special) {
      return switch (item.title.substring(1)) {
        'all' => l10n.autocompleteMentionAll,
        'channel' => l10n.autocompleteMentionChannel,
        _ => l10n.autocompleteMentionHere,
      };
    }
    return '';
  }

  Widget _leadingFor(AutocompleteItem item) {
    switch (item.kind) {
      case AutocompleteKind.mention:
        if (item.special) {
          return Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.campaign_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.error,
            ),
          );
        }
        return ProfilePicture(
          avatarUrl: _avatarUrlForUser(item.userId),
          username: item.userId ?? '',
          status: item.status,
          size: 32,
          showStatus: true,
        );
      case AutocompleteKind.channel:
        final isPrivate = item.channelType == 'P' || item.channelType == 'G';
        final isDirect = item.channelType == 'D';
        return Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.of(context).linkColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isDirect
                ? Icons.alternate_email
                : isPrivate
                ? Icons.lock_outline
                : Icons.tag,
            size: 18,
            color: AppTheme.of(context).linkColor,
          ),
        );
      case AutocompleteKind.command:
        return Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.of(
              context,
            ).centerChannelColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '/',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: AppTheme.of(context).centerChannelColor,
            ),
          ),
        );
      case AutocompleteKind.emoji:
        return SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: emojiWidget(
              item.emojiUnicode ?? ':${item.emojiName}:',
              size: 24,
            ),
          ),
        );
    }
  }

  /// النص المعروض أسفل العنصر (اسم المستخدم / الأمر / ...).
  String _labelFor(AutocompleteItem item) {
    if (item.kind == AutocompleteKind.emoji) return '';
    return item.title;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        if (!widget.controller.isOpen) return const SizedBox.shrink();
        final items = widget.controller.items;
        final isEmojiGrid =
            items.isNotEmpty &&
            items.every((i) => i.kind == AutocompleteKind.emoji);
        final crossAxisCount = isEmojiGrid ? 4 : 3;

        return Material(
          elevation: 4,
          color: theme.centerChannelBg,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.centerChannelColor.withValues(alpha: 0.15),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: items.isEmpty
                ? Center(
                    child: Text(
                      l10n.quickSwitcherNoResults,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                : GridView.builder(
                    // مفتاح شفاف يجبر إعادة بناء عند تغيّر الحجم/التحديد.
                    key: ValueKey(
                      'ac-${items.length}-${widget.controller.selectedIndex}',
                    ),
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      childAspectRatio: isEmojiGrid ? 1 : 0.9,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final selected =
                          index == widget.controller.selectedIndex;
                      return _AutocompleteCell(
                        item: item,
                        selected: selected,
                        label: _labelFor(item),
                        subtitle: _subtitleFor(item, l10n),
                        leading: _leadingFor(item),
                        showAdminBadge:
                            item.kind == AutocompleteKind.mention &&
                            !item.special &&
                            _isAdmin(item.roles),
                        onHover: () => widget.controller.selectIndex(index),
                        onTap: () => widget.controller.insertAt(index),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }

  bool _isAdmin(String? roles) =>
      roles != null &&
      (roles.contains('system_admin') || roles.contains('team_admin'));
}

/// خلية مربعة قابلة للنقر داخل شبكة الإكمال التلقائي.
class _AutocompleteCell extends StatelessWidget {
  final AutocompleteItem item;
  final bool selected;
  final String label;
  final String subtitle;
  final Widget leading;
  final bool showAdminBadge;
  final VoidCallback onHover;
  final VoidCallback onTap;

  const _AutocompleteCell({
    required this.item,
    required this.selected,
    required this.label,
    required this.subtitle,
    required this.leading,
    required this.showAdminBadge,
    required this.onHover,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return MouseRegion(
      onEnter: (_) => onHover(),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: selected
                ? theme.linkColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              leading,
              if (item.kind == AutocompleteKind.emoji) ...[
                const SizedBox(height: 2),
                Text(
                  ':${item.emojiName}:',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    color: theme.centerChannelColor.withValues(alpha: 0.5),
                  ),
                ),
              ] else ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: item.special
                              ? theme.errorTextColor
                              : theme.centerChannelColor,
                        ),
                      ),
                    ),
                    if (showAdminBadge &&
                        selected) ...[
                      const SizedBox(width: 2),
                      Icon(
                        Icons.verified,
                        size: 10,
                        color: theme.linkColor,
                      ),
                    ],
                  ],
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9,
                      color: theme.centerChannelColor.withValues(alpha: 0.5),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}