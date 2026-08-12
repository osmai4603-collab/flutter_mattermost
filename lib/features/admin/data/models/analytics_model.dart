import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';

final class AnalyticsModel extends AnalyticsEntity {
  const AnalyticsModel({required Map<String, dynamic> raw}) : super(raw);

  factory AnalyticsModel.fromMap(Map<String, dynamic> map) {
    return AnalyticsModel(raw: Map<String, dynamic>.from(map));
  }

  Map<String, dynamic> toMap() {
    return Map<String, dynamic>.from(raw);
  }

  factory AnalyticsModel.fromEntity(AnalyticsEntity entity) {
    return AnalyticsModel(raw: Map<String, dynamic>.from(entity.raw));
  }

  AnalyticsModel copyWith({Map<String, dynamic>? raw}) {
    return AnalyticsModel(raw: raw ?? this.raw);
  }

  AnalyticsEntity toEntity() => AnalyticsEntity(raw);
}
