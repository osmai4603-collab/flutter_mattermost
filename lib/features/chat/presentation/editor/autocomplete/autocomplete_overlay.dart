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

/// قائمة الإكمال التلقائي — تُعرض داخل [CompositedTransformFollower]
/// فوق المحرر. تدعم تمييز العنصر المحدد وتمرير القائمة.
class AutocompleteOverlay extends StatefulWidget {
  final AutocompleteController controller;
  final double height;

  const AutocompleteOverlay({
    super.key,
    required this.controller,
    required this.height,
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
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
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
          size: 28,
          showStatus: true,
        );
      case AutocompleteKind.channel:
        final isPrivate = item.channelType == 'P' || item.channelType == 'G';
        final isDirect = item.channelType == 'D';
        return Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.of(context).linkColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
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
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppTheme.of(
              context,
            ).centerChannelColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '/',
            style: TextStyle(
              fontSize: 18,
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
              size: 22,
            ),
          ),
        );
    }
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

        return Material(
          elevation: 4,
          color: theme.centerChannelBg,
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: 300,
            constraints: BoxConstraints(maxHeight: widget.height),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.centerChannelColor.withValues(alpha: 0.15),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (items.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                    child: Text(
                      l10n.quickSwitcherNoResults,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: isEmojiGrid
                        ? _EmojiGrid(
                            items: items,
                            controller: widget.controller,
                          )
                        : ListView.builder(
                            // مفتاح شفاف يجبر إعادة بناء عند تغيّر الحجم/التحديد.
                            key: ValueKey(
                              'ac-${items.length}-${widget.controller.selectedIndex}',
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemExtent: 48,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              final selected =
                                  index == widget.controller.selectedIndex;
                              return _AutocompleteRow(
                                item: item,
                                selected: selected,
                                subtitle: _subtitleFor(item, l10n),
                                leading: _leadingFor(item),
                                showAdminBadge:
                                    item.kind == AutocompleteKind.mention &&
                                    !item.special &&
                                    _isAdmin(item.roles),
                              );
                            },
                          ),
                  ),
              ],
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

/// شبكة الإيموجي — تُعرض بدل القائمة الرأسية عندما تكون كل النتائج إيموجي.
class _EmojiGrid extends StatelessWidget {
  final List<AutocompleteItem> items;
  final AutocompleteController controller;

  const _EmojiGrid({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return GridView.builder(
      // مفتاح شفاف يجبر إعادة بناء عند تغيّر الحجم/التحديد (مثل القائمة).
      key: ValueKey('ac-${items.length}-${controller.selectedIndex}'),
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final selected = index == controller.selectedIndex;
        return MouseRegion(
          onEnter: (_) => controller.selectIndex(index),
          child: InkWell(
            onTap: () => controller.insertAt(index),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              decoration: BoxDecoration(
                color: selected
                    ? theme.linkColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: emojiWidget(
                item.emojiUnicode ?? ':${item.emojiName}:',
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AutocompleteRow extends StatelessWidget {
  final AutocompleteItem item;
  final bool selected;
  final String subtitle;
  final Widget leading;
  final bool showAdminBadge;

  const _AutocompleteRow({
    required this.item,
    required this.selected,
    required this.subtitle,
    required this.leading,
    required this.showAdminBadge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: selected
          ? theme.linkColor.withValues(alpha: 0.1)
          : Colors.transparent,
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: item.special
                              ? theme.errorTextColor
                              : theme.centerChannelColor,
                        ),
                      ),
                    ),
                    if (showAdminBadge) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: theme.linkColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          l10n.autocompleteRoleAdmin,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: theme.linkColor,
                          ),
                        ),
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
                      fontSize: 11,
                      color: theme.centerChannelColor.withValues(alpha: 0.55),
                    ),
                  ),
              ],
            ),
          ),
          if (item.special)
            Icon(
              Icons.notifications_active_outlined,
              size: 15,
              color: theme.errorTextColor.withValues(alpha: 0.7),
            ),
        ],
      ),
    );
  }
}
