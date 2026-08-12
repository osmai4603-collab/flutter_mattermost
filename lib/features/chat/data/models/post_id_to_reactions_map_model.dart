import 'package:flutter_mattermost/features/chat/domain/entities/post_id_to_reactions_map_entity.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';
import 'package:flutter_mattermost/features/chat/data/models/reaction_model.dart';

final class PostIdToReactionsMapModel extends PostIdToReactionsMapEntity {
  const PostIdToReactionsMapModel({
    required super.reactions,
  });

  factory PostIdToReactionsMapModel.fromMap(Map<String, dynamic> map) {
    return PostIdToReactionsMapModel(
      reactions: map.entries.fold<Map<String, List<ReactionEntity>>>(
        {},
        (acc, entry) {
          acc[entry.key] = (entry.value as List<dynamic>? ?? [])
              .map((e) => ReactionModel.fromMap(
                    Map<String, dynamic>.from(e as Map<String, dynamic>),
                  ))
              .toList();
          return acc;
        },
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return reactions.map(
      (key, value) => MapEntry(
        key,
        value
            .map((e) => ReactionModel.fromEntity(e).toMap())
            .toList(),
      ),
    );
  }

  factory PostIdToReactionsMapModel.fromEntity(
    PostIdToReactionsMapEntity entity,
  ) {
    return PostIdToReactionsMapModel(
      reactions: entity.reactions,
    );
  }

  @override
  PostIdToReactionsMapModel copyWith({
    Map<String, List<ReactionEntity>>? reactions,
  }) {
    return PostIdToReactionsMapModel(
      reactions: reactions ?? this.reactions,
    );
  }

  PostIdToReactionsMapEntity toEntity() => PostIdToReactionsMapEntity(
        reactions: reactions,
      );
}
