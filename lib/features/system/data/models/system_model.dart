import 'package:flutter_mattermost/features/system/domain/entities/system_entity.dart';

final class SystemModel extends SystemEntity {
  const SystemModel({
    required super.name,
    required super.value,
  });

  factory SystemModel.fromMap(Map<String, dynamic> map) {
    return SystemModel(
      name: map["name"] as String?,
      value: map["value"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "value": value,
    };
  }

  factory SystemModel.fromEntity(SystemEntity entity) {
    return SystemModel(
      name: entity.name,
      value: entity.value,
    );
  }

  @override
  SystemModel copyWith({
    String? name,
    String? value,
  }) {
    return SystemModel(
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  SystemEntity toEntity() => SystemEntity(
        name: name,
        value: value,
      );
}
