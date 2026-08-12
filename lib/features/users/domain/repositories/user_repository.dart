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
}
