import 'package:equatable/equatable.dart';

class ChannelDataEntity extends Equatable {
  final Map<String, dynamic>? channel;
  final Map<String, dynamic>? member;

  const ChannelDataEntity({
    this.channel,
    this.member,
  });

  @override
  List<Object?> get props => [
        channel,
        member,
      ];

  ChannelDataEntity copyWith({
    Map<String, dynamic>? channel,
    Map<String, dynamic>? member,
  }) {
    return ChannelDataEntity(
      channel: channel ?? this.channel,
      member: member ?? this.member,
    );
  }
}
