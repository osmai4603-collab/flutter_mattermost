import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/recap_model.dart';

abstract class RecapsRemoteDataSource {
  Future<List<RecapModel>> getRecaps({
    int page = 0,
    int perPage = 60,
  });
  Future<RecapModel> createRecap({
    required String channelId,
    String period = 'daily',
    int? periodMonth,
    int? periodDay,
  });
  Future<Map<String, dynamic>> getRecapLimitStatus();
  Future<void> markRecapsAsViewed();
  Future<RecapModel> getRecap(String recapId);
  Future<void> deleteRecap(String recapId);
  Future<RecapModel> markRecapAsRead(String recapId);
  Future<RecapModel> regenerateRecap(String recapId);
}

@LazySingleton(as: RecapsRemoteDataSource)
class RecapsRemoteDataSourceImpl implements RecapsRemoteDataSource {
  final ApiClient _apiClient;

  RecapsRemoteDataSourceImpl(this._apiClient);

  RecapModel _from(ApiResult<RecapModel> result, String error) {
    if (result is ApiSuccess<RecapModel>) {
      return result.data;
    }
    throw Exception(error);
  }

  @override
  Future<List<RecapModel>> getRecaps({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<RecapModel>>(
      RecapsEndPoint.root,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => RecapModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<RecapModel>>) {
      return result.data;
    }
    throw Exception('Failed to get recaps');
  }

  @override
  Future<RecapModel> createRecap({
    required String channelId,
    String period = 'daily',
    int? periodMonth,
    int? periodDay,
  }) async {
    final result = await _apiClient.post<RecapModel>(
      RecapsEndPoint.root,
      data: {
        'channel_id': channelId,
        'period': period,
        if (periodMonth != null) 'period_month': periodMonth,
        if (periodDay != null) 'period_day': periodDay,
      },
      fromJson: (json) => RecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to create recap');
  }

  @override
  Future<Map<String, dynamic>> getRecapLimitStatus() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      RecapsEndPoint.limitStatus,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get recap limit status');
  }

  @override
  Future<void> markRecapsAsViewed() async {
    final result = await _apiClient.post<void>(
      RecapsEndPoint.markViewed,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to mark recaps as viewed');
    }
  }

  @override
  Future<RecapModel> getRecap(String recapId) async {
    final result = await _apiClient.get<RecapModel>(
      RecapsEndPoint.byRecapId(recapId),
      fromJson: (json) => RecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to get recap');
  }

  @override
  Future<void> deleteRecap(String recapId) async {
    final result = await _apiClient.delete(RecapsEndPoint.byRecapId(recapId));
    if (result is ApiFailure) {
      throw Exception('Failed to delete recap');
    }
  }

  @override
  Future<RecapModel> markRecapAsRead(String recapId) async {
    final result = await _apiClient.post<RecapModel>(
      RecapsEndPoint.read(recapId),
      fromJson: (json) => RecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to mark recap as read');
  }

  @override
  Future<RecapModel> regenerateRecap(String recapId) async {
    final result = await _apiClient.post<RecapModel>(
      RecapsEndPoint.regenerate(recapId),
      fromJson: (json) => RecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to regenerate recap');
  }
}
