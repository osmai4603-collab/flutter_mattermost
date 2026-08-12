import 'package:equatable/equatable.dart';

class PostMetadataEntity extends Equatable {
  final List<Map<String, dynamic>>? embeds;
  final List<Map<String, dynamic>>? emojis;
  final List<Map<String, dynamic>>? files;
  final Map<String, dynamic>? images;
  final List<Map<String, dynamic>>? reactions;
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
    List<Map<String, dynamic>>? emojis,
    List<Map<String, dynamic>>? files,
    Map<String, dynamic>? images,
    List<Map<String, dynamic>>? reactions,
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
