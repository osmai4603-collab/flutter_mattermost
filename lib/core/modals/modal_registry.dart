import 'package:flutter/material.dart';

typedef ModalBuilder =
    Widget Function(BuildContext context, Map<String, dynamic>? args);

/// سجلّ النوافذ المنبثقة — مكافئ ModalController في webapp:
/// كل نافذة تُسجَّل بمعرّف ثم تُفتح عبر [openMattermostModal].
class ModalRegistry {
  ModalRegistry._();

  static final Map<String, ModalBuilder> _builders = {};

  static void register(String id, ModalBuilder builder) {
    _builders[id] = builder;
  }

  static bool isRegistered(String id) => _builders.containsKey(id);

  static Future<void> open(
    BuildContext context, {
    required String id,
    Map<String, dynamic>? args,
  }) {
    final builder = _builders[id];
    if (builder == null) return Future.value();
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: id,
      barrierColor: const Color(0x66000000),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, _, __) => builder(ctx, args),
      transitionBuilder: (ctx, anim, _, child) =>
          FadeTransition(opacity: anim, child: child),
    );
  }
}
