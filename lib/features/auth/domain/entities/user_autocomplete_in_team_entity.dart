import 'package:equatable/equatable.dart';

class UserAutocompleteInTeamEntity extends Equatable {
  final List<Map<String, dynamic>>? in_team;

  const UserAutocompleteInTeamEntity({
    this.in_team,
  });

  @override
  List<Object?> get props => [
        in_team,
      ];

  UserAutocompleteInTeamEntity copyWith({
    List<Map<String, dynamic>>? in_team,
  }) {
    return UserAutocompleteInTeamEntity(
      in_team: in_team ?? this.in_team,
    );
  }
}
