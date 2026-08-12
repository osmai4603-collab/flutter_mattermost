import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/auth/data/models/preference_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class UserPreferencesRemoteDataSource {
  Future<List<PreferenceModel>> getPreferences(String userId);
  Future<void> savePreferences(
    String userId,
    List<PreferenceModel> preferences,
  );
  Future<void> deletePreferences(
    String userId,
    List<PreferenceModel> preferences,
  );
  Future<List<PreferenceModel>> getPreferencesByCategory(
    String userId,
    String category,
  );
  Future<PreferenceModel?> getPreferenceByName(
    String userId,
    String category,
    String preferenceName,
  );
  Future<List<PreferenceModel>> getMyPreferences();
  Future<void> saveMyPreferences(List<PreferenceModel> preferences);

  // Missing operations from docs
  Future<void> updatePreferences(String userId, List<PreferenceModel> preferences);
  Future<PreferenceModel?> getPreferencesByCategoryByName(String userId, String category, String preferenceName);
}

@LazySingleton(as: UserPreferencesRemoteDataSource)
class UserPreferencesRemoteDataSourceImpl
    implements UserPreferencesRemoteDataSource {
  final ApiClient _apiClient;

  UserPreferencesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PreferenceModel>> getPreferences(String userId) async {
    final result = await _apiClient.get<List<PreferenceModel>>(
      UsersEndPoint.preferences(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PreferenceModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PreferenceModel>>) {
      return result.data;
    }
    throw Exception('Failed to get preferences for user $userId');
  }

  @override
  Future<void> savePreferences(
    String userId,
    List<PreferenceModel> preferences,
  ) async {
    await _apiClient.put<void>(
      UsersEndPoint.preferences(userId),
      data: [
        for (final p in preferences)
          {
            'user_id': p.userId,
            'category': p.category,
            'name': p.name,
            'value': p.value,
          },
      ],
      fromJson: (_) {},
    );
  }

  @override
  Future<void> deletePreferences(
    String userId,
    List<PreferenceModel> preferences,
  ) async {
    await _apiClient.post<void>(
      UsersEndPoint.preferencesDelete(userId),
      data: [
        for (final p in preferences)
          {
            'user_id': p.userId,
            'category': p.category,
            'name': p.name,
            'value': p.value,
          },
      ],
      fromJson: (_) {},
    );
  }

  @override
  Future<List<PreferenceModel>> getPreferencesByCategory(
    String userId,
    String category,
  ) async {
    final result = await _apiClient.get<List<PreferenceModel>>(
      UsersEndPoint.preferences2(userId, category),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => PreferenceModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<PreferenceModel>>) {
      return result.data;
    }
    throw Exception('Failed to get preferences by category $category');
  }

  @override
  Future<PreferenceModel?> getPreferenceByName(
    String userId,
    String category,
    String preferenceName,
  ) async {
    final result = await _apiClient.get<PreferenceModel>(
      UsersEndPoint.preferencesName(userId, category, preferenceName),
      fromJson: (json) => PreferenceModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<PreferenceModel>) {
      return result.data;
    }
    throw Exception('Failed to get preference $preferenceName of $category');
  }

  @override
  Future<List<PreferenceModel>> getMyPreferences() => getPreferences('me');

  @override
  Future<void> saveMyPreferences(List<PreferenceModel> preferences) =>
      savePreferences('me', preferences);

  @override
  Future<void> updatePreferences(String userId, List<PreferenceModel> preferences) =>
      savePreferences(userId, preferences);

  @override
  Future<PreferenceModel?> getPreferencesByCategoryByName(String userId, String category, String preferenceName) =>
      getPreferenceByName(userId, category, preferenceName);
}
