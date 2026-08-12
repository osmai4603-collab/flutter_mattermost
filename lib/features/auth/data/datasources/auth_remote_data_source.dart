import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/auth/data/models/mfa_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/session_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/terms_of_service_model.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/storage/secure_storage_service.dart';

abstract class AuthRemoteDataSource {
  Future<(UserModel, String)> login(String username, String password);
  Future<(UserModel, String)> loginWithDesktopToken(String desktopToken);
  Future<(UserModel, String)> loginWithIntune(Map<String, dynamic> credentials);
  Future<void> loginWithMagicLink(String token, {String? inviteId});
  Future<bool> switchEmailToOAuth(
    String email,
    String password,
    String authService,
  );
  Future<String> getUserLoginType(String loginId);
  Future<void> logout();
  Future<bool> checkUserMfa(String loginId);
  Future<void> updateUserMfa(String userId, bool activate, {String? code});
  Future<MfaModel> generateMfaSecret(String userId);
  Future<void> updateUserPassword(
    String userId,
    String currentPassword,
    String newPassword,
  );
  Future<void> resetUserPassword({String? token, String? newPassword});
  Future<void> sendPasswordResetEmail(String email);
  Future<void> verifyUserEmail(String token);
  Future<void> sendVerificationEmail(String email);
  Future<void> notifyAdmin(Map<String, dynamic> payload);
  Future<void> updateMyTermsOfServiceStatus(
    String userId,
    String termsOfServiceId,
    bool accepted,
  );
  Future<TermsOfServiceModel> getTermsOfService();
  Future<TermsOfServiceModel> createTermsOfService(String text);
  Future<List<SessionModel>> getSessions(String userId);
  Future<void> revokeSession(String userId, String sessionId);
  Future<void> revokeAllSessionsForUser(String userId);
  Future<void> revokeSessionsForAllUsers();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  final SecureStorageService _secureStorage;

  AuthRemoteDataSourceImpl(this._apiClient, this._secureStorage);

  @override
  Future<(UserModel, String)> login(String username, String password) async {
    final response = await _apiClient.dio.post(
      UsersEndPoint.login,
      data: {'login_id': username, 'password': password},
    );

    final token = response.headers.value('token') ?? '';
    final model = UserModel.fromMap(response.data as Map<String, dynamic>);
    // Save cookies and CSRF token from Set-Cookie headers for session-based auth
    final setCookies = response.headers.map['set-cookie'] ?? [];
    if (setCookies.isNotEmpty) {
      final cookieHeader = setCookies.map((c) => c.split(';').first).join('; ');
      await _secureStorage.saveCookies(cookieHeader);
      try {
        final mmcsrfEntry = setCookies.firstWhere(
          (c) => c.startsWith('MMCSRF='),
          orElse: () => '',
        );
        if (mmcsrfEntry.isNotEmpty) {
          final csrfVal = mmcsrfEntry.split(';').first.split('=')[1];
          await _secureStorage.saveCsrfToken(csrfVal);
        }
      } catch (_) {
        // ignore parsing errors
      }
    }
    return (model, token);
  }

