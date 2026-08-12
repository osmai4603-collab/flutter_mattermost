sealed class SystemEndPoint {
  SystemEndPoint._();

  static const String base = '/system';
  static const String root = '/';
  static const String e2eAiBridge = '$base/e2e/ai_bridge';
  static const String latestVersion = '$base/latest_version';
  static const String noticesView = '$base/notices/view';
  static String notices(String teamId) => '$base/notices/$teamId';
  static const String onboardingComplete = '$base/onboarding/complete';
  static const String ping = '$base/ping';
  static const String schemaVersion = '$base/schema/version';
  static const String supportPacket = '$base/support_packet';
  static const String timezones = '$base/timezones';
}
