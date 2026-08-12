import 'package:equatable/equatable.dart';

class PolicySimulationResponseEntity extends Equatable {
  final List<Map<String, dynamic>>? results;
  final int? total;

  const PolicySimulationResponseEntity({
    this.results,
    this.total,
  });

  @override
  List<Object?> get props => [
        results,
        total,
      ];

  PolicySimulationResponseEntity copyWith({
    List<Map<String, dynamic>>? results,
    int? total,
  }) {
    return PolicySimulationResponseEntity(
      results: results ?? this.results,
      total: total ?? this.total,
    );
  }
}
