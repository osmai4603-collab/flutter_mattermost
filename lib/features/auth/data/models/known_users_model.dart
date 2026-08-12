import 'package:flutter_mattermost/features/auth/domain/entities/known_users_entity.dart';

final class KnownUsersModel extends KnownUsersEntity {
  const KnownUsersModel({
    required super.items,
  });

  factory KnownUsersModel.fromMap(Map<String, dynamic> map) {
    return KnownUsersModel(
      items: map["items"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "items": items,
    };
  }

  factory KnownUsersModel.fromEntity(KnownUsersEntity entity) {
    return KnownUsersModel(
      items: entity.items,
    );
  }

  @override
  KnownUsersModel copyWith({
    String? items,
  }) {
    return KnownUsersModel(
      items: items ?? this.items,
    );
  }

  KnownUsersEntity toEntity() => KnownUsersEntity(
        items: items,
      );
}
