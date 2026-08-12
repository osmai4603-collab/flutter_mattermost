import 'package:flutter_mattermost/features/auth/domain/entities/user_ath_data_entity.dart';

final class UserAthDataModel extends UserAthDataEntity {
  const UserAthDataModel({
    super.auth_data,
    super.auth_service,
  });

  factory UserAthDataModel.fromMap(Map<String, dynamic> map) {
    return UserAthDataModel(
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

  factory UserAthDataModel.fromEntity(UserAthDataEntity entity) {
    return UserAthDataModel(
      auth_data: entity.auth_data,
      auth_service: entity.auth_service,
    );
  }

  @override
  UserAthDataModel copyWith({
    String? auth_data,
    String? auth_service,
  }) {
    return UserAthDataModel(
      auth_data: auth_data ?? this.auth_data,
      auth_service: auth_service ?? this.auth_service,
    );
  }

  UserAthDataEntity toEntity() => UserAthDataEntity(
        auth_data: auth_data,
        auth_service: auth_service,
      );
}
