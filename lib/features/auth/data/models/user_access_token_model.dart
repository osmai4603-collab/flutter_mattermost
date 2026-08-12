import 'package:flutter_mattermost/features/auth/domain/entities/user_access_token_entity.dart';

final class UserAccessTokenModel extends UserAccessTokenEntity {
  const UserAccessTokenModel({
    super.id,
    super.token,
    super.userId,
    super.description,
    super.createAt,
    super.isActive,
  });

  factory UserAccessTokenModel.fromMap(Map<String, dynamic> data) {
    return UserAccessTokenModel(
      id: data['id'] ?? '',
      token: data['token'] ?? '',
      userId: data['user_id'] ?? '',
      description: data['description'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      isActive: data['is_active'] ?? true,
    );
  }

  factory UserAccessTokenModel.fromEntity(UserAccessTokenEntity entity) {
    return UserAccessTokenModel(
      id: entity.id,
      token: entity.token,
      userId: entity.userId,
      description: entity.description,
      createAt: entity.createAt,
      isActive: entity.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'token': token,
      'user_id': userId,
      'description': description,
      'create_at': createAt,
      'is_active': isActive,
    };
  }

  @override
  UserAccessTokenModel copyWith({
    String? id,
    String? token,
    String? userId,
    String? description,
    int? createAt,
    bool? isActive,
  }) {
    return UserAccessTokenModel(
      id: id ?? this.id,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      createAt: createAt ?? this.createAt,
      isActive: isActive ?? this.isActive,
    );
  }

  UserAccessTokenEntity toEntity() {
    return UserAccessTokenEntity(
      id: id,
      token: token,
      userId: userId,
      description: description,
      createAt: createAt,
      isActive: isActive,
    );
  }
}
