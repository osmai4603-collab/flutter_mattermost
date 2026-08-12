import 'package:equatable/equatable.dart';

class AccessControlPolicyCursorEntity extends Equatable {
  final String? id;

  const AccessControlPolicyCursorEntity({
    this.id,
  });

  @override
  List<Object?> get props => [
        id,
      ];

  AccessControlPolicyCursorEntity copyWith({
    String? id,
  }) {
    return AccessControlPolicyCursorEntity(
      id: id ?? this.id,
    );
  }
}
