import 'package:flutter_mattermost/features/chat/domain/entities/content_flagging_config_entity.dart';

final class ContentFlaggingConfigModel extends ContentFlaggingConfigEntity {
  const ContentFlaggingConfigModel({
    required super.EnableContentFlagging,
  });

  factory ContentFlaggingConfigModel.fromMap(Map<String, dynamic> map) {
    return ContentFlaggingConfigModel(
      EnableContentFlagging: map["EnableContentFlagging"] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "EnableContentFlagging": EnableContentFlagging,
    };
  }

  factory ContentFlaggingConfigModel.fromEntity(ContentFlaggingConfigEntity entity) {
    return ContentFlaggingConfigModel(
      EnableContentFlagging: entity.EnableContentFlagging,
    );
  }

  @override
  ContentFlaggingConfigModel copyWith({
    bool? EnableContentFlagging,
  }) {
    return ContentFlaggingConfigModel(
      EnableContentFlagging: EnableContentFlagging ?? this.EnableContentFlagging,
    );
  }

  ContentFlaggingConfigEntity toEntity() => ContentFlaggingConfigEntity(
        EnableContentFlagging: EnableContentFlagging,
      );
}
