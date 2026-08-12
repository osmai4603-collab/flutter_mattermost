import 'package:equatable/equatable.dart';

class PolicySimulationSessionEntity extends Equatable {
  final String? device;
  final String? network;
  final int? last_active_at;
  final Map<String, dynamic>? decisions;
  final Map<String, dynamic>? attributes;

  const PolicySimulationSessionEntity({
    this.device,
    this.network,
    this.last_active_at,
    this.decisions,
    this.attributes,
  });

  @override
  List<Object?> get props => [
        device,
        network,
        last_active_at,
        decisions,
        attributes,
      ];

  PolicySimulationSessionEntity copyWith({
    String? device,
    String? network,
    int? last_active_at,
    Map<String, dynamic>? decisions,
    Map<String, dynamic>? attributes,
  }) {
    return PolicySimulationSessionEntity(
      device: device ?? this.device,
      network: network ?? this.network,
      last_active_at: last_active_at ?? this.last_active_at,
      decisions: decisions ?? this.decisions,
      attributes: attributes ?? this.attributes,
    );
  }
}
