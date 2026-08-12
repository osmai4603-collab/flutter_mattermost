import 'package:equatable/equatable.dart';

class RetentionPolicyForTeamListEntity extends Equatable {
  final List<Map<String, dynamic>>? policies;
  final int? total_count;

  const RetentionPolicyForTeamListEntity({
    this.policies,
    this.total_count,
  });

  @override
  List<Object?> get props => [
        policies,
        total_count,
      ];

  RetentionPolicyForTeamListEntity copyWith({
    List<Map<String, dynamic>>? policies,
    int? total_count,
  }) {
    return RetentionPolicyForTeamListEntity(
      policies: policies ?? this.policies,
      total_count: total_count ?? this.total_count,
    );
  }
}
