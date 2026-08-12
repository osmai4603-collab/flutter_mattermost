import 'package:equatable/equatable.dart';

class UserThreadsEntity extends Equatable {
  final int? total;
  final List<Map<String, dynamic>>? threads;

  const UserThreadsEntity({
    this.total,
    this.threads,
  });

  @override
  List<Object?> get props => [
        total,
        threads,
      ];

  UserThreadsEntity copyWith({
    int? total,
    List<Map<String, dynamic>>? threads,
  }) {
    return UserThreadsEntity(
      total: total ?? this.total,
      threads: threads ?? this.threads,
    );
  }
}
