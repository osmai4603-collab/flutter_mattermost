import 'package:flutter_mattermost/features/channels/domain/entities/channel_banner_entity.dart';

final class ChannelBannerModel extends ChannelBannerEntity {
  const ChannelBannerModel({
    required super.enabled,
    required super.text,
    required super.background_color,
  });

  factory ChannelBannerModel.fromMap(Map<String, dynamic> map) {
    return ChannelBannerModel(
      enabled: map["enabled"] as bool?,
      text: map["text"] as String?,
      background_color: map["background_color"] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "enabled": enabled,
      "text": text,
      "background_color": background_color,
    };
  }

  factory ChannelBannerModel.fromEntity(ChannelBannerEntity entity) {
    return ChannelBannerModel(
      enabled: entity.enabled,
      text: entity.text,
      background_color: entity.background_color,
    );
  }

  @override
  ChannelBannerModel copyWith({
    bool? enabled,
    String? text,
    String? background_color,
  }) {
    return ChannelBannerModel(
      enabled: enabled ?? this.enabled,
      text: text ?? this.text,
      background_color: background_color ?? this.background_color,
    );
  }

  ChannelBannerEntity toEntity() => ChannelBannerEntity(
        enabled: enabled,
        text: text,
        background_color: background_color,
      );
}
