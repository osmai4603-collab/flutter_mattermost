import 'package:flutter_mattermost/core/localizations/generated/app_localizations.dart';

/// تنسيقات الزمن المستخدمة في الواجهة (مطابقة webapp formatTime).
String formatPostTime(int millis) {
  final dt = DateTime.fromMillisecondsSinceEpoch(millis).toLocal();
  final now = DateTime.now();
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  final sameDay = dt.year == now.year &&
      dt.month == now.month &&
      dt.day == now.day;
  if (sameDay) {
    return '$h:$m';
  }
  final mm = dt.month.toString().padLeft(2, '0');
  final dd = dt.day.toString().padLeft(2, '0');
  return '$dd/$mm/${dt.year}';
}

/// زمن نسبي مختصر (مطابق formatTimeDistance في webapp) — يُستخدم مثلاً
/// في "Last online {timestamp}" لرأس المحادثات المباشرة.
String formatRelativeTime(int millis, AppLocalizations l10n) {
  final diff = DateTime.now().difference(
    DateTime.fromMillisecondsSinceEpoch(millis),
  );
  if (diff.inSeconds < 60) {
    return l10n.timeRelativeJustNow;
  }
  if (diff.inMinutes < 60) {
    return l10n.timeRelativeMinutesAgo(diff.inMinutes);
  }
  if (diff.inHours < 24) {
    return l10n.timeRelativeHoursAgo(diff.inHours);
  }
  return l10n.timeRelativeDaysAgo(diff.inDays);
}