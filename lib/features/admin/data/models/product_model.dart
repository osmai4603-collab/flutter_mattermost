import 'package:flutter_mattermost/features/admin/domain/entities/product_entity.dart';

final class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price_per_seat,
    required super.add_ons,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map["id"] as String?,
      name: map["name"] as String?,
      description: map["description"] as String?,
      price_per_seat: map["price_per_seat"] as String?,
      add_ons: (map["add_ons"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "price_per_seat": price_per_seat,
      "add_ons": add_ons,
    };
  }

  factory ProductModel.fromEntity(ProductEntity entity) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      price_per_seat: entity.price_per_seat,
      add_ons: entity.add_ons,
    );
  }

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? price_per_seat,
    List<Map<String, dynamic>>? add_ons,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price_per_seat: price_per_seat ?? this.price_per_seat,
      add_ons: add_ons ?? this.add_ons,
    );
  }

  ProductEntity toEntity() => ProductEntity(
        id: id,
        name: name,
        description: description,
        price_per_seat: price_per_seat,
        add_ons: add_ons,
      );
}
