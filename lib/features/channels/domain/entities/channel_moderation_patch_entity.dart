import 'package:equatable/equatable.dart';

class ChannelModerationPatchEntity extends Equatable {
  final String? name;
  final Map<String, dynamic>? roles;

  const ChannelModerationPatchEntity({
    this.name,
    this.roles,
  });

  @override
  List<Object?> get props => [
        name,
        roles,
      ];

  ChannelModerationPatchEntity copyWith({
    String? name,
    Map<String, dynamic>? roles,
  }) {
    return ChannelModerationPatchEntity(
      name: name ?? this.name,
      roles: roles ?? this.roles,
    );
  }
}
