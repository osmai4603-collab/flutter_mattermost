import 'package:flutter_mattermost/core/entities/entity.dart';

class TermsOfServiceEntity extends Entity {
  final String id;
  final int createAt;
  final String userId;
  final String text;

  const TermsOfServiceEntity({
    this.id = '',
    this.createAt = 0,
    this.userId = '',
    this.text = '',
  });

  @override
  List<Object?> get props => [
        id,
        createAt,
        userId,
        text,
      ];

  TermsOfServiceEntity copyWith({
    String? id,
    int? createAt,
    String? userId,
    String? text,
  }) {
    return TermsOfServiceEntity(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      userId: userId ?? this.userId,
      text: text ?? this.text,
    );
  }
}
