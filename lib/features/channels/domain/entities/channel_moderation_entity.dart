import 'package:equatable/equatable.dart';

class ChannelModerationEntity extends Equatable {
  final String? name;
  final Map<String, dynamic>? roles;

  const ChannelModerationEntity({
    this.name,
    this.roles,
  });

  @override
  List<Object?> get props => [
        name,
        roles,
      ];

  ChannelModerationEntity copyWith({
    String? name,
    Map<String, dynamic>? roles,
  }) {
    return ChannelModerationEntity(
      name: name ?? this.name,
      roles: roles ?? this.roles,
    );
  }
}
