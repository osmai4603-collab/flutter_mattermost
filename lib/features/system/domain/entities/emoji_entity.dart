import 'package:flutter_mattermost/core/entities/entity.dart';

class EmojiEntity extends Entity {
  final String id;
  final String name;
  final String creatorId;
  final String category;
  final int createAt;
  final int updateAt;
  final int deleteAt;

  const EmojiEntity({
    required this.id,
    required this.name,
    this.creatorId = '',
    this.category = 'custom',
    this.createAt = 0,
    this.updateAt = 0,
    this.deleteAt = 0,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        creatorId,
        category,
        createAt,
        updateAt,
        deleteAt,
      ];

  @override
  EmojiEntity copyWith({
    String? id,
    String? name,
    String? creatorId,
    String? category,
    int? createAt,
    int? updateAt,
    int? deleteAt,
  }) {
    return EmojiEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      category: category ?? this.category,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }
}
