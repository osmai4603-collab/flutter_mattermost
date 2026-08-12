import 'package:equatable/equatable.dart';

class TeamsLimitsEntity extends Equatable {
  final int? active;

  const TeamsLimitsEntity({
    this.active,
  });

  @override
  List<Object?> get props => [
        active,
      ];

  TeamsLimitsEntity copyWith({
    int? active,
  }) {
    return TeamsLimitsEntity(
      active: active ?? this.active,
    );
  }
}
