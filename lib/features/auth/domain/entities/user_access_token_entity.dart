import 'package:flutter_mattermost/core/entities/entity.dart';

class UserAccessTokenEntity extends Entity {
  final String id;
  final String token;
  final String userId;
  final String description;
  final int createAt;
  final bool isActive;

  const UserAccessTokenEntity({
    this.id = '',
    this.token = '',
    this.userId = '',
    this.description = '',
    this.createAt = 0,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
        id,
        token,
        userId,
        description,
        createAt,
        isActive,
      ];

  UserAccessTokenEntity copyWith({
    String? id,
    String? token,
    String? userId,
    String? description,
    int? createAt,
    bool? isActive,
  }) {
    return UserAccessTokenEntity(
      id: id ?? this.id,
      token: token ?? this.token,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      createAt: createAt ?? this.createAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
