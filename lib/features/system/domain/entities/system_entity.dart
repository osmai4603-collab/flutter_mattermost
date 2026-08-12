import 'package:equatable/equatable.dart';

class SystemEntity extends Equatable {
  final String? name;
  final String? value;

  const SystemEntity({
    this.name,
    this.value,
  });

  @override
  List<Object?> get props => [
        name,
        value,
      ];

  SystemEntity copyWith({
    String? name,
    String? value,
  }) {
    return SystemEntity(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}
