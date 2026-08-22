import 'package:flutter_mattermost/features/auth/domain/entities/preference_entity.dart';

final class PreferenceModel extends PreferenceEntity {
  const PreferenceModel({
    required super.userId,
    required super.category,
    required super.name,
    required super.value,
  });

  factory PreferenceModel.fromMap(Map<String, dynamic> data) {
    return PreferenceModel(
      userId: data['user_id'] ?? '',
      category: data['category'] ?? '',
      name: data['name'] ?? '',
      value: data['value'] ?? '',
    );
  }

  factory PreferenceModel.fromEntity(PreferenceEntity entity) {
    return PreferenceModel(
      userId: entity.userId,
      category: entity.category,
      name: entity.name,
      value: entity.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'category': category,
      'name': name,
      'value': value,
    };
  }

  @override
  PreferenceModel copyWith({
    String? serverId,
    String? userId,
    String? category,
    String? name,
    String? value,
  }) {
    return PreferenceModel(
      userId: userId ?? this.userId,
      category: category ?? this.category,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }

  PreferenceEntity toEntity() {
    return PreferenceEntity(
      userId: userId,
      category: category,
      name: name,
      value: value,
    );
  }
}
