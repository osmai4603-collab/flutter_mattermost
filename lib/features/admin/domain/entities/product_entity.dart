import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? price_per_seat;
  final List<Map<String, dynamic>>? add_ons;

  const ProductEntity({
    this.id,
    this.name,
    this.description,
    this.price_per_seat,
    this.add_ons,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price_per_seat,
        add_ons,
      ];

  ProductEntity copyWith({
    String? id,
    String? name,
    String? description,
    String? price_per_seat,
    List<Map<String, dynamic>>? add_ons,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price_per_seat: price_per_seat ?? this.price_per_seat,
      add_ons: add_ons ?? this.add_ons,
    );
  }
}
