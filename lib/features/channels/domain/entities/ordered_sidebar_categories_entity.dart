import 'package:equatable/equatable.dart';

class OrderedSidebarCategoriesEntity extends Equatable {
  final List<String>? order;
  final List<Map<String, dynamic>>? categories;

  const OrderedSidebarCategoriesEntity({
    this.order,
    this.categories,
  });

  @override
  List<Object?> get props => [
        order,
        categories,
      ];

  OrderedSidebarCategoriesEntity copyWith({
    List<String>? order,
    List<Map<String, dynamic>>? categories,
  }) {
    return OrderedSidebarCategoriesEntity(
      order: order ?? this.order,
      categories: categories ?? this.categories,
    );
  }
}
