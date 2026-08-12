import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String? city;
  final String? country;
  final String? line1;
  final String? line2;
  final String? postal_code;
  final String? state;

  const AddressEntity({
    this.city,
    this.country,
    this.line1,
    this.line2,
    this.postal_code,
    this.state,
  });

  @override
  List<Object?> get props => [
        city,
        country,
        line1,
        line2,
        postal_code,
        state,
      ];

  AddressEntity copyWith({
    String? city,
    String? country,
    String? line1,
    String? line2,
    String? postal_code,
    String? state,
  }) {
    return AddressEntity(
      city: city ?? this.city,
      country: country ?? this.country,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      postal_code: postal_code ?? this.postal_code,
      state: state ?? this.state,
    );
  }
}