  @override
  Future<(UserModel, String)> loginWithDesktopToken(
    String desktopToken,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.loginDesktopToken,
      data: {'desktop_token': desktopToken},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (UserModel.fromMap(result.data), '');
    }
    throw Exception('Failed to login with desktop token');
  }

  @override
  Future<(UserModel, String)> loginWithIntune(
    Map<String, dynamic> credentials,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      OAuthEndPoint.intune,
      data: credentials,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (UserModel.fromMap(result.data), '');
    }
    throw Exception('Failed to login with Intune');
  }

  @override
  Future<void> loginWithMagicLink(String token, {String? inviteId}) async {
    await _apiClient.post<void>(
      UsersEndPoint.loginOneTimeLink,
      data: {'token': token, 'invite_id': inviteId ?? ''},
      fromJson: (_) {},
    );
  }

  @override
  Future<bool> switchEmailToOAuth(
    String email,
    String password,
    String authService,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.loginSwitch,
      data: {'email': email, 'password': password, 'new_service': authService},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['follow_link'] as bool?) ?? false;
    }
    throw Exception('Failed to switch account type');
  }

  @override
  Future<String> getUserLoginType(String loginId) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.loginType,
      data: {'login_id': loginId},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['service'] as String?) ?? 'email';
    }
    throw Exception('Failed to get login type');
  }

  @override
  Future<void> logout() async {
    await _apiClient.post<void>(UsersEndPoint.logout, fromJson: (_) {});
  }

  @override
  Future<bool> checkUserMfa(String loginId) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.mfaCheck,
      data: {'login_id': loginId},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return (result.data['mfa_required'] as bool?) ?? false;
    }
    throw Exception('Failed to check MFA');
  }

  @override
  Future<void> updateUserMfa(
    String userId,
    bool activate, {
    String? code,
  }) async {
    await _apiClient.put<void>(
      UsersEndPoint.mfa(userId),
      data: {'activate': activate, 'code': code ?? ''},
      fromJson: (_) {},
    );
  }

  @override
  Future<MfaModel> generateMfaSecret(String userId) async {
    final result = await _apiClient.post<MfaModel>(
      UsersEndPoint.mfaGenerate(userId),
      fromJson: (json) => MfaModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<MfaModel>) {
      return result.data;
    }
    throw Exception('Failed to generate MFA secret');
  }

  @override
  Future<void> updateUserPassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    await _apiClient.put<void>(
      UsersEndPoint.password(userId),
      data: {'old_password': currentPassword, 'new_password': newPassword},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> resetUserPassword({String? token, String? newPassword}) async {
    await _apiClient.post<void>(
      UsersEndPoint.passwordReset,
      data: {'token': token ?? '', 'new_password': newPassword ?? ''},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _apiClient.post<void>(
      UsersEndPoint.passwordResetSend,
      data: {'email': email},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> verifyUserEmail(String token) async {
    await _apiClient.post<void>(
      UsersEndPoint.emailVerify,
      data: {'token': token},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> sendVerificationEmail(String email) async {
    await _apiClient.post<void>(
      UsersEndPoint.emailVerifySend,
      data: {'email': email},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> notifyAdmin(Map<String, dynamic> payload) async {
    await _apiClient.post<void>(
      UsersEndPoint.notifyAdmin,
      data: payload,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> updateMyTermsOfServiceStatus(
    String userId,
    String termsOfServiceId,
    bool accepted,
  ) async {
    await _apiClient.post<void>(
      UsersEndPoint.termsOfService(userId),
      data: {'terms_of_service_id': termsOfServiceId, 'accepted': accepted},
      fromJson: (_) {},
    );
  }

  @override
  Future<TermsOfServiceModel> getTermsOfService() async {
    final result = await _apiClient.get<TermsOfServiceModel>(
      TermsOfServiceEndPoint.root,
      fromJson: (json) =>
          TermsOfServiceModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TermsOfServiceModel>) {
      return result.data;
    }
    throw Exception('Failed to get terms of service');
  }

  @override
  Future<TermsOfServiceModel> createTermsOfService(String text) async {
    final result = await _apiClient.post<TermsOfServiceModel>(
      TermsOfServiceEndPoint.root,
      data: {'text': text},
      fromJson: (json) =>
          TermsOfServiceModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<TermsOfServiceModel>) {
      return result.data;
    }
    throw Exception('Failed to create terms of service');
  }

  @override
  Future<List<SessionModel>> getSessions(String userId) async {
    final result = await _apiClient.get<List<SessionModel>>(
      UsersEndPoint.sessions(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SessionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SessionModel>>) {
      return result.data;
    }
    throw Exception('Failed to get sessions for user $userId');
  }

  @override
  Future<void> revokeSession(String userId, String sessionId) async {
    await _apiClient.post<void>(
      UsersEndPoint.sessionsRevoke(userId),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> revokeAllSessionsForUser(String userId) async {
    await _apiClient.post<void>(
      UsersEndPoint.sessionsRevokeAll2(userId),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> revokeSessionsForAllUsers() async {
    await _apiClient.post<void>(
      UsersEndPoint.sessionsRevokeAll,
      fromJson: (_) {},
    );
  }
}
