import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/calls/calls_manager.dart';
import 'package:flutter_mattermost/core/di/injection.dart';

/// عداد مدة المكالمة الحالية — مطابق call_duration.tsx في webapp:
/// `mm:ss` لأقل من ساعة و `hh:mm:ss` بعدها، تحديث كل 500ms، وضبط
/// لحظة البداية إذا كانت ساعة الخادم متقدمة عن المحلية (يبدأ من 0:00
/// فوراً بدل قيم سالبة). يقرأ [CallsManager.callStartAt] لكل نبضة فيتعامل
/// مع وصول حدث call_start بعد بناء الويدجت (سباق المنشئ).
class CallDuration extends StatefulWidget {
  const CallDuration({super.key, this.style});

  final TextStyle? style;

  @override
  State<CallDuration> createState() => _CallDurationState();
}

class _CallDurationState extends State<CallDuration> {
  static const _oneHour = Duration(hours: 1);

  Timer? _timer;
  DateTime? _recordedStartAt;
  DateTime? _adjustedStartAt;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _tick(),
    );
  }

  void _tick() {
    final startAt = getIt<CallsManager>().callStartAt;

    if (startAt != _recordedStartAt) {
      _recordedStartAt = startAt;
      _adjustedStartAt = startAt == null
          ? null
          : startAt.isAfter(DateTime.now())
              ? DateTime.now()
              : startAt;
    }

    final adjusted = _adjustedStartAt;
    final elapsed = adjusted == null
        ? Duration.zero
        : DateTime.now().difference(adjusted);
    if (!mounted) return;
    setState(() {
      _elapsed = elapsed.isNegative ? Duration.zero : elapsed;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _format(_elapsed),
      style: widget.style ?? const TextStyle(fontWeight: FontWeight.w600),
    );
  }

  static String _format(Duration duration) {
    final totalSeconds = duration.inSeconds;
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;

    String two(int v) => v.toString().padLeft(2, '0');

    if (duration < _oneHour) return '${two(m)}:${two(s)}';
    return '${two(h)}:${two(m)}:${two(s)}';
  }
}
