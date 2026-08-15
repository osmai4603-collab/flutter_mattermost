import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// رنّان المكالمة الواردة — نغمة رنين متكررة (audioplayers) + نغمة نظام/اهتزاز
/// احتياطية، طيلة فترة الرنين.
///
/// يُشغَّل عند دخول حالة `ringing` ويُوقَف عند القبول/الرفض/انتهاء المهلة.
/// إن تعذّر تشغيل الصوت (مثلاً غياب GStreamer على Linux) يتحول تلقائياً
/// إلى نغمة النظام.
class CallRinger {
  AudioPlayer? _player;
  Timer? _timer;
  bool _ringing = false;

  bool get isRinging => _ringing;

  /// بدء الرنين المتكرر — بلا تأثير إن كان يعمل مسبقاً.
  void startRinging() {
    if (_ringing) return;
    _ringing = true;
    unawaited(_playLoop());
  }

  Future<void> _playLoop() async {
    try {
      // بيئة اختبارات بلا ServicesBinding (flutter test بدون WidgetsBinding)
      // تُجهِز الأجهزة الصوتية بشكل غير متزامن لا يمكن التقاطه — نتحقق
      // من تهيئة الـ binding أولاً ونقع على النغمة الاحتياطية.
      try {
        WidgetsBinding.instance;
      } catch (_) {
        throw StateError('ServicesBinding not initialized');
      }
      final player = _player ??= AudioPlayer();
      await player.setReleaseMode(ReleaseMode.loop);
      await player.setVolume(1.0);
      await player.play(AssetSource('sounds/calls_ringtone.wav'));
    } catch (_) {
      // تعذّر تشغيل الملف — نغمة نظام + اهتزاز متكرر احتياطية.
      unawaited(_systemAlert());
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        unawaited(_systemAlert());
      });
    }
  }

  Future<void> _systemAlert() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.heavyImpact();
    } catch (_) {
      // تجاهل — بعض المنصات لا تدعم النظام أو الاهتزاز.
    }
  }

  /// إيقاف الرنين وإلغاء المؤقت.
  void stopRinging() {
    _ringing = false;
    _timer?.cancel();
    _timer = null;
    unawaited(_player?.stop());
  }

  Future<void> dispose() async {
    stopRinging();
    await _player?.dispose();
    _player = null;
  }
}
