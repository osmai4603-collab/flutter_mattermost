/// إحصاءات النظام الآتية من GET /analytics/old.
class AnalyticsEntity {
  final Map<String, dynamic> raw;

  const AnalyticsEntity(this.raw);

  int get totalUsers => _intOf('total_users');
  int get activeUsers => _intOf('active_users');
  int get totalTeams => _intOf('total_teams');
  int get totalChannels => _intOf('total_channels');
  int get totalPosts => _intOf('total_posts');
  int get totalSessions => _intOf('total_sessions');
  int get totalCommands => _intOf('total_commands');
  int get totalIncomingWebhooks => _intOf('total_incoming_webhooks');
  int get totalOutgoingWebhooks => _intOf('total_outgoing_webhooks');

  /// قائمة بإحصاءات المقاييس المتفرّقة (daily_active_users، إلخ).
  List<Map<String, dynamic>> get metrics => raw['metrics'] is List
      ? (raw['metrics'] as List).map((e) => e as Map<String, dynamic>).toList()
      : const [];

  int _intOf(String key) {
    final value = raw[key];
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  /// يُرجع مفاتيح المقاييس غير الفارغة لعرضها في الجداول.
  List<String> get availableKeys => raw.entries
      .where((e) => e.value != null && e.key != 'metrics')
      .map((e) => e.key)
      .toList();

  String displayValue(String key) {
    return _intOf(key).toString();
  }
}
