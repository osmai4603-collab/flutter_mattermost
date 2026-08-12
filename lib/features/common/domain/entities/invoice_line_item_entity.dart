import 'package:equatable/equatable.dart';

class InvoiceLineItemEntity extends Equatable {
  final String? price_id;
  final int? total;
  final int? quantity;
  final int? price_per_unit;
  final String? description;
  final List<String>? metadata;

  const InvoiceLineItemEntity({
    this.price_id,
    this.total,
    this.quantity,
    this.price_per_unit,
    this.description,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        price_id,
        total,
        quantity,
        price_per_unit,
        description,
        metadata,
      ];

  InvoiceLineItemEntity copyWith({
    String? price_id,
    int? total,
    int? quantity,
    int? price_per_unit,
    String? description,
    List<String>? metadata,
  }) {
    return InvoiceLineItemEntity(
      price_id: price_id ?? this.price_id,
      total: total ?? this.total,
      quantity: quantity ?? this.quantity,
      price_per_unit: price_per_unit ?? this.price_per_unit,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }
}
