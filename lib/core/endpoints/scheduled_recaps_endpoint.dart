sealed class ScheduledRecapsEndPoint {
  ScheduledRecapsEndPoint._();

  static const String base = '/scheduled_recaps';
  static const String root = base;
  static String byScheduledRecapId(String scheduledRecapId) =>
      '$base/$scheduledRecapId';
  static String pause(String scheduledRecapId) =>
      '$base/$scheduledRecapId/pause';
  static String resume(String scheduledRecapId) =>
      '$base/$scheduledRecapId/resume';
}
