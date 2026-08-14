import 'package:drift/drift.dart';
import 'package:flutter_mattermost/core/entities/entity.dart';

/// إحصاءات النظام الآتية من GET /analytics/old.
class AnalyticsItemEntity extends Entity {
  final String name;
  final int value;

  const AnalyticsItemEntity({required this.name, required this.value});

  /// قائمة بإحصاءات المقاييس المتفرّقة (daily_active_users، إلخ).
  // List<Map<String, dynamic>> get metrics => raw['metrics'] is List
  //     ? (raw['metrics'] as List).map((e) => e as Map<String, dynamic>).toList()
  //     : const [];

  // int _intOf(String key) {
  //   final value = raw[key];
  //   if (value is num) {
  //     return value.toInt();
  //   }
  //   if (value is String) {
  //     return int.tryParse(value) ?? 0;
  //   }
  //   return 0;
  // }

  /// يُرجع مفاتيح المقاييس غير الفارغة لعرضها في الجداول.
  List<String> get availableKeys => ['name, value'];
  // raw.entries
  //     .where((e) => e.value != null && e.key != 'metrics')
  //     .map((e) => e.key)
  //     .toList();

  // String displayValue(String key) {
  //   return _intOf(key).toString();
  // }

  @override
  List<Object?> get props => [name, value];
}

class AnalyticsEntity {
  final List<AnalyticsItemEntity> items;
  AnalyticsEntity({required this.items});

  int get totalUsers => _intOf('total_users');
  int get activeUsers => _intOf('active_users');
  int get totalTeams => _intOf('total_teams');
  int get totalChannels => _intOf('total_channels');
  int get totalPosts => _intOf('total_posts');
  int get totalSessions => _intOf('total_sessions');
  int get totalCommands => _intOf('total_commands');
  int get totalIncomingWebhooks => _intOf('total_incoming_webhooks');
  int get totalOutgoingWebhooks => _intOf('total_outgoing_webhooks');

  int _intOf(String key) {
    return items.where((item) => item.name == 'total_users').length;
  }
}
