import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/chat/data/models/scheduled_recap_model.dart';

abstract class ScheduledRecapsRemoteDataSource {
  Future<List<ScheduledRecapModel>> getScheduledRecaps({
    int page = 0,
    int perPage = 60,
  });
  Future<ScheduledRecapModel> createScheduledRecap({
    required String channelId,
    String period = 'daily',
    int? periodMonth,
    int? periodDay,
  });
  Future<ScheduledRecapModel> getScheduledRecap(String scheduledRecapId);
  Future<ScheduledRecapModel> updateScheduledRecap(
    String scheduledRecapId,
    Map<String, dynamic> patch,
  );
  Future<void> deleteScheduledRecap(String scheduledRecapId);
  Future<ScheduledRecapModel> pauseScheduledRecap(String scheduledRecapId);
  Future<ScheduledRecapModel> resumeScheduledRecap(String scheduledRecapId);
}

@LazySingleton(as: ScheduledRecapsRemoteDataSource)
class ScheduledRecapsRemoteDataSourceImpl
    implements ScheduledRecapsRemoteDataSource {
  final ApiClient _apiClient;

  ScheduledRecapsRemoteDataSourceImpl(this._apiClient);

  ScheduledRecapModel _from(ApiResult<ScheduledRecapModel> result, String error) {
    if (result is ApiSuccess<ScheduledRecapModel>) {
      return result.data;
    }
    throw Exception(error);
  }

  @override
  Future<List<ScheduledRecapModel>> getScheduledRecaps({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ScheduledRecapModel>>(
      ScheduledRecapsEndPoint.root,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ScheduledRecapModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ScheduledRecapModel>>) {
      return result.data;
    }
    throw Exception('Failed to get scheduled recaps');
  }

  @override
  Future<ScheduledRecapModel> createScheduledRecap({
    required String channelId,
    String period = 'daily',
    int? periodMonth,
    int? periodDay,
  }) async {
    final result = await _apiClient.post<ScheduledRecapModel>(
      ScheduledRecapsEndPoint.root,
      data: {
        'channel_id': channelId,
        'period': period,
        if (periodMonth != null) 'period_month': periodMonth,
        if (periodDay != null) 'period_day': periodDay,
      },
      fromJson: (json) =>
          ScheduledRecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to create scheduled recap');
  }

  @override
  Future<ScheduledRecapModel> getScheduledRecap(String scheduledRecapId) async {
    final result = await _apiClient.get<ScheduledRecapModel>(
      ScheduledRecapsEndPoint.byScheduledRecapId(scheduledRecapId),
      fromJson: (json) =>
          ScheduledRecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to get scheduled recap');
  }

  @override
  Future<ScheduledRecapModel> updateScheduledRecap(
    String scheduledRecapId,
    Map<String, dynamic> patch,
  ) async {
    final result = await _apiClient.put<ScheduledRecapModel>(
      ScheduledRecapsEndPoint.byScheduledRecapId(scheduledRecapId),
      data: patch,
      fromJson: (json) =>
          ScheduledRecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to update scheduled recap');
  }

  @override
  Future<void> deleteScheduledRecap(String scheduledRecapId) async {
    final result = await _apiClient.delete(
      ScheduledRecapsEndPoint.byScheduledRecapId(scheduledRecapId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete scheduled recap');
    }
  }

  @override
  Future<ScheduledRecapModel> pauseScheduledRecap(String scheduledRecapId) async {
    final result = await _apiClient.post<ScheduledRecapModel>(
      ScheduledRecapsEndPoint.pause(scheduledRecapId),
      fromJson: (json) =>
          ScheduledRecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to pause scheduled recap');
  }

  @override
  Future<ScheduledRecapModel> resumeScheduledRecap(
    String scheduledRecapId,
  ) async {
    final result = await _apiClient.post<ScheduledRecapModel>(
      ScheduledRecapsEndPoint.resume(scheduledRecapId),
      fromJson: (json) =>
          ScheduledRecapModel.fromMap(json as Map<String, dynamic>),
    );
    return _from(result, 'Failed to resume scheduled recap');
  }
}
