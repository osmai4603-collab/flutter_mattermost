import 'package:flutter_mattermost/features/auth/domain/entities/user_autocomplete_entity.dart';

final class UserAutocompleteModel extends UserAutocompleteEntity {
  const UserAutocompleteModel({
    required super.users,
    required super.out_of_channel,
  });

  factory UserAutocompleteModel.fromMap(Map<String, dynamic> map) {
    return UserAutocompleteModel(
      users: (map["users"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      out_of_channel: (map["out_of_channel"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "users": users,
      "out_of_channel": out_of_channel,
    };
  }

  factory UserAutocompleteModel.fromEntity(UserAutocompleteEntity entity) {
    return UserAutocompleteModel(
      users: entity.users,
      out_of_channel: entity.out_of_channel,
    );
  }

  @override
  UserAutocompleteModel copyWith({
    List<Map<String, dynamic>>? users,
    List<Map<String, dynamic>>? out_of_channel,
  }) {
    return UserAutocompleteModel(
      users: users ?? this.users,
      out_of_channel: out_of_channel ?? this.out_of_channel,
    );
  }

  UserAutocompleteEntity toEntity() => UserAutocompleteEntity(
        users: users,
        out_of_channel: out_of_channel,
      );
}
