import 'package:flutter_mattermost/features/common/domain/entities/messages_limits_entity.dart';

final class MessagesLimitsModel extends MessagesLimitsEntity {
  const MessagesLimitsModel({
    required super.history,
  });

  factory MessagesLimitsModel.fromMap(Map<String, dynamic> map) {
    return MessagesLimitsModel(
      history: (map["history"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "history": history,
    };
  }

  factory MessagesLimitsModel.fromEntity(MessagesLimitsEntity entity) {
    return MessagesLimitsModel(
      history: entity.history,
    );
  }

  @override
  MessagesLimitsModel copyWith({
    int? history,
  }) {
    return MessagesLimitsModel(
      history: history ?? this.history,
    );
  }

  MessagesLimitsEntity toEntity() => MessagesLimitsEntity(
        history: history,
      );
}
