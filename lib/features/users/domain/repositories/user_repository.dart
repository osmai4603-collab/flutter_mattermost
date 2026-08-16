import 'package:flutter_mattermost/features/auth/domain/entities/preference_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getMyProfile();
  Future<UserEntity> getUserById(String userId);
  Future<UserEntity> getUserByUsername(String username);
  Future<UserEntity> getUserByEmail(String email);
  Future<List<UserEntity>> searchUsers(
    String term, {
    String? teamId,
    String? channelId,
  });
  Future<List<UserEntity>> autocompleteUsers(
    String term, {
    String? teamId,
    String? channelId,
  });
  Future<List<UserEntity>> getProfilesInTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<UserEntity>> getProfilesInChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<String>> getKnownUsers();
  Future<List<UserEntity>> getProfilesByIds(List<String> userIds);

  Future<List<UserStatusEntity>> getStatusesByIds(List<String> userIds);
  Future<UserStatusEntity> getStatus(String userId);
  Future<UserStatusEntity> updateMyStatus(UserStatus status, {String? dndEndTime});

  Future<List<PreferenceEntity>> getMyPreferences();
  Future<void> saveMyPreferences(List<PreferenceEntity> preferences);
  Future<void> deleteMyPreferences(List<PreferenceEntity> preferences);

  Future<UserEntity> updateMyProfile({
    String? firstName,
    String? lastName,
    String? nickname,
    String? position,
    String? locale,
  });
  Future<UserEntity> updateMyNotifyProps(Map<String, dynamic> notifyProps);
  Future<void> uploadProfileImage(String userId, String filePath);
  Future<void> updatePassword(
    String userId,
    String currentPassword,
    String newPassword,
  );
  Future<void> updateMyMfa({required bool activate, String? code});
}
