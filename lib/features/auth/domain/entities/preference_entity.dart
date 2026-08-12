import 'package:flutter_mattermost/core/entities/entity.dart';

class PreferenceEntity extends Entity {
  final String serverId;
  final String userId;
  final String category;
  final String name;
  final String value;

  const PreferenceEntity({
    required this.serverId,
    required this.userId,
    required this.category,
    required this.name,
    required this.value,
  });

  @override
  List<Object?> get props => [
        serverId,
        userId,
        category,
        name,
        value,
      ];

  PreferenceEntity copyWith({
    String? serverId,
    String? userId,
    String? category,
    String? name,
    String? value,
  }) {
    return PreferenceEntity(
      serverId: serverId ?? this.serverId,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      name: name ?? this.name,
      value: value ?? this.value,
    );
  }
}
