import 'package:equatable/equatable.dart';

class TeamExistsEntity extends Equatable {
  final bool? exists;

  const TeamExistsEntity({
    this.exists,
  });

  @override
  List<Object?> get props => [
        exists,
      ];

  TeamExistsEntity copyWith({
    bool? exists,
  }) {
    return TeamExistsEntity(
      exists: exists ?? this.exists,
    );
  }
}
