import 'package:flutter_mattermost/features/channels/domain/entities/channels_with_count_entity.dart';

final class ChannelsWithCountModel extends ChannelsWithCountEntity {
  const ChannelsWithCountModel({
    required super.channels,
    required super.total_count,
  });

  factory ChannelsWithCountModel.fromMap(Map<String, dynamic> map) {
    return ChannelsWithCountModel(
      channels: map["channels"] as Map<String, dynamic>?,
      total_count: (map["total_count"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channels": channels,
      "total_count": total_count,
    };
  }

  factory ChannelsWithCountModel.fromEntity(ChannelsWithCountEntity entity) {
    return ChannelsWithCountModel(
      channels: entity.channels,
      total_count: entity.total_count,
    );
  }

  @override
  ChannelsWithCountModel copyWith({
    Map<String, dynamic>? channels,
    int? total_count,
  }) {
    return ChannelsWithCountModel(
      channels: channels ?? this.channels,
      total_count: total_count ?? this.total_count,
    );
  }

  ChannelsWithCountEntity toEntity() => ChannelsWithCountEntity(
        channels: channels,
        total_count: total_count,
      );
}
