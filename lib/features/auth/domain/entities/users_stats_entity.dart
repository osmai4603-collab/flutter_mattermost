import 'package:equatable/equatable.dart';

class UsersStatsEntity extends Equatable {
  final int? total_users_count;

  const UsersStatsEntity({
    this.total_users_count,
  });

  @override
  List<Object?> get props => [
        total_users_count,
      ];

  UsersStatsEntity copyWith({
    int? total_users_count,
  }) {
    return UsersStatsEntity(
      total_users_count: total_users_count ?? this.total_users_count,
    );
  }
}
