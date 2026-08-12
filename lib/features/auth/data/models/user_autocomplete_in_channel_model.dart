import 'package:flutter_mattermost/features/auth/domain/entities/user_autocomplete_in_channel_entity.dart';

final class UserAutocompleteInChannelModel extends UserAutocompleteInChannelEntity {
  const UserAutocompleteInChannelModel({
    required super.in_channel,
    required super.out_of_channel,
  });

  factory UserAutocompleteInChannelModel.fromMap(Map<String, dynamic> map) {
    return UserAutocompleteInChannelModel(
      in_channel: (map["in_channel"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
      out_of_channel: (map["out_of_channel"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "in_channel": in_channel,
      "out_of_channel": out_of_channel,
    };
  }

  factory UserAutocompleteInChannelModel.fromEntity(UserAutocompleteInChannelEntity entity) {
    return UserAutocompleteInChannelModel(
      in_channel: entity.in_channel,
      out_of_channel: entity.out_of_channel,
    );
  }

  @override
  UserAutocompleteInChannelModel copyWith({
    List<Map<String, dynamic>>? in_channel,
    List<Map<String, dynamic>>? out_of_channel,
  }) {
    return UserAutocompleteInChannelModel(
      in_channel: in_channel ?? this.in_channel,
      out_of_channel: out_of_channel ?? this.out_of_channel,
    );
  }

  UserAutocompleteInChannelEntity toEntity() => UserAutocompleteInChannelEntity(
        in_channel: in_channel,
        out_of_channel: out_of_channel,
      );
}
