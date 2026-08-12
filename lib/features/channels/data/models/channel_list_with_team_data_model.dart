import 'package:flutter_mattermost/features/channels/domain/entities/channel_list_with_team_data_entity.dart';
import 'package:flutter_mattermost/features/channels/domain/entities/channel_with_team_data_entity.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_with_team_data_model.dart';

final class ChannelListWithTeamDataModel extends ChannelListWithTeamDataEntity {
  const ChannelListWithTeamDataModel({
    required super.items,
  });

  factory ChannelListWithTeamDataModel.fromMap(Map<String, dynamic> map) {
    return ChannelListWithTeamDataModel(
      items: (map["items"] as List<dynamic>? ?? map["channels"] as List<dynamic>? ?? [])
          .map((e) => ChannelWithTeamDataModel.fromMap(
                Map<String, dynamic>.from(e as Map<String, dynamic>),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "items": items
          .map((e) => ChannelWithTeamDataModel.fromEntity(e).toMap())
          .toList(),
    };
  }

  factory ChannelListWithTeamDataModel.fromEntity(
    ChannelListWithTeamDataEntity entity,
  ) {
    return ChannelListWithTeamDataModel(
      items: entity.items,
    );
  }

  @override
  ChannelListWithTeamDataModel copyWith({
    List<ChannelWithTeamDataEntity>? items,
  }) {
    return ChannelListWithTeamDataModel(
      items: items ?? this.items,
    );
  }

  ChannelListWithTeamDataEntity toEntity() => ChannelListWithTeamDataEntity(
        items: items,
      );
}
