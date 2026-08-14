import 'package:flutter_mattermost/features/admin/domain/entities/analytics_entity.dart';

final class AnalyticsItemModel extends AnalyticsItemEntity {
  const AnalyticsItemModel({required super.name, required super.value});

  factory AnalyticsItemModel.fromMap(Map<String, dynamic> data) {
    return AnalyticsItemModel(name: data['name'], value: data['value']);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'value': value};
  }

  factory AnalyticsItemModel.fromEntity(AnalyticsItemEntity entity) {
    return AnalyticsItemModel(name: entity.name, value: entity.value);
  }

  AnalyticsItemModel copyWith({String? name, int? value}) {
    return AnalyticsItemModel(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  AnalyticsItemEntity toEntity() =>
      AnalyticsItemEntity(name: name, value: value);
}
