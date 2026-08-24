import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_value_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/upload_session_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_terms_of_service_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/users_stats_model.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_access_token_sanitized_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_status_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/audit_model.dart';
import 'package:flutter_mattermost/features/chat/data/models/draft_model.dart';
import 'package:flutter_mattermost/features/integrations/data/models/oauth_app_model.dart';
import 'package:flutter_mattermost/features/users/data/models/thread_read_state_model.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

/// نتيجة إكمال المستخدمين — مطابقة استجابة
/// `GET /users/autocomplete`: قائمة المستخدمين + معرّفات من هم خارج القناة
/// (`out_of_channel`) لتحديد أولوية أعضاء القناة في القائمة المسدلة.
typedef AutocompleteUsersResult = ({
  List<UserModel> users,
  Set<String> outOfChannelIds,
});

abstract class UsersRemoteDataSource {
  Future<List<UserModel>> getProfiles({int page = 0, int perPage = 60});
  Future<UserModel> createUser({
    required String email,
    required String username,
    String? firstName,
    String? lastName,
    String? nickname,
    String? password,
    String? locale,
  });
  Future<List<UserModel>> autocompleteUsers(
    String term, {
    String? teamId,
    String? channelId,
  });
  Future<AutocompleteUsersResult> autocompleteUsersWithOutOfChannel(
    String term, {
    String? teamId,
    String? channelId,
  });
  Future<UserModel> getUserByEmail(String email);
  Future<List<UserModel>> getProfilesByIds(List<String> userIds);
  Future<List<UserModel>> getProfilesByUsernames(List<String> usernames);
  Future<UserModel> getUserByUsername(String username);
  Future<UserModel> getMe();
  Future<UserModel> patchMe({
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? locale,
    UserNotifyPropsModel? notifyProps,
  });
  Future<UserModel> getUser(String userId);
  Future<UserModel> getUserByAuthData(String value);
  Future<UserModel> updateUser(
    String userId, {
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? locale,
    String? roles,
  });
  Future<UserModel> patchUser(
    String userId, {
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? locale,
    Map<String, dynamic>? notifyProps,
  });
  Future<UserModel> updateUserAuth(
    String userId, {
    required String authData,
    String? password,
    String? authService,
  });
  Future<UserModel> updateUserRoles(String userId, List<String> roles);
  Future<UserModel> updateUserActive(String userId, bool active);
  Future<List<UserModel>> searchUsers(Map<String, dynamic> searchParams);
  Future<void> deleteUser(String userId);
  Future<void> permanentDeleteAllUsers();
  Future<UsersStatsModel> getTotalUsersStats();
  Future<UsersStatsModel> getFilteredUsersStats();
  Future<List<AuditModel>> getUserAudits(String userId);
  Future<UserModel> demoteUserToGuest(String userId);
  Future<UserModel> promoteGuestToUser(String userId);
  Future<void> resetFailedAttempts(String userId);
  Future<void> uploadProfileImage(String userId, String filePath);
  Future<List<UserModel>> getProfilesInTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
    String? roles,
  });
  Future<List<UserModel>> getProfilesNotInTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<UserModel>> getProfilesInChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    String? sort,
  });
  Future<List<UserModel>> getProfilesNotInChannel(
    String teamId,
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<UserModel>> getProfilesWithoutTeam({
    int page = 0,
    int perPage = 60,
  });
  Future<List<String>> getKnownUsers();
  Future<Map<String, List<String>>> getUsersByGroupChannelIds(
    List<String> groupChannelIds,
  );
  Future<void> verifyUserEmail(String token);
  Future<void> sendVerificationEmail(String email);
  Future<Map<String, dynamic>> checkUserMfa(String email);
  Future<Map<String, dynamic>> generateMfaSecret();
  Future<void> updateUserMfa(
    String userId, {
    required bool activate,
    String? code,
  });
  Future<void> updatePassword(
    String userId, {
    required String currentPassword,
    required String newPassword,
  });
  Future<Map<String, dynamic>> switchLogin(Map<String, dynamic> switchRequest);
  Future<UserTermsOfServiceModel> getUserTermsOfService(String userId);
  Future<UserTermsOfServiceModel> registerTermsOfServiceAction(
    String userId, {
    required bool accepted,
    String? termsOfServiceId,
  });
  Future<UserModel> convertUserToBot(String userId);
  Future<List<CustomAttributeValueModel>> getUserCustomProfileAttributes(
    String userId,
  );
  Future<void> deleteProfileImage(String userId);
  Future<void> resetPasswordByEmail(String email);
  Future<List<UserStatusModel>> getUserStatusCustomRecent(String userId);
  Future<List<UserAccessTokenSanitizedModel>> getUserAccessTokens({
    int page = 0,
    int perPage = 60,
  });
  Future<List<OAuthAppModel>> getOAuthAppsAuthorized(String userId);
  Future<void> updateSessionDevice({required String deviceId});
  Future<List<UploadSessionModel>> getUserUploads(String userId);
  Future<List<UserAccessTokenSanitizedModel>> searchUserTokens(
    String userId,
    Map<String, dynamic> search,
  );
  Future<void> verifyMemberEmail(String userId);
  Future<void> triggerNotifyAdminPosts(String userId);
  Future<Map<String, dynamic>> getChannelUnreadCounts(
    String userId,
    String channelId,
  );
  Future<List<ThreadReadStateModel>> getThreadsReadState(
    String userId,
    String teamId,
  );
  Future<List<DraftModel>> getChannelDrafts(String userId, String channelId);
  Future<Map<String, dynamic>> updateChannelDraft(
    String userId,
    String channelId,
    String threadId,
    Map<String, dynamic> draft,
  );
  Future<List<String>> checkInvalidEmails(List<String> emails);
  Future<UserModel> setUserAuthData(
    String userId, {
    required String authData,
    String? authService,
  });
  Future<Uint8List> getDefaultProfileImage(String userId);
  Future<UserModel> loginWithCws(Map<String, dynamic> data);
  Future<UserModel> loginSsoCodeExchange(Map<String, dynamic> data);
  Future<Map<String, dynamic>> migrateAuthLdap(Map<String, dynamic> data);
  Future<Map<String, dynamic>> migrateAuthSaml(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getSessionsAttributesManifest();

  // Missing operations from docs
  Future<String> getUserLoginType(String loginId);
  Future<void> publishUserTyping(
    String userId,
    String channelId, {
    String? parentId,
  });
  Future<void> attachDeviceExtraProps(Map<String, dynamic> props);
  Future<void> resetPasswordFailedAttempts(String userId);
  Future<void> revokeSessionsFromAllUsers();
  Future<void> verifyUserEmailWithoutToken(String userId);
}

@LazySingleton(as: UsersRemoteDataSource)
class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final ApiClient _apiClient;

  UsersRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<UserModel>> getProfiles({int page = 0, int perPage = 60}) async {
    final result = await _apiClient.get<List<UserModel>>(
      UsersEndPoint.base,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles');
  }

  @override
  Future<UserModel> createUser({
    required String email,
    required String username,
    String? firstName,
    String? lastName,
    String? nickname,
    String? password,
    String? locale,
  }) async {
    final result = await _apiClient.post<UserModel>(
      UsersEndPoint.base,
      data: {
        'email': email,
        'username': username,
        'first_name': ?firstName,
        'last_name': ?lastName,
        'nickname': ?nickname,
        'password': ?password,
        'locale': ?locale,
      },
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to create user');
  }

  @override
  Future<List<UserModel>> autocompleteUsers(
    String term, {
    String? teamId,
    String? channelId,
  }) async {
    final result = await autocompleteUsersWithOutOfChannel(
      term,
      teamId: teamId,
      channelId: channelId,
    );
    return result.users;
  }

  @override
  Future<AutocompleteUsersResult> autocompleteUsersWithOutOfChannel(
    String term, {
    String? teamId,
    String? channelId,
  }) async {
    final result = await _apiClient.get<AutocompleteUsersResult>(
      UsersEndPoint.autocomplete,
      queryParameters: {
        'term': term,
        'team_id': ?teamId,
        'channel_id': ?channelId,
      },
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        final users = data['users'] as List<dynamic>? ?? [];
        return (
          users: users
              .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
              .toList(),
          outOfChannelIds: (data['out_of_channel'] as List<dynamic>? ?? [])
              .cast<String>()
              .toSet(),
        );
      },
    );
    if (result is ApiSuccess<AutocompleteUsersResult>) {
      return result.data;
    }
    throw Exception('Failed to autocomplete users');
  }

  @override
  Future<UserModel> getUserByEmail(String email) async {
    final result = await _apiClient.get<UserModel>(
      UsersEndPoint.email(email),
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to get user by email');
  }

  @override
  Future<List<UserModel>> getProfilesByIds(List<String> userIds) async {
    final result = await _apiClient.post<List<UserModel>>(
      UsersEndPoint.ids,
      data: userIds,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles by ids');
  }

  @override
  Future<List<UserModel>> getProfilesByUsernames(List<String> usernames) async {
    final result = await _apiClient.post<List<UserModel>>(
      UsersEndPoint.usernames,
      data: usernames,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles by usernames');
  }

  @override
  Future<UserModel> getUserByUsername(String username) async {
    final result = await _apiClient.get<UserModel>(
      UsersEndPoint.username(username),
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to get user by username');
  }

  @override
  Future<UserModel> getMe() async {
    final result = await _apiClient.get<UserModel>(
      UsersEndPoint.byUserId('me'),
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to get current user');
  }

  @override
  Future<UserModel> patchMe({
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? locale,
    UserNotifyPropsModel? notifyProps,
  }) async {
    final result = await _apiClient.put<UserModel>(
      UsersEndPoint.patch('me'),
      data: {
        'first_name': ?firstName,
        'last_name': ?lastName,
        'nickname': ?nickname,
        'position': ?position,
        'locale': ?locale,
        'notify_props': notifyProps?.toMap(),
      },
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to patch current user');
  }

  @override
  Future<UserModel> getUserByAuthData(String value) async {
    final result = await _apiClient.get<UserModel>(
      UsersEndPoint.byAuthData,
      queryParameters: {'value': value},
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to get user by auth data');
  }

  @override
  Future<UserModel> getUser(String userId) async {
    final result = await _apiClient.get<UserModel>(
      UsersEndPoint.byUserId(userId),
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to get user $userId');
  }

  @override
  Future<UserModel> updateUser(
    String userId, {
    required String username,
    required String email,
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? locale,
    String? roles,
  }) async {
    final result = await _apiClient.put<UserModel>(
      UsersEndPoint.byUserId(userId),
      data: {
        'id': userId,
        'username': username,
        'email': email,
        'first_name': ?firstName,
        'last_name': ?lastName,
        'nickname': ?nickname,
        'position': ?position,
        'locale': ?locale,
        'roles': ?roles,
      },
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to update user $userId');
  }

  @override
  Future<UserModel> patchUser(
    String userId, {
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? locale,
    Map<String, dynamic>? notifyProps,
  }) async {
    final result = await _apiClient.put<UserModel>(
      UsersEndPoint.patch(userId),
      data: {
        'first_name': ?firstName,
        'last_name': ?lastName,
        'nickname': ?nickname,
        'position': ?position,
        'locale': ?locale,
        'notify_props': ?notifyProps,
      },
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to patch user $userId');
  }

  @override
  Future<UserModel> updateUserAuth(
    String userId, {
    required String authData,
    String? password,
    String? authService,
  }) async {
    final result = await _apiClient.put<UserModel>(
      UsersEndPoint.auth(userId),
      data: {
        'auth_data': authData,
        'password': ?password,
        'auth_service': ?authService,
      },
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to update auth for user $userId');
  }

  @override
  Future<UserModel> updateUserRoles(String userId, List<String> roles) async {
    final result = await _apiClient.put<UserModel>(
      UsersEndPoint.roles(userId),
      data: {'roles': roles.join(',')},
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to update roles for user $userId');
  }

  @override
  Future<UserModel> updateUserActive(String userId, bool active) async {
    final result = await _apiClient.put<UserModel>(
      UsersEndPoint.active(userId),
      data: {'active': active},
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to update active state for user $userId');
  }

  @override
  Future<List<UserModel>> searchUsers(Map<String, dynamic> searchParams) async {
    final result = await _apiClient.post<List<UserModel>>(
      UsersEndPoint.search,
      data: searchParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to search users');
  }

  @override
  Future<void> deleteUser(String userId) async {
    final result = await _apiClient.delete(UsersEndPoint.byUserId(userId));
    if (result is ApiFailure) {
      throw Exception('Failed to delete user $userId');
    }
  }

  @override
  Future<void> permanentDeleteAllUsers() async {
    final result = await _apiClient.delete(UsersEndPoint.base);
    if (result is ApiFailure) {
      throw Exception('Failed to permanent delete all users');
    }
  }

  @override
  Future<UsersStatsModel> getTotalUsersStats() async {
    final result = await _apiClient.get<UsersStatsModel>(
      UsersEndPoint.stats,
      fromJson: (json) => UsersStatsModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UsersStatsModel>) {
      return result.data;
    }
    throw Exception('Failed to get total users stats');
  }

  @override
  Future<UsersStatsModel> getFilteredUsersStats() async {
    final result = await _apiClient.get<UsersStatsModel>(
      UsersEndPoint.statsFiltered,
      fromJson: (json) => UsersStatsModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UsersStatsModel>) {
      return result.data;
    }
    throw Exception('Failed to get filtered users stats');
  }

  @override
  Future<List<AuditModel>> getUserAudits(String userId) async {
    final result = await _apiClient.get<List<AuditModel>>(
      UsersEndPoint.audits(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AuditModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AuditModel>>) {
      return result.data;
    }
    throw Exception('Failed to get audits for user $userId');
  }

  @override
  Future<UserModel> demoteUserToGuest(String userId) async {
    final result = await _apiClient.post<UserModel>(
      UsersEndPoint.demote(userId),
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to demote user $userId');
  }

  @override
  Future<UserModel> promoteGuestToUser(String userId) async {
    final result = await _apiClient.post<UserModel>(
      UsersEndPoint.promote(userId),
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to promote user $userId');
  }

  @override
  Future<void> resetFailedAttempts(String userId) async {
    await _apiClient.post<void>(
      UsersEndPoint.resetFailedAttempts(userId),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> uploadProfileImage(String userId, String filePath) async {
    final formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(filePath),
    });
    await _apiClient.dio.put(
      UsersEndPoint.image(userId),
      data: formData,
      options: Options(headers: {'Content-Type': 'multipart/form-data'}),
    );
  }

  @override
  Future<List<UserModel>> getProfilesInTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
    String? roles,
  }) async {
    final result = await _apiClient.get<List<UserModel>>(
      UsersEndPoint.base,
      queryParameters: {
        'in_team': teamId,
        'page': page,
        'per_page': perPage,
        'roles': ?roles,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles in team $teamId');
  }

  @override
  Future<List<UserModel>> getProfilesNotInTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<UserModel>>(
      UsersEndPoint.base,
      queryParameters: {
        'not_in_team': teamId,
        'page': page,
        'per_page': perPage,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles not in team $teamId');
  }

  @override
  Future<List<UserModel>> getProfilesInChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
    String? sort,
  }) async {
    final result = await _apiClient.get<List<UserModel>>(
      UsersEndPoint.base,
      queryParameters: {
        'in_channel': channelId,
        'page': page,
        'per_page': perPage,
        'sort': ?sort,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles in channel $channelId');
  }

  @override
  Future<List<UserModel>> getProfilesNotInChannel(
    String teamId,
    String channelId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<UserModel>>(
      UsersEndPoint.base,
      queryParameters: {
        'not_in_channel': channelId,
        'in_team': teamId,
        'page': page,
        'per_page': perPage,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles not in channel $channelId');
  }

  @override
  Future<List<UserModel>> getProfilesWithoutTeam({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<UserModel>>(
      UsersEndPoint.base,
      queryParameters: {'without_team': 1, 'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserModel>>) {
      return result.data;
    }
    throw Exception('Failed to get profiles without team');
  }

  @override
  Future<List<String>> getKnownUsers() async {
    final result = await _apiClient.get<List<String>>(
      UsersEndPoint.known,
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get known users');
  }

  @override
  Future<Map<String, List<String>>> getUsersByGroupChannelIds(
    List<String> groupChannelIds,
  ) async {
    final result = await _apiClient.post<Map<String, List<String>>>(
      UsersEndPoint.groupChannels,
      data: groupChannelIds,
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return data.map(
          (key, value) =>
              MapEntry(key, (value as List<dynamic>).cast<String>()),
        );
      },
    );
    if (result is ApiSuccess<Map<String, List<String>>>) {
      return result.data;
    }
    throw Exception('Failed to get users by group channel ids');
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
  Future<Map<String, dynamic>> checkUserMfa(String email) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.mfaCheck,
      data: {'login_id': email},
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to check MFA for user');
  }

  @override
  Future<Map<String, dynamic>> generateMfaSecret() async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.mfaGenerate('me'),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to generate MFA secret');
  }

  @override
  Future<void> updateUserMfa(
    String userId, {
    required bool activate,
    String? code,
  }) async {
    await _apiClient.put<void>(
      UsersEndPoint.mfa(userId),
      data: {'activate': activate, 'code': ?code},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> updatePassword(
    String userId, {
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.put<void>(
      UsersEndPoint.password(userId),
      data: {'old_password': currentPassword, 'new_password': newPassword},
      fromJson: (_) {},
    );
  }

  @override
  Future<Map<String, dynamic>> switchLogin(
    Map<String, dynamic> switchRequest,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.loginSwitch,
      data: switchRequest,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to switch login');
  }

  @override
  Future<UserTermsOfServiceModel> getUserTermsOfService(String userId) async {
    final result = await _apiClient.get<UserTermsOfServiceModel>(
      UsersEndPoint.termsOfService(userId),
      fromJson: (json) =>
          UserTermsOfServiceModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserTermsOfServiceModel>) {
      return result.data;
    }
    throw Exception('Failed to get terms of service for user $userId');
  }

  @override
  Future<UserTermsOfServiceModel> registerTermsOfServiceAction(
    String userId, {
    required bool accepted,
    String? termsOfServiceId,
  }) async {
    final result = await _apiClient.post<UserTermsOfServiceModel>(
      UsersEndPoint.termsOfService(userId),
      data: {
        'accepted': accepted,
        'terms_of_service_id': termsOfServiceId ?? '',
      },
      fromJson: (json) =>
          UserTermsOfServiceModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserTermsOfServiceModel>) {
      return result.data;
    }
    throw Exception('Failed to register terms of service action');
  }

  @override
  Future<UserModel> convertUserToBot(String userId) async {
    final result = await _apiClient.post<UserModel>(
      UsersEndPoint.convertToBot(userId),
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to convert user $userId to bot');
  }

  @override
  Future<List<CustomAttributeValueModel>> getUserCustomProfileAttributes(
    String userId,
  ) async {
    final result = await _apiClient.get<List<CustomAttributeValueModel>>(
      UsersEndPoint.customProfileAttributes(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => CustomAttributeValueModel.fromMap(e as Map<String, dynamic>),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<CustomAttributeValueModel>>) {
      return result.data;
    }
    throw Exception('Failed to get custom profile attributes for $userId');
  }

  @override
  Future<void> deleteProfileImage(String userId) async {
    await _apiClient.delete(UsersEndPoint.image(userId));
  }

  @override
  Future<void> resetPasswordByEmail(String email) async {
    await _apiClient.post<void>(
      UsersEndPoint.passwordResetSend,
      data: {'email': email},
      fromJson: (_) {},
    );
  }

  @override
  Future<List<UserStatusModel>> getUserStatusCustomRecent(String userId) async {
    final result = await _apiClient.get<List<UserStatusModel>>(
      UsersEndPoint.statusCustomRecent(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UserStatusModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UserStatusModel>>) {
      return result.data;
    }
    throw Exception('Failed to get custom statuses');
  }

  @override
  Future<List<UserAccessTokenSanitizedModel>> getUserAccessTokens({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<UserAccessTokenSanitizedModel>>(
      UsersEndPoint.tokens,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => UserAccessTokenSanitizedModel.fromMap(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<UserAccessTokenSanitizedModel>>) {
      return result.data;
    }
    throw Exception('Failed to get user access tokens');
  }

  @override
  Future<List<OAuthAppModel>> getOAuthAppsAuthorized(String userId) async {
    final result = await _apiClient.get<List<OAuthAppModel>>(
      UsersEndPoint.oauthAppsAuthorized(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => OAuthAppModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<OAuthAppModel>>) {
      return result.data;
    }
    throw Exception('Failed to get authorized OAuth apps');
  }

  @override
  Future<void> updateSessionDevice({required String deviceId}) async {
    final result = await _apiClient.put<void>(
      UsersEndPoint.sessionsDevice,
      data: {'device_id': deviceId},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to update session device');
    }
  }

  @override
  Future<List<UploadSessionModel>> getUserUploads(String userId) async {
    final result = await _apiClient.get<List<UploadSessionModel>>(
      UsersEndPoint.uploads(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => UploadSessionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<UploadSessionModel>>) {
      return result.data;
    }
    throw Exception('Failed to get user uploads');
  }

  @override
  Future<List<UserAccessTokenSanitizedModel>> searchUserTokens(
    String userId,
    Map<String, dynamic> search,
  ) async {
    final result = await _apiClient.post<List<UserAccessTokenSanitizedModel>>(
      UsersEndPoint.tokensSearch,
      data: search,
      fromJson: (json) => (json as List<dynamic>)
          .map(
            (e) => UserAccessTokenSanitizedModel.fromMap(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
    if (result is ApiSuccess<List<UserAccessTokenSanitizedModel>>) {
      return result.data;
    }
    throw Exception('Failed to search user tokens');
  }

  @override
  Future<void> verifyMemberEmail(String userId) async {
    final result = await _apiClient.post<void>(
      UsersEndPoint.emailVerifyMember(userId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to verify member email');
    }
  }

  @override
  Future<void> triggerNotifyAdminPosts(String userId) async {
    final result = await _apiClient.post<void>(
      UsersEndPoint.triggerNotifyAdminPosts,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to trigger notify admin');
    }
  }

  @override
  Future<Map<String, dynamic>> getChannelUnreadCounts(
    String userId,
    String channelId,
  ) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsersEndPoint.channelsUnread(userId, channelId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get channel unread counts');
  }

  @override
  Future<List<ThreadReadStateModel>> getThreadsReadState(
    String userId,
    String teamId,
  ) async {
    final result = await _apiClient.get<List<ThreadReadStateModel>>(
      UsersEndPoint.teamsThreadsRead(userId, teamId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ThreadReadStateModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ThreadReadStateModel>>) {
      return result.data;
    }
    throw Exception('Failed to get threads read state');
  }

  @override
  Future<List<DraftModel>> getChannelDrafts(
    String userId,
    String channelId,
  ) async {
    final result = await _apiClient.get<List<DraftModel>>(
      UsersEndPoint.channelsDrafts(userId, channelId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => DraftModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<DraftModel>>) {
      return result.data;
    }
    throw Exception('Failed to get channel drafts');
  }

  @override
  Future<Map<String, dynamic>> updateChannelDraft(
    String userId,
    String channelId,
    String threadId,
    Map<String, dynamic> draft,
  ) async {
    final result = await _apiClient.put<Map<String, dynamic>>(
      UsersEndPoint.channelsDrafts2(userId, channelId, threadId),
      data: draft,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to update channel draft');
  }

  @override
  Future<List<String>> checkInvalidEmails(List<String> emails) async {
    final result = await _apiClient.post<List<String>>(
      UsersEndPoint.invalidEmails,
      data: emails,
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to check invalid emails');
  }

  @override
  Future<UserModel> setUserAuthData(
    String userId, {
    required String authData,
    String? authService,
  }) async {
    final result = await _apiClient.post<UserModel>(
      UsersEndPoint.authData(userId),
      data: {'auth_data': authData, 'auth_service': ?authService},
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to set user auth data');
  }

  @override
  Future<Uint8List> getDefaultProfileImage(String userId) async {
    final response = await _apiClient.dio.get(
      UsersEndPoint.imageDefault(userId),
      options: Options(responseType: ResponseType.bytes),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to get default profile image');
    }
    return response.data as Uint8List;
  }

  @override
  Future<UserModel> loginWithCws(Map<String, dynamic> data) async {
    final result = await _apiClient.post<UserModel>(
      UsersEndPoint.loginCws,
      data: data,
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to login with CWS token');
  }

  @override
  Future<UserModel> loginSsoCodeExchange(Map<String, dynamic> data) async {
    final result = await _apiClient.post<UserModel>(
      UsersEndPoint.loginSsoCodeExchange,
      data: data,
      fromJson: (json) => UserModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<UserModel>) {
      return result.data;
    }
    throw Exception('Failed to exchange SSO code');
  }

  @override
  Future<Map<String, dynamic>> migrateAuthLdap(
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.migrateAuthLdap,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to migrate auth to LDAP');
  }

  @override
  Future<Map<String, dynamic>> migrateAuthSaml(
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      UsersEndPoint.migrateAuthSaml,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to migrate auth to SAML');
  }

  @override
  Future<Map<String, dynamic>> getSessionsAttributesManifest() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsersEndPoint.sessionsAttributesManifest,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get sessions attributes manifest');
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
  Future<void> publishUserTyping(
    String userId,
    String channelId, {
    String? parentId,
  }) async {
    await _apiClient.post<void>(
      UsersEndPoint.typing(userId),
      data: {'channel_id': channelId, 'parent_id': ?parentId},
      fromJson: (_) {},
    );
  }

  @override
  Future<void> attachDeviceExtraProps(Map<String, dynamic> props) async {
    await _apiClient.put<void>(
      UsersEndPoint.sessionsDevice,
      data: props,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> resetPasswordFailedAttempts(String userId) async {
    await _apiClient.post<void>(
      UsersEndPoint.resetFailedAttempts(userId),
      fromJson: (_) {},
    );
  }

  @override
  Future<void> revokeSessionsFromAllUsers() async {
    await _apiClient.post<void>(
      UsersEndPoint.sessionsRevokeAll,
      fromJson: (_) {},
    );
  }

  @override
  Future<void> verifyUserEmailWithoutToken(String userId) async {
    await _apiClient.post<void>(
      UsersEndPoint.emailVerifyMember(userId),
      fromJson: (_) {},
    );
  }
}
