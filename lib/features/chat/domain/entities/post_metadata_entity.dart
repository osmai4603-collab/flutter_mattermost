import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/file_info_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/system/domain/entities/emoji_entity.dart';

class PostMetadataEntity extends Equatable {
  final List<Map<String, dynamic>>? embeds;
  final List<EmojiEntity>? emojis;
  final List<FileInfoEntity>? files;
  final Map<String, dynamic>? images;
  final List<ReactionEntity>? reactions;
  final dynamic priority;
  final List<Map<String, dynamic>>? acknowledgements;

  const PostMetadataEntity({
    this.embeds,
    this.emojis,
    this.files,
    this.images,
    this.reactions,
    this.priority,
    this.acknowledgements,
  });

  @override
  List<Object?> get props => [
    embeds,
    emojis,
    files,
    images,
    reactions,
    priority,
    acknowledgements,
  ];

  PostMetadataEntity copyWith({
    List<Map<String, dynamic>>? embeds,
    List<EmojiEntity>? emojis,
    List<FileInfoEntity>? files,
    Map<String, dynamic>? images,
    List<ReactionEntity>? reactions,
    dynamic priority,
    List<Map<String, dynamic>>? acknowledgements,
  }) {
    return PostMetadataEntity(
      embeds: embeds ?? this.embeds,
      emojis: emojis ?? this.emojis,
      files: files ?? this.files,
      images: images ?? this.images,
      reactions: reactions ?? this.reactions,
      priority: priority ?? this.priority,
      acknowledgements: acknowledgements ?? this.acknowledgements,
    );
  }
}
