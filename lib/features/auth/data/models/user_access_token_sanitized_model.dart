import 'package:flutter_mattermost/features/auth/domain/entities/user_access_token_sanitized_entity.dart';

final class UserAccessTokenSanitizedModel extends UserAccessTokenSanitizedEntity {
  const UserAccessTokenSanitizedModel({
    required super.id,
    required super.user_id,
    required super.description,
    required super.is_active,
  });

  factory UserAccessTokenSanitizedModel.fromMap(Map<String, dynamic> map) {
    return UserAccessTokenSanitizedModel(
      id: map["id"] as String?,
      user_id: map["user_id"] as String?,
      description: map["description"] as String?,
      is_active: map["is_active"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": user_id,
      "description": description,
      "is_active": is_active,
    };
  }

  factory UserAccessTokenSanitizedModel.fromEntity(UserAccessTokenSanitizedEntity entity) {
    return UserAccessTokenSanitizedModel(
      id: entity.id,
      user_id: entity.user_id,
      description: entity.description,
      is_active: entity.is_active,
    );
  }

  @override
  UserAccessTokenSanitizedModel copyWith({
    String? id,
    String? user_id,
    String? description,
    bool? is_active,
  }) {
    return UserAccessTokenSanitizedModel(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      description: description ?? this.description,
      is_active: is_active ?? this.is_active,
    );
  }

  UserAccessTokenSanitizedEntity toEntity() => UserAccessTokenSanitizedEntity(
        id: id,
        user_id: user_id,
        description: description,
        is_active: is_active,
      );
}
