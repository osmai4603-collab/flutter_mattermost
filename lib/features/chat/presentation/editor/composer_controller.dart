import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mattermost/core/utils/markdown_apply.dart' as md;
import 'package:flutter_mattermost/core/utils/mention_utils.dart';
import 'package:flutter_mattermost/core/utils/post_key_press.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/autocomplete/autocomplete_controller.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/composer_draft.dart';
import 'package:flutter_mattermost/features/chat/presentation/editor/file_upload_controller.dart';

/// حد أعضاء القناة الذي يفعّل نافذة تأكيد @all/@channel/@here.
const int kNotifyAllMembers = 5;

/// استخراج حالة من أمر slash — نظير getStatusFromSlashCommand في use_submit.tsx.
String statusFromSlashCommand(String message) {
  final tokens = message.split(' ');
  final command = tokens.isEmpty ? '' : tokens.first;
  if (!command.startsWith('/')) return '';
  final status = command.substring(1);
  if (status == 'online' ||
      status == 'away' ||
      status == 'dnd' ||
      status == 'offline') {
    return status;
  }
  return '';
}

/// متحكم المحرر — دمج منطق use_submit + use_key_handler + use_editor_emoji_picker
/// من webapp مع إدارة سجل الرسائل وإشارات الكتابة.
class ComposerController extends ChangeNotifier {
  final ComposerDraft draft;
  final FileUploadController uploadController;

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  // إعدادات (تُقرأ من تفضيلات المستخدم/إعدادات الخادم).
  // Enter يدرج سطراً جديداً دائماً (مثل Discord) والإرسال يكون
  // عبر Ctrl+Enter أو زر الإرسال — نظير send_message_on_ctrl_enter.
  bool sendOnCtrlEnter = true;
  bool codeBlockOnCtrlEnter = true;
  bool userIsOutOfOffice = false;
  bool useChannelMentions = true;
  bool enableConfirmNotificationsToChannel = true;
  int channelMembersCount = 1;

  // callbacks يربطها الويدجت.
  Future<void> Function(
    String channelId,
    String message,
    String? rootId,
    List<String> fileIds,
  )?
  onSendMessage;
  void Function()? onScrollToBottom;
  void Function()? onRequestFocus;
  void Function(String command)? onHeaderCommand;
  void Function()? onPurposeCommand;
  void Function(String status)? onStatusCommand;
  void Function()? onEditLatestPost;
  void Function()? onReplyToLastPost;
  Future<bool> Function(SpecialMentions mentions, int memberCount)?
  onConfirmSpecialMentions;
  void Function(Object error)? onError;
  void Function(String channelId, String command)? onExecuteCommand;

  /// متحكم الإكمال التلقائي — يُربَط من الويدجت بعد إنشاء المحرر.
  AutocompleteController? autocompleteController;

  // حالة التحرير (تعديل منشور موجود).
  bool _isEditMode = false;
  String _editingPostId = '';

  bool _isSubmitting = false;
  String _serverError = '';
  bool _showPreview = false;
  bool _emojiPickerOpen = false;

  final List<String> _messageHistory = [];
  int _historyIndex = 0;

  int _lastChannelSwitchAt = 0;
  Timer? _typingTimer;

  ComposerController({required this.draft, required this.uploadController}) {
    textController.addListener(_onTextControllerChanged);
    focusNode.addListener(_onFocusChanged);
  }

  // ─────────────────────────── حالة عامة ───────────────────────────

  bool get isSubmitting => _isSubmitting;
  bool get isEditMode => _isEditMode;
  String get editingPostId => _editingPostId;
  String get serverError => _serverError;
  bool get showPreview => _showPreview;
  bool get emojiPickerOpen => _emojiPickerOpen;

  void clearServerError() {
    if (_serverError.isEmpty) return;
    _serverError = '';
    notifyListeners();
  }

  /// دخول وضع التعديل لمنشور موجود.
  void beginEdit(String postId, String message) {
    _isEditMode = true;
    _editingPostId = postId;
    _serverError = '';
    textController.value = TextEditingValue(
      text: message,
      selection: TextSelection.collapsed(offset: message.length),
    );
    _lastText = message;
    notifyListeners();
  }

  void cancelEdit() {
    if (!_isEditMode) return;
    _isEditMode = false;
    _editingPostId = '';
    textController.clear();
    notifyListeners();
  }

