import 'package:equatable/equatable.dart';

class DataRetentionPolicyForChannelEntity extends Equatable {
  final String? channel_id;
  final int? post_duration;

  const DataRetentionPolicyForChannelEntity({
    this.channel_id,
    this.post_duration,
  });

  @override
  List<Object?> get props => [
        channel_id,
        post_duration,
      ];

  DataRetentionPolicyForChannelEntity copyWith({
    String? channel_id,
    int? post_duration,
  }) {
    return DataRetentionPolicyForChannelEntity(
      channel_id: channel_id ?? this.channel_id,
      post_duration: post_duration ?? this.post_duration,
    );
  }
}
