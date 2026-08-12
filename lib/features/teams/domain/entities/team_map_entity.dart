import 'package:equatable/equatable.dart';

class TeamMapEntity extends Equatable {
  final Map<String, dynamic>? team_id;

  const TeamMapEntity({
    this.team_id,
  });

  @override
  List<Object?> get props => [
        team_id,
      ];

  TeamMapEntity copyWith({
    Map<String, dynamic>? team_id,
  }) {
    return TeamMapEntity(
      team_id: team_id ?? this.team_id,
    );
  }
}
