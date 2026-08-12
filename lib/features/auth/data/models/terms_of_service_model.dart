import 'package:flutter_mattermost/features/auth/domain/entities/terms_of_service_entity.dart';

final class TermsOfServiceModel extends TermsOfServiceEntity {
  const TermsOfServiceModel({
    super.id,
    super.createAt,
    super.userId,
    super.text,
  });

  factory TermsOfServiceModel.fromMap(Map<String, dynamic> data) {
    return TermsOfServiceModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      userId: data['user_id'] ?? '',
      text: data['text'] ?? '',
    );
  }

  factory TermsOfServiceModel.fromEntity(TermsOfServiceEntity entity) {
    return TermsOfServiceModel(
      id: entity.id,
      createAt: entity.createAt,
      userId: entity.userId,
      text: entity.text,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'user_id': userId,
      'text': text,
    };
  }

  @override
  TermsOfServiceModel copyWith({
    String? id,
    int? createAt,
    String? userId,
    String? text,
  }) {
    return TermsOfServiceModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      userId: userId ?? this.userId,
      text: text ?? this.text,
    );
  }

  TermsOfServiceEntity toEntity() {
    return TermsOfServiceEntity(
      id: id,
      createAt: createAt,
      userId: userId,
      text: text,
    );
  }
}
