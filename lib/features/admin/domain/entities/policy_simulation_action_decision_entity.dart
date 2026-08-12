import 'package:equatable/equatable.dart';

class PolicySimulationActionDecisionEntity extends Equatable {
  final bool? decision;
  final List<Map<String, dynamic>>? blame;

  const PolicySimulationActionDecisionEntity({
    this.decision,
    this.blame,
  });

  @override
  List<Object?> get props => [
        decision,
        blame,
      ];

  PolicySimulationActionDecisionEntity copyWith({
    bool? decision,
    List<Map<String, dynamic>>? blame,
  }) {
    return PolicySimulationActionDecisionEntity(
      decision: decision ?? this.decision,
      blame: blame ?? this.blame,
    );
  }
}
