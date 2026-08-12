// ignore_for_file: use_null_aware_elements

import 'package:flutter_mattermost/features/auth/data/models/preference_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/preference_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_entity.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/user_status_entity.dart';
import 'package:flutter_mattermost/features/users/data/datasources/user_preferences_remote_data_source.dart';
import 'package:flutter_mattermost/features/users/data/datasources/user_status_remote_data_source.dart';
import 'package:flutter_mattermost/features/users/data/datasources/users_remote_data_source.dart';
import 'package:flutter_mattermost/features/users/domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UsersRemoteDataSource _remoteDataSource;
  final UserStatusRemoteDataSource _statusDataSource;
  final UserPreferencesRemoteDataSource _preferencesDataSource;
  final Map<String, UserEntity> _profileCache = {};

  UserRepositoryImpl(
    this._remoteDataSource,
    this._statusDataSource,
    this._preferencesDataSource,
  );

  List<UserEntity> _mapAndCache(List<UserModel> models) {
    final entities = models.map((m) => m.toEntity()).toList();
    for (final entity in entities) {
      _profileCache[entity.id] = entity;
    }
    return entities;
  }

  @override
  Future<UserEntity> getMyProfile() async {
    final model = await _remoteDataSource.getMe();
    final entity = model.toEntity();
    _profileCache[entity.id] = entity;
    return entity;
  }

  @override
  Future<UserEntity> getUserById(String userId) async {
    try {
      final model = await _remoteDataSource.getUser(userId);
      final entity = model.toEntity();
      _profileCache[entity.id] = entity;
      return entity;
    } catch (_) {
      final cached = _profileCache[userId];
      if (cached != null) return cached;
      rethrow;
    }
  }

  @override
  Future<UserEntity> getUserByUsername(String username) async {
    final model = await _remoteDataSource.getUserByUsername(username);
    final entity = model.toEntity();
    _profileCache[entity.id] = entity;
    return entity;
  }

  @override
  Future<UserEntity> getUserByEmail(String email) async {
    final model = await _remoteDataSource.getUserByEmail(email);
    final entity = model.toEntity();
    _profileCache[entity.id] = entity;
    return entity;
  }

  @override
  Future<List<UserEntity>> searchUsers(
    String term, {
    String? teamId,
    String? channelId,
  }) async {
    final models = await _remoteDataSource.searchUsers({
      'term': term,
      if (teamId != null) 'team_id': teamId,
      if (channelId != null) 'channel_id': channelId,
    });
    return _mapAndCache(models);
  }

  @override
  Future<List<UserEntity>> autocompleteUsers(
    String term, {
    String? teamId,
    String? channelId,
  }) async {
    final models = await _remoteDataSource.autocompleteUsers(
      term,
      teamId: teamId,
      channelId: channelId,
    );
    return _mapAndCache(models);
  }

  @override
  Future<List<UserEntity>> getProfilesInTeam(
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final models = await _remoteDataSource.getProfilesInTeam(
      teamId,
      page: page,
      perPage: perPage,
    );
    return _mapAndCache(models);
  }

  @override
  Future<List<UserEntity>> getProfilesInChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final models = await _remoteDataSource.getProfilesInChannel(
      channelId,
      page: page,
      perPage: perPage,
    );
    return _mapAndCache(models);
  }

  @override
  Future<List<String>> getKnownUsers() => _remoteDataSource.getKnownUsers();

  @override
  Future<List<UserEntity>> getProfilesByIds(List<String> userIds) async {
    final missing = userIds
        .where((id) => !_profileCache.containsKey(id))
        .toList();
    if (missing.isNotEmpty) {
      final models = await _remoteDataSource.getProfilesByIds(missing);
      _mapAndCache(models);
    }
    return userIds.map((id) => _profileCache[id]!).toList();
  }

  @override
  Future<List<UserStatusEntity>> getStatusesByIds(List<String> userIds) async {
    final models = await _statusDataSource.getStatusesByIds(userIds);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<UserStatusEntity> getStatus(String userId) async {
    final model = await _statusDataSource.getStatus(userId);
    return model.toEntity();
  }

  @override
  Future<UserStatusEntity> updateMyStatus(
    UserStatus status, {
    String? dndEndTime,
  }) async {
    final model = await _statusDataSource.updateStatus(
      'me',
      status,
      dndEndTime: dndEndTime,
    );
    return model.toEntity();
  }

  @override
  Future<List<PreferenceEntity>> getMyPreferences() async {
    final models = await _preferencesDataSource.getPreferences('me');
    return models.map((p) => p.toEntity()).toList();
  }

  @override
  Future<void> saveMyPreferences(List<PreferenceEntity> preferences) {
    return _preferencesDataSource.saveMyPreferences([
      for (final p in preferences) PreferenceModel.fromEntity(p),
    ]);
  }
}
