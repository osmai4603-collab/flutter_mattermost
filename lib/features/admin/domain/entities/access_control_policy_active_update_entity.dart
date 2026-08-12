import 'package:equatable/equatable.dart';

class AccessControlPolicyActiveUpdateEntity extends Equatable {
  final String? id;
  final bool? active;

  const AccessControlPolicyActiveUpdateEntity({
    this.id,
    this.active,
  });

  @override
  List<Object?> get props => [
        id,
        active,
      ];

  AccessControlPolicyActiveUpdateEntity copyWith({
    String? id,
    bool? active,
  }) {
    return AccessControlPolicyActiveUpdateEntity(
      id: id ?? this.id,
      active: active ?? this.active,
    );
  }
}
