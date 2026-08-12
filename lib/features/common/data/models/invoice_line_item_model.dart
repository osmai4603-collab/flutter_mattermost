import 'package:flutter_mattermost/features/common/domain/entities/invoice_line_item_entity.dart';

final class InvoiceLineItemModel extends InvoiceLineItemEntity {
  const InvoiceLineItemModel({
    required super.price_id,
    required super.total,
    required super.quantity,
    required super.price_per_unit,
    required super.description,
    required super.metadata,
  });

  factory InvoiceLineItemModel.fromMap(Map<String, dynamic> map) {
    return InvoiceLineItemModel(
      price_id: map["price_id"] as String?,
      total: (map["total"] as num?)?.toInt(),
      quantity: (map["quantity"] as num?)?.toInt(),
      price_per_unit: (map["price_per_unit"] as num?)?.toInt(),
      description: map["description"] as String?,
      metadata: List<String>.from(map["metadata"] as List<dynamic>? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "price_id": price_id,
      "total": total,
      "quantity": quantity,
      "price_per_unit": price_per_unit,
      "description": description,
      "metadata": metadata,
    };
  }

  factory InvoiceLineItemModel.fromEntity(InvoiceLineItemEntity entity) {
    return InvoiceLineItemModel(
      price_id: entity.price_id,
      total: entity.total,
      quantity: entity.quantity,
      price_per_unit: entity.price_per_unit,
      description: entity.description,
      metadata: entity.metadata,
    );
  }

  @override
  InvoiceLineItemModel copyWith({
    String? price_id,
    int? total,
    int? quantity,
    int? price_per_unit,
    String? description,
    List<String>? metadata,
  }) {
    return InvoiceLineItemModel(
      price_id: price_id ?? this.price_id,
      total: total ?? this.total,
      quantity: quantity ?? this.quantity,
      price_per_unit: price_per_unit ?? this.price_per_unit,
      description: description ?? this.description,
      metadata: metadata ?? this.metadata,
    );
  }

  InvoiceLineItemEntity toEntity() => InvoiceLineItemEntity(
        price_id: price_id,
        total: total,
        quantity: quantity,
        price_per_unit: price_per_unit,
        description: description,
        metadata: metadata,
      );
}
