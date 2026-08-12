import 'package:equatable/equatable.dart';

class PolicySimulationUserResultEntity extends Equatable {
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? decisions;
  final List<Map<String, dynamic>>? sessions;
  final Map<String, dynamic>? attributes;

  const PolicySimulationUserResultEntity({
    this.user,
    this.decisions,
    this.sessions,
    this.attributes,
  });

  @override
  List<Object?> get props => [
        user,
        decisions,
        sessions,
        attributes,
      ];

  PolicySimulationUserResultEntity copyWith({
    Map<String, dynamic>? user,
    Map<String, dynamic>? decisions,
    List<Map<String, dynamic>>? sessions,
    Map<String, dynamic>? attributes,
  }) {
    return PolicySimulationUserResultEntity(
      user: user ?? this.user,
      decisions: decisions ?? this.decisions,
      sessions: sessions ?? this.sessions,
      attributes: attributes ?? this.attributes,
    );
  }
}
