/// منطق ضغط المفاتيح عند الإرسال — نظير postMessageOnKeyPress
/// (webapp/channels/src/utils/post_utils.ts) مع
/// isWithinCodeBlock و canAutomaticallyCloseBackticks.
library;

/// الحد الزمني (مللي ثانية) الذي يتم بعده تجاهل Enter بعد تبديل قناة
/// — يمنع الإرسال الفوري غير المقصود عند تبديل القناة.
const int kChannelSwitchIgnoreEnterThresholdMs = 500;

final RegExp _codeBlockOptionalLanguageTag = RegExp(
  r'^```.*$',
  multiLine: true,
);

/// هل موضع المؤشر داخل كتلة كود (```)؟
bool isWithinCodeBlock(String message, int caretPosition) {
  if (caretPosition <= 0) return false;
  final beforeCaret = caretPosition > message.length
      ? message
      : message.substring(0, caretPosition);
  return _codeBlockOptionalLanguageTag.allMatches(beforeCaret).length % 2 != 0;
}

/// نتيجة معالجة ضغطة Enter في المحرر.
class PostKeyPressResult {
  final bool allowSending;

  /// صحيح إذا كان يجب منع الحدث بالكامل (لا إرسال ولا سطر جديد).
  final bool ignoreKeyPress;

  /// صحيح إذا أغلقنا كتلة الكود تلقائياً (مع إضافة ```).
  final bool withClosedCodeBlock;

  /// الرسالة المحدثة بعد إغلاق الكتلة (اختياري).
  final String? message;

  const PostKeyPressResult({
    this.allowSending = false,
    this.ignoreKeyPress = false,
    this.withClosedCodeBlock = false,
    this.message,
  });
}

/// عند الإرسال بـ Ctrl/Cmd+Enter داخل كتلة كود: إغلاق الكتلة تلقائياً.
PostKeyPressResult _canAutomaticallyCloseBackticks(String message) {
  final splitMessage = message
      .split('\n')
      .where((line) => line.trim().isNotEmpty)
      .toList();
  if (splitMessage.isEmpty) return const PostKeyPressResult(allowSending: true);
  final lastPart = splitMessage.last;

  if (splitMessage.length > 1 && !lastPart.contains('```')) {
    return PostKeyPressResult(
      allowSending: true,
      withClosedCodeBlock: true,
      message: message.endsWith('\n')
          ? '$message```'
          : '$message\n```',
    );
  }
  return const PostKeyPressResult(allowSending: true);
}

PostKeyPressResult _sendOnCtrlEnter(
  String message,
  bool ctrlOrMetaKeyPressed,
  bool isSendMessageOnCtrlEnter,
  int caretPosition,
) {
  final inCodeBlock = isWithinCodeBlock(message, caretPosition);
  if (isSendMessageOnCtrlEnter && ctrlOrMetaKeyPressed && !inCodeBlock) {
    return const PostKeyPressResult(allowSending: true);
  } else if (!isSendMessageOnCtrlEnter && !inCodeBlock) {
    return const PostKeyPressResult(allowSending: true);
  } else if (ctrlOrMetaKeyPressed && inCodeBlock) {
    return _canAutomaticallyCloseBackticks(message);
  }
  return const PostKeyPressResult();
}

/// يحدد ما إذا كانت ضغطة Enter تُرسل الرسالة، وفق إعدادات
/// send_on_ctrl_enter و code_block_ctrl_enter.
PostKeyPressResult postMessageOnKeyPress({
  required bool isEnterKey,
  required bool shiftKey,
  required bool altKey,
  required bool ctrlKey,
  required bool metaKey,
  required String message,
  required bool sendMessageOnCtrlEnter,
  required bool sendCodeBlockOnCtrlEnter,
  required int now,
  required int lastChannelSwitchAt,
  required int caretPosition,
  required bool isMobile,
}) {
  if (!isEnterKey) return const PostKeyPressResult();

  // على الجوال لا يُرسل بالضغط على Enter أبداً.
  if (isMobile) return const PostKeyPressResult();

  // Enter فقط يُرسل — ما لم تُضغط Shift أو Alt.
  if (shiftKey || altKey) return const PostKeyPressResult();

  // لا ترسل إذا كنا قد بدّلنا القناة للتو.
  if (lastChannelSwitchAt > 0 &&
      now > 0 &&
      now - lastChannelSwitchAt <= kChannelSwitchIgnoreEnterThresholdMs) {
    return const PostKeyPressResult(ignoreKeyPress: true);
  }

  if (!(sendMessageOnCtrlEnter || sendCodeBlockOnCtrlEnter)) {
    return const PostKeyPressResult(allowSending: true);
  }

  final ctrlOrMetaKeyPressed = ctrlKey || metaKey;

  if (sendMessageOnCtrlEnter) {
    return _sendOnCtrlEnter(
      message,
      ctrlOrMetaKeyPressed,
      true,
      caretPosition,
    );
  } else if (sendCodeBlockOnCtrlEnter) {
    if (message.trim().isEmpty) {
      return const PostKeyPressResult(allowSending: true);
    }
    return _sendOnCtrlEnter(message, ctrlOrMetaKeyPressed, false, caretPosition);
  }

  return const PostKeyPressResult();
}

/// هل هذا الخطأ خطأ "أمر slash غير موجود"؟ (نظير isErrorInvalidSlashCommand)
bool isInvalidSlashCommandError(String message) =>
    message.contains('api.command.execute_command.not_found.app_error');
