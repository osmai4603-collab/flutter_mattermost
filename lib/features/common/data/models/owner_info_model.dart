import 'package:flutter_mattermost/features/common/domain/entities/owner_info_entity.dart';

final class OwnerInfoModel extends OwnerInfoEntity {
  const OwnerInfoModel({
    required super.user_id,
    required super.username,
  });

  factory OwnerInfoModel.fromMap(Map<String, dynamic> map) {
    return OwnerInfoModel(
      user_id: map["user_id"] as String?,
      username: map["username"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "username": username,
    };
  }

  factory OwnerInfoModel.fromEntity(OwnerInfoEntity entity) {
    return OwnerInfoModel(
      user_id: entity.user_id,
      username: entity.username,
    );
  }

  @override
  OwnerInfoModel copyWith({
    String? user_id,
    String? username,
  }) {
    return OwnerInfoModel(
      user_id: user_id ?? this.user_id,
      username: username ?? this.username,
    );
  }

  OwnerInfoEntity toEntity() => OwnerInfoEntity(
        user_id: user_id,
        username: username,
      );
}
