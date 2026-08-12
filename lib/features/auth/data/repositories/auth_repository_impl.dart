import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';
import 'package:flutter_mattermost/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final UsersRemoteDataSource _usersRemoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(
    this._remoteDataSource,
    this._usersRemoteDataSource,
    this._secureStorage,
  );

  @override
  Future<UserEntity> login(String username, String password) async {
    final (dto, token) = await _remoteDataSource.login(username, password);

    final entity = dto.toEntity();

    // حفظ الجلسة لا يجب أن يُفشل الدخول: نجاح API كافٍ لاعتماد المستخدم.

    if (token.isNotEmpty) {
      await _secureStorage.saveAuthToken(token);
    }
    await _secureStorage.saveUserId(entity.id);
    return entity;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final dto = await _usersRemoteDataSource.getMe();
    final entity = dto.toEntity();
    return entity;
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } catch (_) {
      // Ignore network failures during logout.
    }
    await _secureStorage.clearAll();
  }

  @override
  Future<void> verifyUserEmail(String token) {
    return _remoteDataSource.verifyUserEmail(token);
  }

  @override
  Future<void> sendVerificationEmail(String email) {
    return _remoteDataSource.sendVerificationEmail(email);
  }
}
