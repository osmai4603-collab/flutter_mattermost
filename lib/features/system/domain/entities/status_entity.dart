import 'package:equatable/equatable.dart';

class StatusEntity extends Equatable {
  final String? user_id;
  final String? status;
  final bool? manual;
  final int? last_activity_at;

  const StatusEntity({
    this.user_id,
    this.status,
    this.manual,
    this.last_activity_at,
  });

  @override
  List<Object?> get props => [
        user_id,
        status,
        manual,
        last_activity_at,
      ];

  StatusEntity copyWith({
    String? user_id,
    String? status,
    bool? manual,
    int? last_activity_at,
  }) {
    return StatusEntity(
      user_id: user_id ?? this.user_id,
      status: status ?? this.status,
      manual: manual ?? this.manual,
      last_activity_at: last_activity_at ?? this.last_activity_at,
    );
  }
}
