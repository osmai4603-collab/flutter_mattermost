import 'package:equatable/equatable.dart';
import 'package:flutter_mattermost/features/chat/domain/entities/reaction_entity.dart';

/// خريطة من معرف المنشور إلى قائمة التفاعلات (PostIdToReactionsMap).
class PostIdToReactionsMapEntity extends Equatable {
  final Map<String, List<ReactionEntity>> reactions;

  const PostIdToReactionsMapEntity({
    this.reactions = const {},
  });

  @override
  List<Object?> get props => [reactions];

  PostIdToReactionsMapEntity copyWith({
    Map<String, List<ReactionEntity>>? reactions,
  }) {
    return PostIdToReactionsMapEntity(
      reactions: reactions ?? this.reactions,
    );
  }
}
