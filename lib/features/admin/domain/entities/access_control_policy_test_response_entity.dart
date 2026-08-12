import 'package:equatable/equatable.dart';

class AccessControlPolicyTestResponseEntity extends Equatable {
  final List<Map<String, dynamic>>? users;
  final int? total_count;

  const AccessControlPolicyTestResponseEntity({
    this.users,
    this.total_count,
  });

  @override
  List<Object?> get props => [
        users,
        total_count,
      ];

  AccessControlPolicyTestResponseEntity copyWith({
    List<Map<String, dynamic>>? users,
    int? total_count,
  }) {
    return AccessControlPolicyTestResponseEntity(
      users: users ?? this.users,
      total_count: total_count ?? this.total_count,
    );
  }
}
