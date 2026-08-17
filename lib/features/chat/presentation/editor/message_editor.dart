import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/rhs_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/storage/draft_storage_service.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/files_remote_data_source.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/post_entity.dart';
import 'package:flutter_mattermost/features/chat/presentation/bloc/post_bloc.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_controller.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_overlay.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_service.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/composer_controller.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/composer_draft.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/file_upload_controller.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/formatting_bar.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/attachment_preview.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/emoji_picker_overlay.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/file_upload_overlay.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/markdown_message.dart';
import 'package:flutter_mattermost/features/teams/presentation/bloc/team_bloc.dart';
import 'package:flutter_mattermost/features/system/domain/repositories/system_repository.dart';

/// المحرر المتقدم — يربط [ComposerController] بمكونات الواجهة:
/// شريط التنسيق، منتقي الإيموجي، رفع الملفات (مع سحب وإسقاط)،
/// الإكمال التلقائي (@/#/:emoji//commands)، ومعاينة markdown.
class MessageEditor extends StatefulWidget {
  final String? rootId;
  final ScrollController? scrollController;

  const MessageEditor({super.key, this.rootId, this.scrollController});

  /// آخر مُحرِّر نشط في الواجهة — تستخدمه قائمة المنشورات لبدء وضع التعديل.
  static ComposerController? activeComposer;

  @override
  State<MessageEditor> createState() => _MessageEditorState();
}

class _MessageEditorState extends State<MessageEditor> {
  ComposerController? _composer;
  AutocompleteController? _autocomplete;
  String _channelId = '';
  String _teamId = '';
  String _rootId = '';
  bool _alsoSendToChannel = false, previewMode = false;

  final GlobalKey _emojiButtonKey = GlobalKey();
  final GlobalKey _editorAnchorKey = GlobalKey();
  final GlobalKey _priorityButtonKey = GlobalKey();
  final GlobalKey _scheduleButtonKey = GlobalKey();
  final GlobalKey _burnButtonKey = GlobalKey();
  OverlayEntry? _autocompleteEntry;
  OverlayEntry? _emojiEntry;

  @override
  void initState() {
    super.initState();
    _ensureComposer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureComposer();
  }

  @override
  void dispose() {
    _removeOverlayEntries();
    _disposeComposer();
    super.dispose();
  }

  void _removeOverlayEntries() {
    _autocompleteEntry?.remove();
    _autocompleteEntry = null;
    _emojiEntry?.remove();
    _emojiEntry = null;
  }

  void _disposeComposer() {
    if (MessageEditor.activeComposer == _composer) {
      MessageEditor.activeComposer = null;
    }
    _autocomplete?.dispose();
    _autocomplete = null;
    _composer?.dispose();
    _composer = null;
  }

  String _currentChannelId() {
    final state = context.read<ChannelBloc>().state;
    return state is ChannelsLoadedState
        ? (state.selectedChannel?.id ?? '')
        : '';
  }

  String _currentTeamId() {
    final state = context.read<TeamBloc>().state;
    return state is TeamsLoadedState ? (state.selectedTeam?.id ?? '') : '';
  }

  void _ensureComposer() {
    final channelId = _currentChannelId();
    final teamId = _currentTeamId();
    final rootId = widget.rootId ?? '';

    if (_composer != null && (_channelId != channelId || _rootId != rootId)) {
      _disposeComposer();
    }

    if (_composer == null) {
      final draft = ComposerDraft(channelId: channelId, rootId: rootId);
      final uploadController = FileUploadController(
        draft: draft,
        filesDataSource: getIt<FilesRemoteDataSource>(),
        systemRepository: getIt<SystemRepository>(),
      );
      final composer = ComposerController(
        draft: draft,
        uploadController: uploadController,
        draftStorage: getIt<DraftStorageService>(),
      );
      composer.focusNode.onKeyEvent = (node, event) =>
          composer.handleKeyEvent(event)
          ? KeyEventResult.handled
          : KeyEventResult.ignored;
      composer.onSendMessage = _handleSend;
      composer.onTyping = _handleTyping;
      composer.setCurrentChannelId(channelId);
      composer.onScrollToBottom = () {
        final sc = widget.scrollController;
        if (sc != null && sc.hasClients) sc.jumpTo(0);
      };
      composer.onConfirmSpecialMentions = _confirmSpecialMentions;
      composer.addListener(_onComposerChanged);

      _composer = composer;
      MessageEditor.activeComposer = composer;
      _channelId = channelId;
      _rootId = rootId;
      _rebuildAutocomplete(teamId);
    } else if (_teamId != teamId) {
      _rebuildAutocomplete(teamId);
    }
  }

