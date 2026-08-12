import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/channels/data/models/channel_category_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class ChannelCategoriesRemoteDataSource {
  Future<List<ChannelCategoryModel>> getChannelCategories(
    String userId,
    String teamId,
  );
  Future<ChannelCategoryModel> createChannelCategory(
    String userId,
    String teamId, {
    String? displayName,
    List<String>? channelIds,
  });
  Future<List<ChannelCategoryModel>> updateChannelCategories(
    String userId,
    String teamId,
    List<Map<String, dynamic>> categories,
  );
  Future<List<String>> getChannelCategoryOrder(String userId, String teamId);
  Future<List<String>> updateChannelCategoryOrder(
    String userId,
    String teamId,
    List<String> channelIds,
  );
  Future<ChannelCategoryModel> getChannelCategory(
    String userId,
    String teamId,
    String categoryId,
  );
  Future<ChannelCategoryModel> updateChannelCategory(
    String userId,
    String teamId,
    String categoryId, {
    String? displayName,
    List<String>? channelIds,
  });
  Future<void> deleteChannelCategory(
    String userId,
    String teamId,
    String categoryId,
  );
}

@LazySingleton(as: ChannelCategoriesRemoteDataSource)
class ChannelCategoriesRemoteDataSourceImpl
    implements ChannelCategoriesRemoteDataSource {
  final ApiClient _apiClient;

  ChannelCategoriesRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ChannelCategoryModel>> getChannelCategories(
    String userId,
    String teamId,
  ) async {
    final result = await _apiClient.get<List<ChannelCategoryModel>>(
      UsersEndPoint.teamsChannelsCategories(userId, teamId),
      fromJson: (json) {
        final data = json as Map<String, dynamic>;
        return (data['categories'] as List<dynamic>)
            .map((e) => ChannelCategoryModel.fromMap(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (result is ApiSuccess<List<ChannelCategoryModel>>) {
      return result.data;
    }
    throw Exception('Failed to get categories for team $teamId');
  }

  @override
  Future<ChannelCategoryModel> createChannelCategory(
    String userId,
    String teamId, {
    String? displayName,
    List<String>? channelIds,
  }) async {
    final result = await _apiClient.post<ChannelCategoryModel>(
      UsersEndPoint.teamsChannelsCategories(userId, teamId),
      data: {
        if (displayName != null) 'display_name': displayName,
        if (channelIds != null) 'channel_ids': channelIds,
      },
      fromJson: (json) =>
          ChannelCategoryModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelCategoryModel>) {
      return result.data;
    }
    throw Exception('Failed to create category for team $teamId');
  }

  @override
  Future<List<ChannelCategoryModel>> updateChannelCategories(
    String userId,
    String teamId,
    List<Map<String, dynamic>> categories,
  ) async {
    final result = await _apiClient.put<List<ChannelCategoryModel>>(
      UsersEndPoint.teamsChannelsCategories(userId, teamId),
      data: categories,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ChannelCategoryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ChannelCategoryModel>>) {
      return result.data;
    }
    throw Exception('Failed to update categories for team $teamId');
  }

  @override
  Future<List<String>> getChannelCategoryOrder(
    String userId,
    String teamId,
  ) async {
    final result = await _apiClient.get<List<String>>(
      UsersEndPoint.teamsChannelsCategoriesOrder(userId, teamId),
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get category order for team $teamId');
  }

  @override
  Future<List<String>> updateChannelCategoryOrder(
    String userId,
    String teamId,
    List<String> channelIds,
  ) async {
    final result = await _apiClient.put<List<String>>(
      UsersEndPoint.teamsChannelsCategoriesOrder(userId, teamId),
      data: channelIds,
      fromJson: (json) => (json as List<dynamic>).cast<String>(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to update category order for team $teamId');
  }

  @override
  Future<ChannelCategoryModel> getChannelCategory(
    String userId,
    String teamId,
    String categoryId,
  ) async {
    final result = await _apiClient.get<ChannelCategoryModel>(
      UsersEndPoint.teamsChannelsCategories2(userId, teamId, categoryId),
      fromJson: (json) =>
          ChannelCategoryModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelCategoryModel>) {
      return result.data;
    }
    throw Exception('Failed to get category $categoryId');
  }

  @override
  Future<ChannelCategoryModel> updateChannelCategory(
    String userId,
    String teamId,
    String categoryId, {
    String? displayName,
    List<String>? channelIds,
  }) async {
    final result = await _apiClient.put<ChannelCategoryModel>(
      UsersEndPoint.teamsChannelsCategories2(userId, teamId, categoryId),
      data: {
        if (displayName != null) 'display_name': displayName,
        if (channelIds != null) 'channel_ids': channelIds,
      },
      fromJson: (json) =>
          ChannelCategoryModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ChannelCategoryModel>) {
      return result.data;
    }
    throw Exception('Failed to update category $categoryId');
  }

  @override
  Future<void> deleteChannelCategory(
    String userId,
    String teamId,
    String categoryId,
  ) async {
    await _apiClient.delete(
      UsersEndPoint.teamsChannelsCategories2(userId, teamId, categoryId),
    );
  }
}
