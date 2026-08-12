import 'package:flutter_mattermost/features/auth/domain/entities/user_autocomplete_in_team_entity.dart';

final class UserAutocompleteInTeamModel extends UserAutocompleteInTeamEntity {
  const UserAutocompleteInTeamModel({
    required super.in_team,
  });

  factory UserAutocompleteInTeamModel.fromMap(Map<String, dynamic> map) {
    return UserAutocompleteInTeamModel(
      in_team: (map["in_team"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "in_team": in_team,
    };
  }

  factory UserAutocompleteInTeamModel.fromEntity(UserAutocompleteInTeamEntity entity) {
    return UserAutocompleteInTeamModel(
      in_team: entity.in_team,
    );
  }

  @override
  UserAutocompleteInTeamModel copyWith({
    List<Map<String, dynamic>>? in_team,
  }) {
    return UserAutocompleteInTeamModel(
      in_team: in_team ?? this.in_team,
    );
  }

  UserAutocompleteInTeamEntity toEntity() => UserAutocompleteInTeamEntity(
        in_team: in_team,
      );
}
