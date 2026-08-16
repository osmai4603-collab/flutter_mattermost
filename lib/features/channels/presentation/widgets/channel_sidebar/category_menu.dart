import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/enums/category_sorting.dart';
import 'package:flutter_mattermost/core/enums/channel_category_type.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/core/widgets/matter_menu.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_category_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/repositories/channel_repository.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';

/// قائمة فئة — مطابق sidebar_category_menu في webapp:
/// تعليم كمقروءة، كتم/إلغاء كتم (لكل الفئات عدا الرسائل المباشرة)،
/// إعادة تسمية وحذف (للمخصصة فقط)، ترتيب القنوات (أبجدي/أحدث/يدوي)،
/// وإنشاء فئة جديدة.
class CategoryMenu extends StatelessWidget {
  final AppLocalizations l10n;
  final MattermostColors theme;
  final ChannelCategoryEntity category;
  final String userId;
  final String teamId;
  final Map<String, ChannelUnreadCounts> unreadCounts;

  const CategoryMenu({
    super.key,
    required this.l10n,
    required this.theme,
    required this.category,
    required this.userId,
    required this.teamId,
    required this.unreadCounts,
  });

  bool get _isCustom => category.type == ChannelCategoryType.custom;

  /// عدد القنوات غير المقروءة في هذه الفئة (لعنصر «تعليم كمقروءة»).
  int get _unreadCount => category.channelIds
      .where((id) => unreadCounts[id]?.hasUnreads ?? false)
      .length;

  @override
  Widget build(BuildContext context) {
    final isDirectMessages =
        category.type == ChannelCategoryType.directMessages;

    // عنصر «ترتيب القنوات» — قائمة فرعية مطابقة sortChannelsMenuItem في webapp.
    final sortSubmenu = <MatterMenuItem>[
      _sortItem(
        context,
        id: 'sort_alpha',
        label: l10n.userSettingsSidebarSortAlpha,
        sorting: CategorySorting.alpha,
      ),
      _sortItem(
        context,
        id: 'sort_recent',
        label: l10n.sidebarSortedByRecencyLabel,
        sorting: CategorySorting.recent,
      ),
      _sortItem(
        context,
        id: 'sort_manual',
        label: l10n.sidebarSortedManually,
        sorting: CategorySorting.manual,
      ),
    ];

    final items = <MatterMenuItem>[
      ...[
        MatterMenuItem(
          id: 'mark_read',
          label:
              '${l10n.sidebar_leftSidebar_category_menuViewCategory} ($_unreadCount)',
          icon: const Icon(Icons.format_list_bulleted_outlined, size: 18),
          onTap: () {
            context.read<ChannelBloc>().add(
              MarkChannelsAsReadEvent(
                category.channelIds
                    .where((id) => unreadCounts[id]?.hasUnreads ?? false)
                    .toList(),
              ),
            );
          },
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'mute',
          label: category.muted
              ? l10n.sidebar_leftSidebar_category_menuUnmuteCategory
              : l10n.sidebar_leftSidebar_category_menuMuteCategory,
          icon: Icon(
            category.muted
                ? Icons.notifications_off
                : Icons.notifications_off_outlined,
            size: 18,
          ),
          onTap: () {
            context.read<ChannelBloc>().add(
              ToggleMuteCategoryEvent(
                categoryId: category.id,
                muted: !category.muted,
                userId: userId,
                teamId: teamId,
              ),
            );
          },
        ),
        MatterMenuItem.divider(),
        MatterMenuItem(
          id: 'sort',
          label: l10n.sidebarSort,
          icon: const Icon(Icons.sort, size: 18),
          submenu: sortSubmenu,
        ),
        // ==== إعادة التسمية/الحذف — للفئات المخصصة فقط (webapp: rename/delete) ====
        if (_isCustom) ...[
          MatterMenuItem.divider(),
          MatterMenuItem(
            id: 'rename',
            label: l10n.sidebar_leftSidebar_category_menuRenameCategory,
            icon: const Icon(Icons.drive_file_rename_outline, size: 18),
            onTap: () => _showRenameDialog(context),
          ),
          MatterMenuItem(
            id: 'delete',
            label: l10n.sidebar_leftSidebar_category_menuDeleteCategory,
            icon: const Icon(Icons.delete_outline, size: 18),
            danger: true,
            onTap: () => _confirmDelete(context),
          ),
        ],
        MatterMenuItem.divider(),

        MatterMenuItem(
          id: 'create',
          label: l10n.sidebar_leftSidebar_category_menuCreateCategory,
          icon: const Icon(Icons.create_new_folder_outlined, size: 18),
          onTap: () => _showCreateDialog(context),
        ),
      ],
    ];

    return MatterMenuScope(
      items: items,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.more_vert,
          size: 16,
          color: theme.sidebarText.withValues(alpha: 0.64),
        ),
      ),
    );
  }

  MatterMenuItem _sortItem(
    BuildContext context, {
    required String id,
    required String label,
    required CategorySorting sorting,
  }) {
    final checked = category.sorting == sorting;
    return MatterMenuItem(
      id: id,
      label: label,
      icon: Icon(
        checked ? Icons.check : Icons.radio_button_unchecked,
        size: 18,
        color: checked ? theme.linkColor : null,
      ),
      onTap: () {
        context.read<ChannelBloc>().add(
          SetCategorySortingEvent(
            categoryId: category.id,
            sorting: sorting,
            userId: userId,
            teamId: teamId,
          ),
        );
      },
    );
  }

  Future<void> _showCreateDialog(BuildContext context) async {
    // التقاط الـ Bloc قبل await حتى لا يُستخدم context قديم بعد انتظار النافذة.
    final channelBloc = context.read<ChannelBloc>();
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.create_category_modalCreateCategory),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.linkColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.create_category_modalCreate),
          ),
        ],
      ),
    );
    controller.dispose();
    final value = name?.trim() ?? '';
    if (!context.mounted) return;
    if (value.isNotEmpty) {
      channelBloc.add(
        CreateCategoryEvent(displayName: value, userId: userId, teamId: teamId),
      );
    }
  }

  Future<void> _showRenameDialog(BuildContext context) async {
    final channelBloc = context.read<ChannelBloc>();
    final controller = TextEditingController(text: category.displayName);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rename_category_modalRenameCategory),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: theme.linkColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text(l10n.rename_category_modalRename),
          ),
        ],
      ),
    );
    controller.dispose();
    final value = name?.trim() ?? '';
    if (!context.mounted) return;
    if (value.isNotEmpty && value != category.displayName) {
      channelBloc.add(
        RenameCategoryEvent(
          categoryId: category.id,
          newName: value,
          userId: userId,
          teamId: teamId,
        ),
      );
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final channelBloc = context.read<ChannelBloc>();
    final help = l10n
        .delete_category_modalHelpText(category.displayName)
        .replaceAll(RegExp(r'<[^>]+>'), '');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete_category_modalDeleteCategory),
        content: Text(help),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              l10n.delete_category_modalDelete,
              style: TextStyle(color: theme.errorTextColor),
            ),
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    if (confirmed == true) {
      channelBloc.add(
        DeleteCategoryEvent(
          categoryId: category.id,
          userId: userId,
          teamId: teamId,
        ),
      );
    }
  }
}
