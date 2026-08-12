import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String username, String password);
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
  Future<void> verifyUserEmail(String token);
  Future<void> sendVerificationEmail(String email);
}
