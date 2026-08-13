import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';
import 'package:flutter_mattermost/core/storage/draft_storage_service.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/features/channels/presentation/bloc/channel_bloc.dart';
import 'package:flutter_mattermost/features/chat/data/datasources/files_remote_data_source.dart';
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
  bool _alsoSendToChannel = false;

  final LayerLink _autocompleteLink = LayerLink();
  final OverlayPortalController _autocompletePortal = OverlayPortalController();
  final LayerLink _emojiLink = LayerLink();
  final OverlayPortalController _emojiPortal = OverlayPortalController();

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
    _disposeComposer();
    super.dispose();
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
    List<String> fileIds,
  ) async {
    final composer = _composer;
    if (composer == null || channelId.isEmpty) return;
    if (composer.isEditMode) {
      context.read<PostBloc>().add(
        EditPostEvent(composer.editingPostId, message),
      );
    } else {
      context.read<PostBloc>().add(
        SendPostEvent(
          channelId: channelId,
          message: message,
          rootId: rootId,
          fileIds: fileIds,
          alsoSendToChannel: _alsoSendToChannel,
        ),
      );
      if (_alsoSendToChannel) {
        setState(() => _alsoSendToChannel = false);
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
    if (composer.emojiPickerOpen && !_emojiPortal.isShowing) {
      _emojiPortal.show();
    } else if (!composer.emojiPickerOpen && _emojiPortal.isShowing) {
      _emojiPortal.hide();
    }
  }

  void _onAutocompleteChanged() {
    final autocomplete = _autocomplete;
    if (autocomplete == null) return;
    if (autocomplete.isOpen && !_autocompletePortal.isShowing) {
      _autocompletePortal.show();
    } else if (!autocomplete.isOpen && _autocompletePortal.isShowing) {
      _autocompletePortal.hide();
    }
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
                onChanged: (val) => setState(() => _alsoSendToChannel = val ?? false),
              ),
            AttachmentPreview(
              draft: composer.draft,
              onRemove: upload.removeFile,
            ),
            FormattingBar(
              onFormat: composer.applyMarkdown,
              showPreview: composer.showPreview,
              onTogglePreview: composer.togglePreview,
              message: controller.text,
              selectionStart: selectionStart,
              selectionEnd: selectionEnd,
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.centerChannelBg,
                border: Border.all(
                  color: theme.centerChannelColor.withValues(alpha: 0.18),
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 22,
                      color: upload.canAddMore
                          ? theme.centerChannelColor.withValues(alpha: 0.6)
                          : theme.centerChannelColor.withValues(alpha: 0.25),
                    ),
                    tooltip: l10n.editorAddAttachment,
                    onPressed: upload.canAddMore ? upload.pickFiles : null,
                  ),
                  OverlayPortal(
                    controller: _emojiPortal,
                    overlayChildBuilder: (_) => CompositedTransformFollower(
                      link: _emojiLink,
                      showWhenUnlinked: false,
                      targetAnchor: Alignment.topRight,
                      followerAnchor: Alignment.bottomRight,
                      offset: const Offset(0, -8),
                      child: EmojiPickerOverlay(
                        onEmojiSelected: composer.insertEmoji,
                        onClose: composer.closeEmojiPicker,
                      ),
                    ),
                    child: CompositedTransformTarget(
                      link: _emojiLink,
                      child: IconButton(
                        icon: Icon(
                          Icons.emoji_emotions_outlined,
                          size: 22,
                          color: theme.centerChannelColor.withValues(
                            alpha: 0.6,
                          ),
                        ),
                        tooltip: l10n.editorAddEmoji,
                        onPressed: composer.toggleEmojiPicker,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.flash_on_outlined,
                      size: 22,
                      color: theme.centerChannelColor.withValues(alpha: 0.6),
                    ),
                    tooltip: l10n.editorSlashCommands,
                    onPressed: composer.openSlashCommands,
                  ),
                  Expanded(
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
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 8,
                              ),
                            ),
                          ),
                  ),
                  TextButton(
                    onPressed: () {
                      final teamId = _teamId;
                      if (teamId.isNotEmpty) {
                        context.go('/$teamId/drafts');
                      }
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      l10n.editorDrafts,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.centerChannelColor.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 22,
                      color: composer.canSend
                          ? theme.buttonBg
                          : theme.buttonBg.withValues(alpha: 0.3),
                    ),
                    tooltip: l10n.editorSend,
                    onPressed: composer.canSend ? () => composer.send() : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return FileUploadDropArea(
      controller: upload,
      child: OverlayPortal(
        controller: _autocompletePortal,
        overlayChildBuilder: (_) {
          final autocomplete = _autocomplete;
          if (autocomplete == null) return const SizedBox.shrink();
          return CompositedTransformFollower(
            link: _autocompleteLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.bottomLeft,
            offset: const Offset(8, -8),
            child: AutocompleteOverlay(controller: autocomplete, height: 320),
          );
        },
        child: CompositedTransformTarget(
          link: _autocompleteLink,
          child: editor,
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

  const _AlsoSendToChannelCheckbox({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final l10n = AppLocalizations.of(context);

    // TODO: Use l10n.post_commentCheckbox_also_send_to_channel once regenerated
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
