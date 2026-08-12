import 'package:flutter_mattermost/features/channels/domain/entities/ordered_sidebar_categories_entity.dart';

final class OrderedSidebarCategoriesModel extends OrderedSidebarCategoriesEntity {
  const OrderedSidebarCategoriesModel({
    required super.order,
    required super.categories,
  });

  factory OrderedSidebarCategoriesModel.fromMap(Map<String, dynamic> map) {
    return OrderedSidebarCategoriesModel(
      order: List<String>.from(map["order"] as List<dynamic>? ?? []),
      categories: (map["categories"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "order": order,
      "categories": categories,
    };
  }

  factory OrderedSidebarCategoriesModel.fromEntity(OrderedSidebarCategoriesEntity entity) {
    return OrderedSidebarCategoriesModel(
      order: entity.order,
      categories: entity.categories,
    );
  }

  @override
  OrderedSidebarCategoriesModel copyWith({
    List<String>? order,
    List<Map<String, dynamic>>? categories,
  }) {
    return OrderedSidebarCategoriesModel(
      order: order ?? this.order,
      categories: categories ?? this.categories,
    );
  }

  OrderedSidebarCategoriesEntity toEntity() => OrderedSidebarCategoriesEntity(
        order: order,
        categories: categories,
      );
}
