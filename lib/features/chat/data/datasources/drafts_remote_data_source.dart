import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/enums/draft_type.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/draft_model.dart';

import 'package:flutter_mattermost/core/endpoints/endpoints.dart';

abstract class DraftsRemoteDataSource {
  Future<List<DraftModel>> getDraftsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
  });
  Future<List<DraftModel>> getDraftsForThread(
    String channelId,
    String rootId,
  );
  Future<Map<String, dynamic>> saveDraft({
    required String channelId,
    required String rootId,
    required String userId,
    required String message,
    required DraftType type,
    required Map<String, dynamic> props,
    required List<String> fileIds,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> priority,
    required int createAt,
    required int updateAt,
    required int deleteAt,
    required List<Map<String, dynamic>> fileInfos,
    required List<Map<String, dynamic>> uploadsInProgress,
  });
  Future<void> deleteDraft(
    String userId,
    String channelId, {
    String? rootId,
  });
  Future<List<DraftModel>> getDraftsForTeam(
    String userId,
    String teamId, {
    int page = 0,
    int perPage = 60,
  });
}

@LazySingleton(as: DraftsRemoteDataSource)
class DraftsRemoteDataSourceImpl implements DraftsRemoteDataSource {
  final ApiClient _apiClient;

  DraftsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<DraftModel>> getDraftsForChannel(
    String channelId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<DraftModel>>(
      DraftsEndPoint.root,
      queryParameters: {
        'channel_id': channelId,
        'page': page,
        'per_page': perPage,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => DraftModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<DraftModel>>) {
      return result.data;
    }
    throw Exception('Failed to get drafts for channel $channelId');
  }

  @override
  Future<List<DraftModel>> getDraftsForThread(
    String channelId,
    String rootId,
  ) async {
    final result = await _apiClient.get<List<DraftModel>>(
      DraftsEndPoint.root,
      queryParameters: {'channel_id': channelId, 'root_id': rootId},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => DraftModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<DraftModel>>) {
      return result.data;
    }
    throw Exception('Failed to get drafts for thread $rootId');
  }

  @override
  Future<Map<String, dynamic>> saveDraft({
    required String channelId,
    required String rootId,
    required String userId,
    required String message,
    required DraftType type,
    required Map<String, dynamic> props,
    required List<String> fileIds,
    required Map<String, dynamic> metadata,
    required Map<String, dynamic> priority,
    required int createAt,
    required int updateAt,
    required int deleteAt,
    required List<Map<String, dynamic>> fileInfos,
    required List<Map<String, dynamic>> uploadsInProgress,
  }) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      DraftsEndPoint.root,
      data: {
        "channel_id": channelId,
        "root_id": rootId,
        "user_id": userId,
        "message": message,
        "type": type.value,
        "props": props,
        "file_ids": fileIds,
        "metadata": metadata,
        "priority": priority,
        "create_at": createAt,
        "update_at": updateAt,
        "delete_at": deleteAt,
        "file_infos": fileInfos,
        "uploads_in_progress": uploadsInProgress,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to save draft');
  }

  @override
  Future<void> deleteDraft(
    String userId,
    String channelId, {
    String? rootId,
  }) async {
    if (rootId != null) {
      await _apiClient.delete(
        UsersEndPoint.channelsDrafts2(userId, channelId, rootId),
      );
    } else {
      await _apiClient.delete(
        UsersEndPoint.channelsDrafts(userId, channelId),
      );
    }
  }

  @override
  Future<List<DraftModel>> getDraftsForTeam(
    String userId,
    String teamId, {
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<DraftModel>>(
      UsersEndPoint.teamsDrafts(userId, teamId),
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) {
        if (json == null) return <DraftModel>[];
        return (json as List<dynamic>)
            .map((e) => DraftModel.fromMap(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (result is ApiSuccess<List<DraftModel>>) {
      return result.data;
    }
    throw Exception('Failed to get drafts for team $teamId');
  }
}
