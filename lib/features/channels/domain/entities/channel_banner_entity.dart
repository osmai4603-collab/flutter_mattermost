import 'package:equatable/equatable.dart';

class ChannelBannerEntity extends Equatable {
  final bool? enabled;
  final String? text;
  final String? background_color;

  const ChannelBannerEntity({
    this.enabled,
    this.text,
    this.background_color,
  });

  @override
  List<Object?> get props => [
        enabled,
        text,
        background_color,
      ];

  ChannelBannerEntity copyWith({
    bool? enabled,
    String? text,
    String? background_color,
  }) {
    return ChannelBannerEntity(
      enabled: enabled ?? this.enabled,
      text: text ?? this.text,
      background_color: background_color ?? this.background_color,
    );
  }
}
