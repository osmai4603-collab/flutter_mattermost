import 'package:flutter_mattermost/features/common/domain/entities/services_response_entity.dart';

final class ServicesResponseModel extends ServicesResponseEntity {
  const ServicesResponseModel({
    required super.services,
  });

  factory ServicesResponseModel.fromMap(Map<String, dynamic> map) {
    return ServicesResponseModel(
      services: (map["services"] as List<dynamic>? ?? []).map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "services": services,
    };
  }

  factory ServicesResponseModel.fromEntity(ServicesResponseEntity entity) {
    return ServicesResponseModel(
      services: entity.services,
    );
  }

  @override
  ServicesResponseModel copyWith({
    List<Map<String, dynamic>>? services,
  }) {
    return ServicesResponseModel(
      services: services ?? this.services,
    );
  }

  ServicesResponseEntity toEntity() => ServicesResponseEntity(
        services: services,
      );
}
