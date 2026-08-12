import 'package:equatable/equatable.dart';

class DataRetentionPolicyForTeamEntity extends Equatable {
  final String? team_id;
  final int? post_duration;

  const DataRetentionPolicyForTeamEntity({
    this.team_id,
    this.post_duration,
  });

  @override
  List<Object?> get props => [
        team_id,
        post_duration,
      ];

  DataRetentionPolicyForTeamEntity copyWith({
    String? team_id,
    int? post_duration,
  }) {
    return DataRetentionPolicyForTeamEntity(
      team_id: team_id ?? this.team_id,
      post_duration: post_duration ?? this.post_duration,
    );
  }
}
