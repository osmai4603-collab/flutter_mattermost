import 'package:equatable/equatable.dart';

class UserAccessTokenSanitizedEntity extends Equatable {
  final String? id;
  final String? user_id;
  final String? description;
  final bool? is_active;

  const UserAccessTokenSanitizedEntity({
    this.id,
    this.user_id,
    this.description,
    this.is_active,
  });

  @override
  List<Object?> get props => [
        id,
        user_id,
        description,
        is_active,
      ];

  UserAccessTokenSanitizedEntity copyWith({
    String? id,
    String? user_id,
    String? description,
    bool? is_active,
  }) {
    return UserAccessTokenSanitizedEntity(
      id: id ?? this.id,
      user_id: user_id ?? this.user_id,
      description: description ?? this.description,
      is_active: is_active ?? this.is_active,
    );
  }
}
