import 'package:equatable/equatable.dart';

class AddOnEntity extends Equatable {
  final String? id;
  final String? name;
  final String? display_name;
  final String? price_per_seat;

  const AddOnEntity({
    this.id,
    this.name,
    this.display_name,
    this.price_per_seat,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        display_name,
        price_per_seat,
      ];

  AddOnEntity copyWith({
    String? id,
    String? name,
    String? display_name,
    String? price_per_seat,
  }) {
    return AddOnEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      display_name: display_name ?? this.display_name,
      price_per_seat: price_per_seat ?? this.price_per_seat,
    );
  }
}
