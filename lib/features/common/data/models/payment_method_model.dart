import 'package:flutter_mattermost/features/common/domain/entities/payment_method_entity.dart';

final class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    required super.type,
    required super.last_four,
    required super.exp_month,
    required super.exp_year,
    required super.card_brand,
    required super.name,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      type: map["type"] as String?,
      last_four: (map["last_four"] as num?)?.toInt(),
      exp_month: (map["exp_month"] as num?)?.toInt(),
      exp_year: (map["exp_year"] as num?)?.toInt(),
      card_brand: map["card_brand"] as String?,
      name: map["name"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "last_four": last_four,
      "exp_month": exp_month,
      "exp_year": exp_year,
      "card_brand": card_brand,
      "name": name,
    };
  }

  factory PaymentMethodModel.fromEntity(PaymentMethodEntity entity) {
    return PaymentMethodModel(
      type: entity.type,
      last_four: entity.last_four,
      exp_month: entity.exp_month,
      exp_year: entity.exp_year,
      card_brand: entity.card_brand,
      name: entity.name,
    );
  }

  @override
  PaymentMethodModel copyWith({
    String? type,
    int? last_four,
    int? exp_month,
    int? exp_year,
    String? card_brand,
    String? name,
  }) {
    return PaymentMethodModel(
      type: type ?? this.type,
      last_four: last_four ?? this.last_four,
      exp_month: exp_month ?? this.exp_month,
      exp_year: exp_year ?? this.exp_year,
      card_brand: card_brand ?? this.card_brand,
      name: name ?? this.name,
    );
  }

  PaymentMethodEntity toEntity() => PaymentMethodEntity(
        type: type,
        last_four: last_four,
        exp_month: exp_month,
        exp_year: exp_year,
        card_brand: card_brand,
        name: name,
      );
}
