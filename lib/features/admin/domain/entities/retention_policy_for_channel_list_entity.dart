import 'package:equatable/equatable.dart';

class RetentionPolicyForChannelListEntity extends Equatable {
  final List<Map<String, dynamic>>? policies;
  final int? total_count;

  const RetentionPolicyForChannelListEntity({
    this.policies,
    this.total_count,
  });

  @override
  List<Object?> get props => [
        policies,
        total_count,
      ];

  RetentionPolicyForChannelListEntity copyWith({
    List<Map<String, dynamic>>? policies,
    int? total_count,
  }) {
    return RetentionPolicyForChannelListEntity(
      policies: policies ?? this.policies,
      total_count: total_count ?? this.total_count,
    );
  }
}
