import 'package:equatable/equatable.dart';

class UserTermsOfServiceEntity extends Equatable {
  final String? user_id;
  final String? terms_of_service_id;
  final int? create_at;

  const UserTermsOfServiceEntity({
    this.user_id,
    this.terms_of_service_id,
    this.create_at,
  });

  @override
  List<Object?> get props => [
        user_id,
        terms_of_service_id,
        create_at,
      ];

  UserTermsOfServiceEntity copyWith({
    String? user_id,
    String? terms_of_service_id,
    int? create_at,
  }) {
    return UserTermsOfServiceEntity(
      user_id: user_id ?? this.user_id,
      terms_of_service_id: terms_of_service_id ?? this.terms_of_service_id,
      create_at: create_at ?? this.create_at,
    );
  }
}
