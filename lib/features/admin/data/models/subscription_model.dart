import 'package:flutter_mattermost/features/admin/domain/entities/subscription_entity.dart';

final class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.customer_id,
    required super.product_id,
    required super.add_ons,
    required super.start_at,
    required super.end_at,
    required super.create_at,
    required super.seats,
    required super.dns,
  });

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map["id"] as String?,
      customer_id: map["customer_id"] as String?,
      product_id: map["product_id"] as String?,
      add_ons: List<String>.from(map["add_ons"] as List<dynamic>? ?? []),
      start_at: (map["start_at"] as num?)?.toInt(),
      end_at: (map["end_at"] as num?)?.toInt(),
      create_at: (map["create_at"] as num?)?.toInt(),
      seats: (map["seats"] as num?)?.toInt(),
      dns: map["dns"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "customer_id": customer_id,
      "product_id": product_id,
      "add_ons": add_ons,
      "start_at": start_at,
      "end_at": end_at,
      "create_at": create_at,
      "seats": seats,
      "dns": dns,
    };
  }

  factory SubscriptionModel.fromEntity(SubscriptionEntity entity) {
    return SubscriptionModel(
      id: entity.id,
      customer_id: entity.customer_id,
      product_id: entity.product_id,
      add_ons: entity.add_ons,
      start_at: entity.start_at,
      end_at: entity.end_at,
      create_at: entity.create_at,
      seats: entity.seats,
      dns: entity.dns,
    );
  }

  SubscriptionModel copyWith({
    String? id,
    String? customer_id,
    String? product_id,
    List<String>? add_ons,
    int? start_at,
    int? end_at,
    int? create_at,
    int? seats,
    String? dns,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      customer_id: customer_id ?? this.customer_id,
      product_id: product_id ?? this.product_id,
      add_ons: add_ons ?? this.add_ons,
      start_at: start_at ?? this.start_at,
      end_at: end_at ?? this.end_at,
      create_at: create_at ?? this.create_at,
      seats: seats ?? this.seats,
      dns: dns ?? this.dns,
    );
  }

  SubscriptionEntity toEntity() => SubscriptionEntity(
        id: id,
        customer_id: customer_id,
        product_id: product_id,
        add_ons: add_ons,
        start_at: start_at,
        end_at: end_at,
        create_at: create_at,
        seats: seats,
        dns: dns,
      );
}
