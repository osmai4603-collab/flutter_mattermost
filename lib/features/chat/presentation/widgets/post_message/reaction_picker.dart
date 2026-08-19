import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/chat/presentation/widgets/emoji_picker_overlay.dart';

/// نافذة انتقاء رد فعل — تفتح EmojiPickerOverlay الكامل وترجع emoji أو null.
Future<String?> showReactionPicker(BuildContext context) {
  final completer = Completer<String?>();
  EmojiPickerOverlay.show(
    context,
    anchorContext: context,
    multiSelected: false,
    onEmojiSelected: (emoji) {
      if (!completer.isCompleted) completer.complete(emoji);
    },
    onDismissed: () {
      if (!completer.isCompleted) completer.complete(null);
    },
  );
  return completer.future;
}
