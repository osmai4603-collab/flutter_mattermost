import 'package:equatable/equatable.dart';

class ChannelModeratedRoleEntity extends Equatable {
  final bool? value;
  final bool? enabled;

  const ChannelModeratedRoleEntity({
    this.value,
    this.enabled,
  });

  @override
  List<Object?> get props => [
        value,
        enabled,
      ];

  ChannelModeratedRoleEntity copyWith({
    bool? value,
    bool? enabled,
  }) {
    return ChannelModeratedRoleEntity(
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }
}
