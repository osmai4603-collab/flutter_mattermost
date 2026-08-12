import 'package:equatable/equatable.dart';

class AgentsResponseEntity extends Equatable {
  final List<Map<String, dynamic>>? agents;

  const AgentsResponseEntity({
    this.agents,
  });

  @override
  List<Object?> get props => [
        agents,
      ];

  AgentsResponseEntity copyWith({
    List<Map<String, dynamic>>? agents,
  }) {
    return AgentsResponseEntity(
      agents: agents ?? this.agents,
    );
  }
}
