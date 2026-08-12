import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final String? type;
  final int? last_four;
  final int? exp_month;
  final int? exp_year;
  final String? card_brand;
  final String? name;

  const PaymentMethodEntity({
    this.type,
    this.last_four,
    this.exp_month,
    this.exp_year,
    this.card_brand,
    this.name,
  });

  @override
  List<Object?> get props => [
        type,
        last_four,
        exp_month,
        exp_year,
        card_brand,
        name,
      ];

  PaymentMethodEntity copyWith({
    String? type,
    int? last_four,
    int? exp_month,
    int? exp_year,
    String? card_brand,
    String? name,
  }) {
    return PaymentMethodEntity(
      type: type ?? this.type,
      last_four: last_four ?? this.last_four,
      exp_month: exp_month ?? this.exp_month,
      exp_year: exp_year ?? this.exp_year,
      card_brand: card_brand ?? this.card_brand,
      name: name ?? this.name,
    );
  }
}
