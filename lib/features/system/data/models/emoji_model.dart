import 'package:flutter_mattermost/features/system/domain/entities/emoji_entity.dart';

final class EmojiModel extends EmojiEntity {
  const EmojiModel({
    required super.id,
    required super.name,
    super.creatorId,
    super.category,
    super.createAt,
    super.updateAt,
    super.deleteAt,
  });

  factory EmojiModel.fromMap(Map<String, dynamic> data) {
    return EmojiModel(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      creatorId: data['creator_id'] ?? '',
      category: data['category'] ?? 'custom',
      createAt: (data['create_at'] ?? 0).toInt(),
      updateAt: (data['update_at'] ?? 0).toInt(),
      deleteAt: (data['delete_at'] ?? 0).toInt(),
    );
  }

  factory EmojiModel.fromEntity(EmojiEntity entity) {
    return EmojiModel(
      id: entity.id,
      name: entity.name,
      creatorId: entity.creatorId,
      category: entity.category,
      createAt: entity.createAt,
      updateAt: entity.updateAt,
      deleteAt: entity.deleteAt,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creator_id': creatorId,
      'category': category,
      'create_at': createAt,
      'update_at': updateAt,
      'delete_at': deleteAt,
    };
  }

  @override
  EmojiModel copyWith({
    String? id,
    String? name,
    String? creatorId,
    String? category,
    int? createAt,
    int? updateAt,
    int? deleteAt,
  }) {
    return EmojiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      creatorId: creatorId ?? this.creatorId,
      category: category ?? this.category,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      deleteAt: deleteAt ?? this.deleteAt,
    );
  }

  EmojiEntity toEntity() {
    return EmojiEntity(
      id: id,
      name: name,
      creatorId: creatorId,
      category: category,
      createAt: createAt,
      updateAt: updateAt,
      deleteAt: deleteAt,
    );
  }
}
