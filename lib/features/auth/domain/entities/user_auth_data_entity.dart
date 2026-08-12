import 'package:equatable/equatable.dart';

class UserAuthDataEntity extends Equatable {
  final String? auth_data;
  final String? auth_service;

  const UserAuthDataEntity({
    this.auth_data,
    required this.auth_service,
  });

  @override
  List<Object?> get props => [
        auth_data,
        auth_service,
      ];

  UserAuthDataEntity copyWith({
    String? auth_data,
    String? auth_service,
  }) {
    return UserAuthDataEntity(
      auth_data: auth_data ?? this.auth_data,
      auth_service: auth_service ?? this.auth_service,
    );
  }
}
