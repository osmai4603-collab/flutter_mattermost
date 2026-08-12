import 'package:flutter_mattermost/features/auth/domain/entities/user_terms_of_service_entity.dart';

final class UserTermsOfServiceModel extends UserTermsOfServiceEntity {
  const UserTermsOfServiceModel({
    required super.user_id,
    required super.terms_of_service_id,
    required super.create_at,
  });

  factory UserTermsOfServiceModel.fromMap(Map<String, dynamic> map) {
    return UserTermsOfServiceModel(
      user_id: map["user_id"] as String?,
      terms_of_service_id: map["terms_of_service_id"] as String?,
      create_at: (map["create_at"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "user_id": user_id,
      "terms_of_service_id": terms_of_service_id,
      "create_at": create_at,
    };
  }

  factory UserTermsOfServiceModel.fromEntity(UserTermsOfServiceEntity entity) {
    return UserTermsOfServiceModel(
      user_id: entity.user_id,
      terms_of_service_id: entity.terms_of_service_id,
      create_at: entity.create_at,
    );
  }

  @override
  UserTermsOfServiceModel copyWith({
    String? user_id,
    String? terms_of_service_id,
    int? create_at,
  }) {
    return UserTermsOfServiceModel(
      user_id: user_id ?? this.user_id,
      terms_of_service_id: terms_of_service_id ?? this.terms_of_service_id,
      create_at: create_at ?? this.create_at,
    );
  }

  UserTermsOfServiceEntity toEntity() => UserTermsOfServiceEntity(
        user_id: user_id,
        terms_of_service_id: terms_of_service_id,
        create_at: create_at,
      );
}