  void _rebuildAutocomplete(String teamId) {
    _teamId = teamId;
    _autocomplete?.dispose();
    final composer = _composer;
    if (teamId.isEmpty || composer == null) {
      _autocomplete = null;
      composer?.autocompleteController = null;
      return;
    }
    final controller = AutocompleteController(
      textController: composer.textController,
      service: AutocompleteService(teamId: teamId, channelId: _channelId),
    );
    controller.addListener(_onAutocompleteChanged);
    _autocomplete = controller;
    composer.autocompleteController = controller;
  }

  // ─────────────────────────── الربط مع PostBloc ───────────────────────────

  Future<void> _handleSend(
    String channelId,
    String message,
    String? rootId,
    List<String> fileIds, {
    Map<String, dynamic>? metadata,
    int? scheduledAt,
  }) async {
    final composer = _composer;
    if (composer == null || channelId.isEmpty) return;
    
    final completer = Completer<PostEntity>();

    if (composer.isEditMode) {
      context.read<PostBloc>().add(
        EditPostEvent(composer.editingPostId, message),
      );
      // For simplicity, we don't await edit yet as it doesn't support completer yet
      return;
    } else {
      if (rootId != null && rootId.isNotEmpty) {
        context.read<RhsBloc>().add(
          SendThreadPostEvent(
            channelId: channelId,
            rootPostId: rootId,
            message: message,
            fileIds: fileIds,
            metadata: metadata,
            completer: completer,
          ),
        );
      } else {
        context.read<PostBloc>().add(
          SendPostEvent(
            channelId: channelId,
            message: message,
            rootId: rootId,
            fileIds: fileIds,
            alsoSendToChannel: _alsoSendToChannel,
            metadata: metadata,
            scheduledAt: scheduledAt,
            completer: completer,
          ),
        );
      }
      
      try {
        await completer.future;
        if (_alsoSendToChannel) {
          setState(() => _alsoSendToChannel = false);
        }
      } catch (e) {
        // Rethrow so ComposerController can handle it
        rethrow;
      }
    }
  }

  void _handleTyping() {
    if (_channelId.isEmpty) return;
    final rootId = _rootId.isEmpty ? null : _rootId;
    context.read<PostBloc>().add(SendTypingEvent(_channelId, parentId: rootId));
  }

