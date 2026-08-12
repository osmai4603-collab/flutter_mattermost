import 'package:equatable/equatable.dart';

class ChannelModeratedRolesPatchEntity extends Equatable {
  final bool? guests;
  final bool? members;

  const ChannelModeratedRolesPatchEntity({
    this.guests,
    this.members,
  });

  @override
  List<Object?> get props => [
        guests,
        members,
      ];

  ChannelModeratedRolesPatchEntity copyWith({
    bool? guests,
    bool? members,
  }) {
    return ChannelModeratedRolesPatchEntity(
      guests: guests ?? this.guests,
      members: members ?? this.members,
    );
  }
}
