import 'package:flutter_mattermost/features/chat/domain/entities/post_metadata_entity.dart';

final class PostMetadataModel extends PostMetadataEntity {
  const PostMetadataModel({
    required super.embeds,
    required super.emojis,
    required super.files,
    required super.images,
    required super.reactions,
    required super.priority,
    required super.acknowledgements,
  });

  factory PostMetadataModel.fromMap(Map<String, dynamic> map) {
    return PostMetadataModel(
      embeds: List<Map<String, dynamic>>.from(
        (map["embeds"] as List<dynamic>? ?? []).map(
          (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
        ),
      ),
      emojis: List<Map<String, dynamic>>.from(
        (map["emojis"] as List<dynamic>? ?? []).map(
          (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
        ),
      ),
      files: List<Map<String, dynamic>>.from(
        (map["files"] as List<dynamic>? ?? []).map(
          (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
        ),
      ),
      images: map["images"] as Map<String, dynamic>?,
      reactions: List<Map<String, dynamic>>.from(
        (map["reactions"] as List<dynamic>? ?? []).map(
          (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
        ),
      ),
      priority: map["priority"],
      acknowledgements: List<Map<String, dynamic>>.from(
        (map["acknowledgements"] as List<dynamic>? ?? []).map(
          (e) => Map<String, dynamic>.from(e as Map<String, dynamic>),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "embeds": embeds,
      "emojis": emojis,
      "files": files,
      "images": images,
      "reactions": reactions,
      "priority": priority,
      "acknowledgements": acknowledgements,
    };
  }

  factory PostMetadataModel.fromEntity(PostMetadataEntity entity) {
    return PostMetadataModel(
      embeds: entity.embeds,
      emojis: entity.emojis,
      files: entity.files,
      images: entity.images,
      reactions: entity.reactions,
      priority: entity.priority,
      acknowledgements: entity.acknowledgements,
    );
  }

  @override
  PostMetadataModel copyWith({
    List<Map<String, dynamic>>? embeds,
    List<Map<String, dynamic>>? emojis,
    List<Map<String, dynamic>>? files,
    Map<String, dynamic>? images,
    List<Map<String, dynamic>>? reactions,
    dynamic priority,
    List<Map<String, dynamic>>? acknowledgements,
  }) {
    return PostMetadataModel(
      embeds: embeds ?? this.embeds,
      emojis: emojis ?? this.emojis,
      files: files ?? this.files,
      images: images ?? this.images,
      reactions: reactions ?? this.reactions,
      priority: priority ?? this.priority,
      acknowledgements: acknowledgements ?? this.acknowledgements,
    );
  }

  PostMetadataEntity toEntity() => PostMetadataEntity(
        embeds: embeds,
        emojis: emojis,
        files: files,
        images: images,
        reactions: reactions,
        priority: priority,
        acknowledgements: acknowledgements,
      );
}
