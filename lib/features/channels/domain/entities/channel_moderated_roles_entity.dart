import 'package:equatable/equatable.dart';

class ChannelModeratedRolesEntity extends Equatable {
  final Map<String, dynamic>? guests;
  final Map<String, dynamic>? members;

  const ChannelModeratedRolesEntity({
    this.guests,
    this.members,
  });

  @override
  List<Object?> get props => [
        guests,
        members,
      ];

  ChannelModeratedRolesEntity copyWith({
    Map<String, dynamic>? guests,
    Map<String, dynamic>? members,
  }) {
    return ChannelModeratedRolesEntity(
      guests: guests ?? this.guests,
      members: members ?? this.members,
    );
  }
}
