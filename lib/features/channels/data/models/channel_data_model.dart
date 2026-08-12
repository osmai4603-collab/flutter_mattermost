import 'package:flutter_mattermost/features/channels/domain/entities/channel_data_entity.dart';

final class ChannelDataModel extends ChannelDataEntity {
  const ChannelDataModel({
    required super.channel,
    required super.member,
  });

  factory ChannelDataModel.fromMap(Map<String, dynamic> map) {
    return ChannelDataModel(
      channel: map["channel"] as Map<String, dynamic>?,
      member: map["member"] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "channel": channel,
      "member": member,
    };
  }

  factory ChannelDataModel.fromEntity(ChannelDataEntity entity) {
    return ChannelDataModel(
      channel: entity.channel,
      member: entity.member,
    );
  }

  @override
  ChannelDataModel copyWith({
    Map<String, dynamic>? channel,
    Map<String, dynamic>? member,
  }) {
    return ChannelDataModel(
      channel: channel ?? this.channel,
      member: member ?? this.member,
    );
  }

  ChannelDataEntity toEntity() => ChannelDataEntity(
        channel: channel,
        member: member,
      );
}
