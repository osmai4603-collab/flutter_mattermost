import 'package:equatable/equatable.dart';

class PolicySimulationUserOverrideEntity extends Equatable {
  final String? user_id;
  final bool? use_active_session;
  final Map<String, dynamic>? session_overrides;

  const PolicySimulationUserOverrideEntity({
    required this.user_id,
    this.use_active_session,
    this.session_overrides,
  });

  @override
  List<Object?> get props => [
        user_id,
        use_active_session,
        session_overrides,
      ];

  PolicySimulationUserOverrideEntity copyWith({
    String? user_id,
    bool? use_active_session,
    Map<String, dynamic>? session_overrides,
  }) {
    return PolicySimulationUserOverrideEntity(
      user_id: user_id ?? this.user_id,
      use_active_session: use_active_session ?? this.use_active_session,
      session_overrides: session_overrides ?? this.session_overrides,
    );
  }
}
