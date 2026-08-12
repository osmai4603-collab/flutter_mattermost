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