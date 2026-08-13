import 'package:flutter/material.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_entity.dart';

/// نقطة حقن عناصر إضافية في رأس القناة — معادل `Pluggable pluggableName='ChannelHeaderIcon'`
/// في webapp. بما أن كود Dart مجمَّع مسبقاً، تُسجَّل الـ Widgets الجاهزة
/// وقت التشغيل من أي ميزة (مكالمات، تطبيقات، ...) دون تحميل كود ديناميكي.
typedef ChannelHeaderSlotBuilder =
    Widget Function(BuildContext context, ChannelEntity channel);

/// سجل الفتحات (plugin host) — ناطق صنفاً واحداً لكل نوع:
/// [iconSlot] داخلياً يلي زر الأعضاء.
class ChannelHeaderSlots {
  ChannelHeaderSlots._();

  static final List<ChannelHeaderSlotBuilder> _iconSlotBuilders = [];

  /// تسجيل عنصر أيقونة يُعرض داخل رأس القناة بعد زر الأعضاء.
  static void registerIconSlot(ChannelHeaderSlotBuilder builder) {
    _iconSlotBuilders.add(builder);
  }

  static void unregisterIconSlot(ChannelHeaderSlotBuilder builder) {
    _iconSlotBuilders.remove(builder);
  }

  /// بناء العناصر المسجلة — يُستدعى من [ChannelHeader].
  static List<Widget> buildIconSlots(
    BuildContext context,
    ChannelEntity? channel,
  ) {
    if (channel == null || _iconSlotBuilders.isEmpty) return const [];
    return List.unmodifiable([
      for (final builder in _iconSlotBuilders) builder(context, channel),
    ]);
  }
}