  /// يُستدعى عند تبديل القناة: يمنع Enter الخاطئ ويركز المحرر.
  void onChannelChanged() {
    _lastChannelSwitchAt = DateTime.now().millisecondsSinceEpoch;
    _historyIndex = _messageHistory.length;
    clearServerError();
    onRequestFocus?.call();
  }

  void togglePreview() {
    _showPreview = !_showPreview;
    notifyListeners();
  }

  void toggleEmojiPicker() {
    _emojiPickerOpen = !_emojiPickerOpen;
    notifyListeners();
  }

  void closeEmojiPicker() {
    if (!_emojiPickerOpen) return;
    _emojiPickerOpen = false;
    notifyListeners();
  }

  // ──────────────────────── سجل الرسائل ────────────────────────

  void _pushHistory(String message) {
    if (message.trim().isEmpty) return;
    _messageHistory.remove(message);
    _messageHistory.insert(0, message);
    if (_messageHistory.length > 100) {
      _messageHistory.removeRange(100, _messageHistory.length);
    }
    _historyIndex = 0;
  }

  bool get _allowHistoryNavigation =>
      textController.text.isEmpty ||
      (_historyIndex < _messageHistory.length &&
          textController.text == _messageHistory[_historyIndex]);

  void historyPrev() {
    if (_historyIndex >= _messageHistory.length - 1) return;
    _historyIndex++;
    _applyHistoryMessage();
  }

  void historyNext() {
    if (_historyIndex == 0) return;
    _historyIndex--;
    _applyHistoryMessage();
  }

  void _applyHistoryMessage() {
    final value = _historyIndex < _messageHistory.length
        ? _messageHistory[_historyIndex]
        : '';
    textController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    draft.setMessage(value);
  }

  // ──────────────────────── إدخال الإيموجي ────────────────────────

