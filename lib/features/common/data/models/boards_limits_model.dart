import 'package:flutter_mattermost/features/common/domain/entities/boards_limits_entity.dart';

final class BoardsLimitsModel extends BoardsLimitsEntity {
  const BoardsLimitsModel({
    required super.cards,
    required super.views,
  });

  factory BoardsLimitsModel.fromMap(Map<String, dynamic> map) {
    return BoardsLimitsModel(
      cards: (map["cards"] as num?)?.toInt(),
      views: (map["views"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "cards": cards,
      "views": views,
    };
  }

  factory BoardsLimitsModel.fromEntity(BoardsLimitsEntity entity) {
    return BoardsLimitsModel(
      cards: entity.cards,
      views: entity.views,
    );
  }

  @override
  BoardsLimitsModel copyWith({
    int? cards,
    int? views,
  }) {
    return BoardsLimitsModel(
      cards: cards ?? this.cards,
      views: views ?? this.views,
    );
  }

  BoardsLimitsEntity toEntity() => BoardsLimitsEntity(
        cards: cards,
        views: views,
      );
}
