import 'package:equatable/equatable.dart';

class StatusOKEntity extends Equatable {
  final String? status;

  const StatusOKEntity({
    this.status,
  });

  @override
  List<Object?> get props => [
        status,
      ];

  StatusOKEntity copyWith({
    String? status,
  }) {
    return StatusOKEntity(
      status: status ?? this.status,
    );
  }
}