  /// إدراج إيموجي عند المؤشر مع مسافة قبل أو بعد إن لزم.
  /// يحافظ على لوحة الإيموجي مفتوحة لعدة تحديدات.
  void insertEmoji(String emoji) {
    final selection = textController.selection;
    final start = selection.isValid && selection.start >= 0
        ? selection.start
        : textController.text.length;
    final end = selection.isValid && selection.end > start
        ? selection.end
        : start;

    final text = textController.text;
    final needsSpaceBefore =
        start != 0 && !RegExp(r'\s').hasMatch(text[start - 1]);
    final needsSpaceAfter =
        end < text.length && !RegExp(r'\s').hasMatch(text[end]);

    final textToBeAdded = '${needsSpaceBefore ? ' ' : ''}$emoji${needsSpaceAfter ? ' ' : ''}';
    final newText = text.replaceRange(start, end, textToBeAdded);

    textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + textToBeAdded.length),
    );
    draft.setMessage(newText);
    _lastText = newText;
    onTypingDebounced();
  }

  /// إدراج نص خام عند المؤشر (لـ GIF/روابط).
  void insertTextAtCaret(String text) {
    final selection = textController.selection;
    final start = selection.isValid ? selection.start : textController.text.length;
    final newText = textController.text.replaceRange(start, start, text);
    textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: start + text.length),
    );
    draft.setMessage(newText);
    _lastText = newText;
  }

  // ──────────────────────── تنسيق markdown ────────────────────────

  void applyMarkdown(md.MarkdownMode mode) {
    final selection = textController.selection;
    if (!selection.isValid) return;
    final result = md.applyMarkdown(
      mode: mode,
      selectionStart: selection.start,
      selectionEnd: selection.end,
      message: textController.text,
    );
    textController.value = TextEditingValue(
      text: result.message,
      selection: TextSelection(
        baseOffset: result.selectionStart,
        extentOffset: result.selectionEnd,
      ),
    );
    draft.setMessage(result.message);
    _lastText = result.message;
  }

  // ──────────────────────── إشارات الكتابة ────────────────────────

  void onTypingDebounced() {
    _typingTimer?.cancel();
    // لا تُرسل إشارة كتابة إن أفرغ المستخدم المحرر — نظير webapp
    // الذي يتوقف عن الإرسال عندما يصبح الإدخال فارغاً.
    if (draft.message.trim().isEmpty) return;
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (draft.message.trim().isEmpty) return;
      onTyping?.call();
    });
  }

  /// يُستدعى بعد ثانيتين من التوقف عن الكتابة (يرسله الويدجت عبر PostBloc).
  void Function()? onTyping;

  // ──────────────────────── Markdown الحية (live_typing) ────────────────────────

  /// نص المحرر قبل آخر تغيير — لتحديد الرمز المضاف للتو.
  String _lastText = '';

  /// يمنع إعادة الدخول أثناء إدراج القفل الإغلاقي تلقائياً.
  bool _liveTypingInserting = false;

  /// يُستدعى من `onChanged` في المحرر: تفعيل إشارة الكتابة + الإغلاق التلقائي.
  void onComposerTextChanged() {
    onTypingDebounced();
    _autoCloseDelimiter();
  }

  /// إغلاق تلقائي للفواصل markdown — نظير MarkdownLiveTyping في webapp.
  ///
  /// - فقط عندما يكون المؤشر في نهاية النص ويكون المستخدم قد
  ///   كتب للتو فاصل افتتاح (`**`, `~~`, أو `` ` ``).
  /// - يُدرج الفاصل الإغلاقي ويبقى المؤشر في المنتصف.
  /// - لا يتداخل مع كتل البرمجة، ولا مع تسلسل `***`/`` ``` ``.
  void _autoCloseDelimiter() {
    if (_liveTypingInserting) return;

    final text = textController.text;
    final prior = _lastText;
    _lastText = text;

    if (text.isEmpty) return;
    final caret = textController.selection.baseOffset;
    final collapsed = textController.selection.isCollapsed;
    if (textController.selection.isValid &&
        (!collapsed || caret != text.length)) {
      return;
    }

    // داخل كتل البرمجة لا نغلق تلقائياً.
    if (isWithinCodeBlock(text, caret)) return;

    // تسلسل من 3 رموز متطابقة فأكثر (`***`, ```` ``` ````): لا تُغلق.
    final trailingChar = text[text.length - 1];
    var runLength = 1;
    for (var i = text.length - 2; i >= 0 && text[i] == trailingChar; i--) {
      runLength++;
    }
    if (runLength >= 3) return;

    const pairs = [('**', '**'), ('~~', '~~'), ('`', '`')];
    for (final pair in pairs) {
      final open = pair.$1;
      final closing = pair.$2;
      if (!text.endsWith(open)) continue;
      if (prior.endsWith(open)) continue;

      final lineStart = text.lastIndexOf('\n') + 1;
      final line = text.substring(lineStart);
      final count = _countDelimiter(line, open);
      if (count % 2 == 1) {
        _insertClosingDelimiter(caret, closing);
        return;
      }
    }
  }

  /// عدد تكرارات غير متداخلة للفاصل داخل النص.
  int _countDelimiter(String text, String delimiter) {
    if (delimiter.isEmpty || text.isEmpty) return 0;
    var count = 0;
    var index = text.indexOf(delimiter);
    while (index != -1) {
      count++;
      index = text.indexOf(delimiter, index + delimiter.length);
    }
    return count;
  }

  /// يُدرج الفاصل الإغلاقي بعد المؤشر ويُبقي المؤشر في مكانه
  /// (داخل الفتح والإغلاق) — مثل إكمال الأقواس في المحررات.
  void _insertClosingDelimiter(int caret, String closing) {
    _liveTypingInserting = true;
    final text = textController.text;
    final newText = text.replaceRange(caret, caret, closing);
    textController.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: caret),
    );
    draft.setMessage(newText);
    _lastText = newText;
    _liveTypingInserting = false;
  }

  // ──────────────────────── الإرسال (use_submit) ────────────────────────

  bool get canSend =>
      !draft.isEmpty &&
      !draft.hasUploadsInProgress &&
      !_isSubmitting &&
      !_showPreview;

  /// مسار الإرسال الكامل — نظير handleSubmit + doSubmit في use_submit.tsx.
  Future<void> send({bool ignoreServerError = false}) async {
    if (_isSubmitting) return;
    if (draft.hasUploadsInProgress) return;
    if (draft.isEmpty) return;
    if (!ignoreServerError &&
        _serverError.isNotEmpty &&
        !isInvalidSlashCommandError(_serverError)) {
      return;
    }

    _isSubmitting = true;
    focusNode.requestFocus();
    try {
      // أوامر slash الخاصة تُعالج محلياً قبل الإرسال.
      if (!_isEditMode) {
        final trimmed = draft.message.trimRight();
        final status = statusFromSlashCommand(draft.message);
        if (userIsOutOfOffice && status.isNotEmpty) {
          onStatusCommand?.call(status);
          draft.setMessage('');
          textController.clear();
          return;
        }
        if (trimmed == '/header') {
          onHeaderCommand?.call('');
          draft.setMessage('');
          textController.clear();
          return;
        }
        if (trimmed == '/purpose') {
          onPurposeCommand?.call();
          draft.setMessage('');
          textController.clear();
          return;
        }
      }

      // تأكيد إشعارات @all/@channel/@here عند الحاجة.
      if (!_isEditMode && enableConfirmNotificationsToChannel) {
        final mentions = specialMentionsInText(draft.message);
        var memberNotifyCount = 0;
        if (useChannelMentions &&
            channelMembersCount > kNotifyAllMembers &&
            mentions.hasAny) {
          memberNotifyCount = channelMembersCount - 1;
        }
        if (memberNotifyCount > 0) {
          final proceed =
              await onConfirmSpecialMentions?.call(mentions, memberNotifyCount) ??
              true;
          if (!proceed) {
            return;
          }
        }
      }

      final message = draft.message;
      final fileIds = draft.fileIds;

      await onSendMessage?.call(
        draft.channelId,
        message,
        _isEditMode ? null : draft.rootId,
        fileIds,
      );

      // نجاح: تنظيف المسودة + حفظ في سجل الرسائل + التمرير للأسفل.
      _serverError = '';
      if (!_isEditMode) {
        _pushHistory(message);
        if (draft.rootId.isEmpty) {
          onScrollToBottom?.call();
        }
      }
      _showPreview = false;
      draft.clear();
      textController.clear();
      if (_isEditMode) {
        cancelEdit();
      }
      notifyListeners();
    } catch (err) {
      _serverError = err.toString();
      onError?.call(err);
      notifyListeners();
    } finally {
      _isSubmitting = false;
    }
  }

  // ──────────────────────── لوحة المفاتيح (use_key_handler) ────────────────────────

  static bool get _isMobile =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  bool _isKeyPressed(LogicalKeyboardKey key) =>
      HardwareKeyboard.instance.logicalKeysPressed.contains(key);

  bool get _ctrlOrMeta =>
      _isKeyPressed(LogicalKeyboardKey.controlLeft) ||
      _isKeyPressed(LogicalKeyboardKey.controlRight) ||
      _isKeyPressed(LogicalKeyboardKey.metaLeft) ||
      _isKeyPressed(LogicalKeyboardKey.metaRight);

  bool get _shift =>
      _isKeyPressed(LogicalKeyboardKey.shiftLeft) ||
      _isKeyPressed(LogicalKeyboardKey.shiftRight);

  bool get _alt =>
      _isKeyPressed(LogicalKeyboardKey.altLeft) ||
      _isKeyPressed(LogicalKeyboardKey.altRight);

  bool get _caretWithinCodeBlock {
    final caret = textController.selection.isValid
        ? textController.selection.baseOffset
        : textController.text.length;
    return isWithinCodeBlock(textController.text, caret);
  }

  /// معالجة ضغطات المفاتيح — نظير handleKeyDown + postMsgKeyPress في
  /// use_key_handler.tsx. ترجع true إذا عولج الحدث.
  bool handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return false;

    // الإكمال التلقائي يسبق بقية المعالجات: ↑↓/Enter/Escape.
    final autocomplete = autocompleteController;
    if (autocomplete != null && autocomplete.isOpen) {
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        autocomplete.selectNext();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        autocomplete.selectPrevious();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        autocomplete.insertCurrent();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        autocomplete.close();
        return true;
      }
    }

    if (event.logicalKey == LogicalKeyboardKey.enter) {
      return _handleEnter(event);
    }

    final ctrlKeyCombo = _ctrlOrMeta && !_alt && !_shift;
    final ctrlAltCombo = _ctrlOrMeta && _alt;
    final shiftAltCombo = !_ctrlOrMeta && _shift && _alt;
    final ctrlShiftCombo = _ctrlOrMeta && _shift;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      if (_emojiPickerOpen) {
        closeEmojiPicker();
        return true;
      }
      focusNode.unfocus();
      return true;
    }

    final upKeyOnly =
        !_ctrlOrMeta &&
        !_alt &&
        !_shift &&
        event.logicalKey == LogicalKeyboardKey.arrowUp;
    if (upKeyOnly && textController.text.isEmpty) {
      onEditLatestPost?.call();
      return true;
    }

    if (!_isEditMode && _shift && !_ctrlOrMeta && !_alt) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
          textController.text.isEmpty) {
        onReplyToLastPost?.call();
        return true;
      }
    }

    if (_ctrlOrMeta && event.logicalKey == LogicalKeyboardKey.keyV) {
      // لصق صورة من الحافظة (إن وُجدت) دون إيقاف لصق النص الافتراضي.
      uploadController.handlePaste();
    }

    if (ctrlKeyCombo && !_caretWithinCodeBlock) {
      if (_allowHistoryNavigation) {
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          historyPrev();
          return true;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          historyNext();
          return true;
        }
      }
      if (event.logicalKey == LogicalKeyboardKey.keyB) {
        applyMarkdown(md.MarkdownMode.bold);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyI) {
        applyMarkdown(md.MarkdownMode.italic);
        return true;
      }
      if (_hasSelection && event.logicalKey == LogicalKeyboardKey.keyK) {
        applyMarkdown(md.MarkdownMode.link);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyU) {
        uploadController.pickFiles();
        return true;
      }
    } else if (ctrlAltCombo && !_caretWithinCodeBlock) {
      if (event.logicalKey == LogicalKeyboardKey.keyK) {
        applyMarkdown(md.MarkdownMode.link);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyC) {
        applyMarkdown(md.MarkdownMode.code);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyE) {
        toggleEmojiPicker();
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyP &&
          textController.text.isNotEmpty) {
        togglePreview();
        return true;
      }
    } else if (shiftAltCombo && !_caretWithinCodeBlock) {
      if (event.logicalKey == LogicalKeyboardKey.keyX) {
        applyMarkdown(md.MarkdownMode.strike);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit7) {
        applyMarkdown(md.MarkdownMode.ol);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit8) {
        applyMarkdown(md.MarkdownMode.ul);
        return true;
      }
      if (event.logicalKey == LogicalKeyboardKey.digit9) {
        applyMarkdown(md.MarkdownMode.quote);
        return true;
      }
    } else if (ctrlShiftCombo) {
      if (event.logicalKey == LogicalKeyboardKey.keyE) {
        toggleEmojiPicker();
        return true;
      }
    }

    return false;
  }

  bool get _hasSelection =>
      textController.selection.isValid &&
      textController.selection.start != textController.selection.end;

  bool _handleEnter(KeyDownEvent event) {
    final now = DateTime.now().millisecondsSinceEpoch;
    final caret = textController.selection.isValid
        ? textController.selection.baseOffset
        : textController.text.length;

    final result = postMessageOnKeyPress(
      isEnterKey: true,
      shiftKey: _shift,
      altKey: _alt,
      ctrlKey: _isKeyPressed(LogicalKeyboardKey.controlLeft) ||
          _isKeyPressed(LogicalKeyboardKey.controlRight),
      metaKey: _isKeyPressed(LogicalKeyboardKey.metaLeft) ||
          _isKeyPressed(LogicalKeyboardKey.metaRight),
      message: textController.text,
      sendMessageOnCtrlEnter: sendOnCtrlEnter,
      sendCodeBlockOnCtrlEnter: codeBlockOnCtrlEnter,
      now: now,
      lastChannelSwitchAt: _lastChannelSwitchAt,
      caretPosition: caret,
      isMobile: _isMobile,
    );

    if (result.ignoreKeyPress) return true;
    if (!result.allowSending) return false;

    if (result.withClosedCodeBlock && result.message != null) {
      textController.value = TextEditingValue(
        text: result.message!,
        selection: TextSelection.collapsed(offset: result.message!.length),
      );
      draft.setMessage(result.message!);
      _lastText = result.message!;
    }
    send();
    return true;
  }

  // ──────────────────────── الاستماعات الداخلية ────────────────────────

  void _onTextControllerChanged() {
    final text = textController.text;
    if (draft.message != text) {
      draft.setMessage(text);
    }
    if (text.isEmpty) {
      _historyIndex = _messageHistory.length;
    }
  }

  void _onFocusChanged() {
    if (!focusNode.hasFocus) {
      _typingTimer?.cancel();
    }
  }

  /// هل يجب ترك الإرسال بعد إغلاق مؤقت بسبب فقدان التركيز؟
  @override
  void dispose() {
    _typingTimer?.cancel();
    textController.removeListener(_onTextControllerChanged);
    focusNode.removeListener(_onFocusChanged);
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
