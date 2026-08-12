import 'package:equatable/equatable.dart';

class PropertyValueRequestEntity extends Equatable {
  final String? value;

  const PropertyValueRequestEntity({
    required this.value,
  });

  @override
  List<Object?> get props => [
        value,
      ];

  PropertyValueRequestEntity copyWith({
    String? value,
  }) {
    return PropertyValueRequestEntity(
      value: value ?? this.value,
    );
  }
}
