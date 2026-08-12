import 'package:flutter_mattermost/features/common/domain/entities/address_entity.dart';

final class AddressModel extends AddressEntity {
  const AddressModel({
    required super.city,
    required super.country,
    required super.line1,
    required super.line2,
    required super.postal_code,
    required super.state,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      city: map["city"] as String?,
      country: map["country"] as String?,
      line1: map["line1"] as String?,
      line2: map["line2"] as String?,
      postal_code: map["postal_code"] as String?,
      state: map["state"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "city": city,
      "country": country,
      "line1": line1,
      "line2": line2,
      "postal_code": postal_code,
      "state": state,
    };
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      city: entity.city,
      country: entity.country,
      line1: entity.line1,
      line2: entity.line2,
      postal_code: entity.postal_code,
      state: entity.state,
    );
  }

  @override
  AddressModel copyWith({
    String? city,
    String? country,
    String? line1,
    String? line2,
    String? postal_code,
    String? state,
  }) {
    return AddressModel(
      city: city ?? this.city,
      country: country ?? this.country,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      postal_code: postal_code ?? this.postal_code,
      state: state ?? this.state,
    );
  }

  AddressEntity toEntity() => AddressEntity(
        city: city,
        country: country,
        line1: line1,
        line2: line2,
        postal_code: postal_code,
        state: state,
      );
}
