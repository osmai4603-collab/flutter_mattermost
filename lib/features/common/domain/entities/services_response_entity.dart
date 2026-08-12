import 'package:equatable/equatable.dart';

class ServicesResponseEntity extends Equatable {
  final List<Map<String, dynamic>>? services;

  const ServicesResponseEntity({
    this.services,
  });

  @override
  List<Object?> get props => [
        services,
      ];

  ServicesResponseEntity copyWith({
    List<Map<String, dynamic>>? services,
  }) {
    return ServicesResponseEntity(
      services: services ?? this.services,
    );
  }
}
