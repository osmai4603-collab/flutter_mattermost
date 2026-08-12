import 'package:flutter_mattermost/features/auth/domain/entities/user_auth_data_entity.dart';

final class UserAuthDataModel extends UserAuthDataEntity {
  const UserAuthDataModel({
    required super.auth_data,
    required super.auth_service,
  });

  factory UserAuthDataModel.fromMap(Map<String, dynamic> map) {
    return UserAuthDataModel(
      auth_data: map["auth_data"] as String?,
      auth_service: map["auth_service"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "auth_data": auth_data,
      "auth_service": auth_service,
    };
  }

  factory UserAuthDataModel.fromEntity(UserAuthDataEntity entity) {
    return UserAuthDataModel(
      auth_data: entity.auth_data,
      auth_service: entity.auth_service,
    );
  }

  @override
  UserAuthDataModel copyWith({
    String? auth_data,
    String? auth_service,
  }) {
    return UserAuthDataModel(
      auth_data: auth_data ?? this.auth_data,
      auth_service: auth_service ?? this.auth_service,
    );
  }

  UserAuthDataEntity toEntity() => UserAuthDataEntity(
        auth_data: auth_data,
        auth_service: auth_service,
      );
}
