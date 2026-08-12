/// بيانات مصادقة المستخدم (UserAthData):
/// auth_data و auth_service للمصادقة الخارجية.
class UserAthDataEntity {
  final String? auth_data;
  final String? auth_service;

  const UserAthDataEntity({
    this.auth_data,
    this.auth_service,
  });

  UserAthDataEntity copyWith({
    String? auth_data,
    String? auth_service,
  }) {
    return UserAthDataEntity(
      auth_data: auth_data ?? this.auth_data,
      auth_service: auth_service ?? this.auth_service,
    );
  }
}
