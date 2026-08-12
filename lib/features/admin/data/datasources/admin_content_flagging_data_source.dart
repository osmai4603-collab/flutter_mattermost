import 'package:flutter_mattermost/features/chat/data/models/content_flagging_config_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/content_reviewer_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_field_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/custom_attribute_value_model.dart';

abstract class AdminContentFlaggingDataSource {
  Future<ContentFlaggingConfigModel> getConfig();
  Future<List<CustomAttributeFieldModel>> getFields();
  Future<Map<String, dynamic>> getFlagConfig();
  Future<Map<String, dynamic>> getPost(String postId);
  Future<void> assignContentReviewer(String postId, String contentReviewerId);
  Future<List<CustomAttributeValueModel>> getPostFieldValues(String postId);
  Future<Map<String, dynamic>> flagPost(
    String postId,
    Map<String, dynamic> data,
  );
  Future<Map<String, dynamic>> keepPost(String postId);
  Future<Map<String, dynamic>> removePost(
    String postId,
    Map<String, dynamic> data,
  );
  Future<Map<String, dynamic>> reportPost(
    String postId,
    Map<String, dynamic> data,
  );
  Future<List<ContentReviewerModel>> searchTeamReviewers(
    String teamId,
    Map<String, dynamic> query,
  );
  Future<Map<String, dynamic>> getTeamStatus(String teamId);

  // Missing operations from docs
  Future<ContentFlaggingConfigModel> updateCFConfig(Map<String, dynamic> config);
  Future<void> generateCFPostReport(String postId, String savePath);
}

@LazySingleton(as: AdminContentFlaggingDataSource)
class AdminContentFlaggingDataSourceImpl
    implements AdminContentFlaggingDataSource {
  final ApiClient _apiClient;

  AdminContentFlaggingDataSourceImpl(this._apiClient);

  @override
  Future<ContentFlaggingConfigModel> getConfig() async {
    final result = await _apiClient.get<ContentFlaggingConfigModel>(
      ContentFlaggingEndPoint.config,
      fromJson: (json) => ContentFlaggingConfigModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ContentFlaggingConfigModel>) {
      return result.data;
    }
    throw Exception('Failed to get content flagging config');
  }

  @override
  Future<List<CustomAttributeFieldModel>> getFields() async {
    final result = await _apiClient.get<List<CustomAttributeFieldModel>>(
      ContentFlaggingEndPoint.fields,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              CustomAttributeFieldModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CustomAttributeFieldModel>>) {
      return result.data;
    }
    throw Exception('Failed to get content flagging fields');
  }

  @override
  Future<Map<String, dynamic>> getFlagConfig() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ContentFlaggingEndPoint.flagConfig,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get content flagging flag config');
  }

  @override
  Future<Map<String, dynamic>> getPost(String postId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ContentFlaggingEndPoint.post(postId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get content flagging post $postId');
  }

  @override
  Future<void> assignContentReviewer(
    String postId,
    String contentReviewerId,
  ) async {
    final result = await _apiClient.post<void>(
      ContentFlaggingEndPoint.postAssign(postId, contentReviewerId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to assign content reviewer to post $postId');
    }
  }

  @override
  Future<List<CustomAttributeValueModel>> getPostFieldValues(
    String postId,
  ) async {
    final result = await _apiClient.get<List<CustomAttributeValueModel>>(
      ContentFlaggingEndPoint.postFieldValues(postId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) =>
              CustomAttributeValueModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<CustomAttributeValueModel>>) {
      return result.data;
    }
    throw Exception('Failed to get field values for post $postId');
  }

  @override
  Future<Map<String, dynamic>> flagPost(
    String postId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ContentFlaggingEndPoint.postFlag(postId),
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to flag post $postId');
  }

  @override
  Future<Map<String, dynamic>> keepPost(String postId) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ContentFlaggingEndPoint.postKeep(postId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to keep post $postId');
  }

  @override
  Future<Map<String, dynamic>> removePost(
    String postId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ContentFlaggingEndPoint.postRemove(postId),
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to remove post $postId');
  }

  @override
  Future<Map<String, dynamic>> reportPost(
    String postId,
    Map<String, dynamic> data,
  ) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      ContentFlaggingEndPoint.postReport(postId),
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to report post $postId');
  }

  @override
  Future<List<ContentReviewerModel>> searchTeamReviewers(
    String teamId,
    Map<String, dynamic> query,
  ) async {
    final result = await _apiClient.post<List<ContentReviewerModel>>(
      ContentFlaggingEndPoint.teamReviewersSearch(teamId),
      data: query,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ContentReviewerModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ContentReviewerModel>>) {
      return result.data;
    }
    throw Exception('Failed to search reviewers for team $teamId');
  }

  @override
  Future<Map<String, dynamic>> getTeamStatus(String teamId) async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      ContentFlaggingEndPoint.teamStatus(teamId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get content flagging status for team $teamId');
  }

  @override
  Future<ContentFlaggingConfigModel> updateCFConfig(Map<String, dynamic> config) async {
    final result = await _apiClient.put<ContentFlaggingConfigModel>(
      ContentFlaggingEndPoint.config,
      data: config,
      fromJson: (json) => ContentFlaggingConfigModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ContentFlaggingConfigModel>) {
      return result.data;
    }
    throw Exception('Failed to update content flagging config');
  }

  @override
  Future<void> generateCFPostReport(String postId, String savePath) async {
    await _apiClient.dio.download(
      ContentFlaggingEndPoint.postReport(postId),
      savePath,
    );
  }
}
