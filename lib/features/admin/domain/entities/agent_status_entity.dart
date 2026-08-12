import 'package:equatable/equatable.dart';

class AgentStatusEntity extends Equatable {
  final String? agent_id;
  final String? team_id;
  final String? status;
  final List<String>? capabilities;
  final int? last_status_update_at;
  final int? last_capability_update_at;
  final int? retry_loop_count;
  const AgentStatusEntity({
    this.agent_id,
    this.team_id,
    this.status,
    this.capabilities,
    this.last_status_update_at,
    this.last_capability_update_at,
    this.retry_loop_count,
  });

  @override
  List<Object?> get props => [
      agent_id,
      team_id,
      status,
      capabilities,
      last_status_update_at,
      last_capability_update_at,
      retry_loop_count,
  ];
}
