import 'package:equatable/equatable.dart';

class ChannelsWithCountEntity extends Equatable {
  final Map<String, dynamic>? channels;
  final int? total_count;

  const ChannelsWithCountEntity({
    this.channels,
    this.total_count,
  });

  @override
  List<Object?> get props => [
        channels,
        total_count,
      ];

  ChannelsWithCountEntity copyWith({
    Map<String, dynamic>? channels,
    int? total_count,
  }) {
    return ChannelsWithCountEntity(
      channels: channels ?? this.channels,
      total_count: total_count ?? this.total_count,
    );
  }
}
