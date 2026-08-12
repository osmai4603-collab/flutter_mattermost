import 'package:equatable/equatable.dart';

class SubscriptionEntity extends Equatable {
  final String? id;
  final String? customer_id;
  final String? product_id;
  final List<String>? add_ons;
  final int? start_at;
  final int? end_at;
  final int? create_at;
  final int? seats;
  final String? dns;

  const SubscriptionEntity({
    this.id,
    this.customer_id,
    this.product_id,
    this.add_ons,
    this.start_at,
    this.end_at,
    this.create_at,
    this.seats,
    this.dns,
  });

  @override
  List<Object?> get props => [
        id,
        customer_id,
        product_id,
        add_ons,
        start_at,
        end_at,
        create_at,
        seats,
        dns,
      ];

  SubscriptionEntity copyWith({
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
    return SubscriptionEntity(
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
}