  Future<bool> _confirmSpecialMentions(
    SpecialMentions mentions,
    int memberCount,
  ) async {
    final l10n = AppLocalizations.of(context);
    final raw = mentions.here
        ? l10n.notify_hereQuestion(memberCount)
        : l10n.notifyAllQuestion(memberCount);
    final text = raw.replaceAll(RegExp(r'<[^>]+>'), '');
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.notify_allTitleConfirm),
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.postEditCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.notify_allConfirm),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  void _onComposerChanged() {
    final composer = _composer;
    if (composer == null) return;
    if (composer.emojiPickerOpen && _emojiEntry == null) {
      _showEmojiOverlay();
    } else if (!composer.emojiPickerOpen && _emojiEntry != null) {
      _removeEmojiOverlay();
    }
  }

  /// قائمة اختيار أولوية الرسالة — مطابق post_priority.tsx (urgent/important/none).
  void _showPriorityMenu(ComposerController composer) {
    final theme = AppTheme.of(context);
    final overlaySize = context.size ?? const Size(400, 600);
    final overlayTopLeft =
        (context.findRenderObject() as RenderBox?)?.localToGlobal(
          Offset.zero,
        ) ??
        Offset.zero;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          overlayTopLeft.dx + overlaySize.width - 160,
          overlayTopLeft.dy,
          160,
          overlaySize.height,
        ),
        Rect.fromLTWH(0, 0, 160, 600),
      ),
      items: [
        for (final option in const <(String, String)>[
          (ComposerController.priorityUrgent, 'عاجلة'),
          (ComposerController.priorityImportant, 'مهمة'),
          ('', 'بدون أولوية'),
        ])
          PopupMenuItem<String>(
            value: option.$1,
            child: Row(
              children: [
                Icon(
                  option.$1 == ComposerController.priorityUrgent
                      ? Icons.bolt
                      : option.$1 == ComposerController.priorityImportant
                      ? Icons.flag
                      : Icons.remove_circle_outline,
                  size: 18,
                  color: option.$1 == ComposerController.priorityUrgent
                      ? const Color(0xFFCC3232)
                      : option.$1 == ComposerController.priorityImportant
                      ? const Color(0xFFE3A319)
                      : theme.centerChannelColor.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 10),
                Text(option.$2),
              ],
            ),
          ),
      ],
    ).then((value) {
      if (value == null || !mounted) return;
      if (value.isEmpty) {
        composer.clearPriority();
      } else {
        composer.setPriority(value);
      }
    });
  }

  /// منتقي جدولة الإرسال (تاريخ + وقت) — مطابق scheduled_messages في webapp.
  Future<void> _pickSchedule(ComposerController composer) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null || !mounted) return;
    final scheduled = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    composer.setScheduledAt(scheduled.millisecondsSinceEpoch);
  }

  void _onAutocompleteChanged() {
    final autocomplete = _autocomplete;
    if (autocomplete == null) return;
    if (autocomplete.isOpen && _autocompleteEntry == null) {
      _showAutocompleteOverlay();
    } else if (!autocomplete.isOpen && _autocompleteEntry != null) {
      _removeAutocompleteOverlay();
    }
  }

  // ─────────────────────────── الأغلفة المنبثقة (OverlayEntry) ───────────────────────────

  void _removeAutocompleteOverlay() {
    _autocompleteEntry?.remove();
    _autocompleteEntry = null;
  }

  void _removeEmojiOverlay() {
    _emojiEntry?.remove();
    _emojiEntry = null;
  }

  /// نافذة [AutocompleteOverlay] المربعة فوق المحرر — تُفتح بجوار المحرر.
  void _showAutocompleteOverlay() {
    final autocomplete = _autocomplete;
    if (autocomplete == null) return;

    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final anchorBox =
        _editorAnchorKey.currentContext?.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize) return;

    const overlaySize = 260.0;
    final anchorPos = anchorBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );

    var dx = anchorPos.dx + 8;
    if (dx + overlaySize > overlayBox.size.width - 8) {
      dx = overlayBox.size.width - overlaySize - 8;
    }
    var dy = anchorPos.dy - overlaySize - 8;
    if (dy < 8) {
      dy = anchorPos.dy + anchorBox.size.height + 8;
    }

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned(
            left: dx,
            top: dy,
            width: overlaySize,
            height: overlaySize,
            child: AutocompleteOverlay(
              controller: autocomplete,
              size: overlaySize,
            ),
          ),
        ],
      ),
    );
    _autocompleteEntry = entry;
    overlay.insert(entry);
  }

  /// نافذة [EmojiPickerOverlay] بجانب زر الإيموجي.
  void _showEmojiOverlay() {
    final composer = _composer;
    if (composer == null) return;

    final overlay = Overlay.of(context);
    final overlayBox = overlay.context.findRenderObject()! as RenderBox;
    final anchorBox =
        _emojiButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (anchorBox == null || !anchorBox.hasSize) return;

    final screenSize = MediaQuery.sizeOf(context);
    final cardWidth = math.min(360.0, screenSize.width - 32);
    final cardHeight = math.min(430.0, screenSize.height - 140);
    final anchorPos = anchorBox.localToGlobal(
      Offset.zero,
      ancestor: overlayBox,
    );

    var dx = anchorPos.dx + anchorBox.size.width - cardWidth;
    if (dx < 8) dx = 8;
    if (dx + cardWidth > overlayBox.size.width - 8) {
      dx = overlayBox.size.width - cardWidth - 8;
    }
    var dy = anchorPos.dy - cardHeight - 10;
    if (dy < 8) dy = anchorPos.dy + anchorBox.size.height + 10;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned(
            left: dx,
            top: dy,
            child: EmojiPickerOverlay(
              width: cardWidth,
              height: cardHeight,
              onEmojiSelected: composer.insertEmoji,
              onClose: composer.closeEmojiPicker,
            ),
          ),
        ],
      ),
    );
    _emojiEntry = entry;
    overlay.insert(entry);
  }

  // ─────────────────────────────── الواجهة ───────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    final composer = _composer!;
    final upload = composer.uploadController;
    final controller = composer.textController;

    final channelState = context.read<ChannelBloc>().state;
    final channelName = channelState is ChannelsLoadedState
        ? channelState.selectedChannel?.displayName
        : null;

    final selection = controller.selection;
    final selectionStart = selection.isValid ? selection.baseOffset : 0;
    final selectionEnd = selection.isValid ? selection.extentOffset : 0;

    final serverError = composer.serverError;
    final uploadError = upload.lastError;
    final errorText = serverError.isNotEmpty ? serverError : uploadError;

    final listenable = Listenable.merge([
      composer,
      upload,
      controller,
      composer.draft,
    ]);

    final editor = ListenableBuilder(
      listenable: listenable,
      builder: (context, _) => Container(
        key: _editorAnchorKey,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        color: theme.centerChannelBg,
        child: Column(
          mainAxisSize: MainAxisSize.min,

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (composer.isEditMode) _EditBanner(composer: composer),
            if (errorText.isNotEmpty) _ErrorStrip(text: errorText),
            if (_rootId.isNotEmpty)
              _AlsoSendToChannelCheckbox(
                value: _alsoSendToChannel,
                onChanged: (val) =>
                    setState(() => _alsoSendToChannel = val ?? false),
              ),
            Container(
              decoration: BoxDecoration(
                color: theme.centerChannelBg,
                border: Border.all(
                  color: theme.centerChannelColor.withValues(alpha: 0.20),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: composer.showPreview
                        ? _PreviewPane(composer: composer)
                        : TextField(
                            controller: controller,
                            focusNode: composer.focusNode,
                            onChanged: (value) {
                              composer.onComposerTextChanged();
                              composer.clearServerError();
                              upload.clearError();
                            },
                            minLines: 1,
                            maxLines: 8,
                            onSubmitted: (_) => composer.send(),
                            onEditingComplete: composer.send,

                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                              color: theme.centerChannelColor,
                              fontSize: 14,
                            ),
                            decoration: InputDecoration(
                              hintText: channelName != null
                                  ? l10n.create_postWrite(channelName)
                                  : l10n.editorPlaceholder,
                              hintStyle: TextStyle(
                                color: theme.centerChannelColor.withValues(
                                  alpha: 0.45,
                                ),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              filled: false,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                            ),
                          ),
                  ),

                  AttachmentPreview(
                    draft: composer.draft,
                    onRemove: upload.removeFile,
                  ),
                  _AdvancedOptionsBar(
                    composer: composer,
                    onSchedule: () => _pickSchedule(composer),
                  ),
                  FormattingBar(
                    onFormat: composer.applyMarkdown,
                    showPreview: composer.showPreview,
                    onTogglePreview: composer.togglePreview,
                    message: controller.text,
                    selectionStart: selectionStart,
                    selectionEnd: selectionEnd,
                    onPickFile: upload.canAddMore ? upload.pickFiles : null,
                    composer: composer,
                    emojiButtonKey: _emojiButtonKey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return FileUploadDropArea(controller: upload, child: editor);
  }

  Row buildTextField(
    TextEditingController controller,
    ComposerController composer,
    FileUploadController upload,
    MattermostColors theme,
    String? channelName,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        Expanded(child: Container()),
        //   Tooltip(
        //   message: 'Preview Mode',
        //   child: Material(
        //     color: Colors.transparent,
        //     child: InkWell(
        //       onTap: () { },
        //       borderRadius: BorderRadius.circular(4),
        //       child: Container(
        //         width: 30,
        //         height: 30,
        //         padding: .all(4),
        //         alignment: Alignment.center,
        //         decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(4),
        //           color: previewMode && controller.text.isNotEmpty
        //               ? theme.centerChannelColor.withValues(alpha: 0.08)
        //               : Colors.transparent,
        //         ),
        //         child: Icon(
        //           Icons.visibility_outlined,
        //           size: 17,
        //           color: previewMode && controller.text.isNotEmpty
        //               ? theme.linkColor
        //               : theme.centerChannelColor.withValues(alpha: 0.65),
        //         ),
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}

/// شريط الخيارات المتقدمة: أولوية الرسالة + الجدولة + الإحراق بعد القراءة.
/// مطابق post_priority.tsx + scheduled_messages في webapp.
class _AdvancedOptionsBar extends StatelessWidget {
  final ComposerController composer;
  final VoidCallback onSchedule;

  const _AdvancedOptionsBar({required this.composer, required this.onSchedule});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final priority = composer.priority;
    final scheduledAt = composer.scheduledAt;
    final burnOnRead = composer.burnOnRead;
    if (priority.isEmpty && scheduledAt == null && !burnOnRead) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 2),
      child: Wrap(
        spacing: 6,
        runSpacing: 4,
        children: [
          if (priority.isNotEmpty)
            _OptionChip(
              icon: priority == ComposerController.priorityUrgent
                  ? Icons.bolt
                  : Icons.flag,
              label: priority == ComposerController.priorityUrgent
                  ? 'أولوية عاجلة'
                  : 'أولوية مهمة',
              color: priority == ComposerController.priorityUrgent
                  ? const Color(0xFFCC3232)
                  : const Color(0xFFE3A319),
              onTap: composer.clearPriority,
            ),
          if (scheduledAt != null)
            _OptionChip(
              icon: Icons.schedule,
              label: DateFormat(
                'MMM d, HH:mm',
              ).format(DateTime.fromMillisecondsSinceEpoch(scheduledAt)),
              color: theme.linkColor,
              onTap: () => composer.setScheduledAt(null),
            ),
          if (burnOnRead)
            _OptionChip(
              icon: Icons.local_fire_department,
              label: 'إحراق بعد القراءة',
              color: const Color(0xFFCC3232),
              onTap: () => composer.setBurnOnRead(false),
            ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _OptionChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.centerChannelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// شريط وضع التعديل: "جارٍ تعديل الرسالة" + زر إلغاء.
class _EditBanner extends StatelessWidget {
  final ComposerController composer;
  const _EditBanner({required this.composer});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.linkColor.withValues(alpha: 0.06),
        border: Border.all(color: theme.linkColor.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(Icons.edit_outlined, size: 14, color: theme.linkColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.editorEditingPost,
              style: TextStyle(
                fontSize: 12.5,
                color: theme.centerChannelColor.withValues(alpha: 0.8),
              ),
            ),
          ),
          InkWell(
            onTap: composer.cancelEdit,
            borderRadius: BorderRadius.circular(4),
            child: Icon(
              Icons.close,
              size: 16,
              color: theme.centerChannelColor.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// شريط الخطأ لأعلى المحرر (فشل الرفع/الإرسال).
class _ErrorStrip extends StatelessWidget {
  final String text;
  const _ErrorStrip({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.errorTextColor.withValues(alpha: 0.06),
        border: Border.all(color: theme.errorTextColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 12.5, color: theme.errorTextColor),
      ),
    );
  }
}

/// معاينة markdown الحية للرسالة (زر Preview في شريط التنسيق).
class _PreviewPane extends StatelessWidget {
  final ComposerController composer;
  const _PreviewPane({required this.composer});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Container(
      constraints: const BoxConstraints(maxHeight: 180),
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: theme.centerChannelColor.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(6),
      ),
      child: SingleChildScrollView(
        child: MarkdownMessage(
          text: composer.draft.message,
          style: TextStyle(color: theme.centerChannelColor, fontSize: 14),
        ),
      ),
    );
  }
}

class _AlsoSendToChannelCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _AlsoSendToChannelCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    const label = 'Also send to channel';

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: theme.linkColor,
              side: BorderSide(
                color: theme.centerChannelColor.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => onChanged(!value),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: theme.centerChannelColor.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
