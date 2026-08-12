import 'package:equatable/equatable.dart';

class AccessControlPoliciesWithCountEntity extends Equatable {
  final List<Map<String, dynamic>>? policies;
  final int? total_count;

  const AccessControlPoliciesWithCountEntity({
    this.policies,
    this.total_count,
  });

  @override
  List<Object?> get props => [
        policies,
        total_count,
      ];

  AccessControlPoliciesWithCountEntity copyWith({
    List<Map<String, dynamic>>? policies,
    int? total_count,
  }) {
    return AccessControlPoliciesWithCountEntity(
      policies: policies ?? this.policies,
      total_count: total_count ?? this.total_count,
    );
  }
}
