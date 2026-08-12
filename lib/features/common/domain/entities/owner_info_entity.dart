import 'package:equatable/equatable.dart';

class OwnerInfoEntity extends Equatable {
  final String? user_id;
  final String? username;

  const OwnerInfoEntity({
    required this.user_id,
    required this.username,
  });

  @override
  List<Object?> get props => [
        user_id,
        username,
      ];

  OwnerInfoEntity copyWith({
    String? user_id,
    String? username,
  }) {
    return OwnerInfoEntity(
      user_id: user_id ?? this.user_id,
      username: username ?? this.username,
    );
  }
}
