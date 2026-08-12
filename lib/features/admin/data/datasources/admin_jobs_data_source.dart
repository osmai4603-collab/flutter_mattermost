import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/job_model.dart';

abstract class AdminJobsDataSource {
  Future<List<JobModel>> getJobs({
    int page = 0,
    int perPage = 60,
    String? status,
    String? type,
  });
  Future<List<String>> getJobTypes();
  Future<JobModel> createJob({
    required String jobType,
    String? description,
    Map<String, dynamic>? data,
  });
  Future<JobModel> getJob(String jobId);
  Future<JobModel> getJobStatus(String jobId);
  Future<void> cancelJob(String jobId);
  Future<void> removeJob(String jobId);
  Future<void> downloadJobResults(String jobId, String savePath);
}

@LazySingleton(as: AdminJobsDataSource)
class AdminJobsDataSourceImpl implements AdminJobsDataSource {
  final ApiClient _apiClient;

  AdminJobsDataSourceImpl(this._apiClient);

  @override
  Future<List<JobModel>> getJobs({
    int page = 0,
    int perPage = 60,
    String? status,
    String? type,
  }) async {
    final result = await _apiClient.get<List<JobModel>>(
      JobsEndPoint.root,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'status': status,
        'type': type,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => JobModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<JobModel>>) {
      return result.data;
    }
    throw Exception('Failed to get jobs');
  }

  @override
  Future<List<String>> getJobTypes() async {
    final result = await _apiClient.get<List<String>>(
      JobsEndPoint.types,
      fromJson: (json) =>
          (json as List<dynamic>).map((e) => e.toString()).toList(),
    );
    if (result is ApiSuccess<List<String>>) {
      return result.data;
    }
    throw Exception('Failed to get job types');
  }

  @override
  Future<JobModel> createJob({
    required String jobType,
    String? description,
    Map<String, dynamic>? data,
  }) async {
    final result = await _apiClient.post<JobModel>(
      JobsEndPoint.type(jobType),
      data: {
        'type': jobType,
        'description': description,
        if (data != null) 'data': data,
      },
      fromJson: (json) => JobModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<JobModel>) {
      return result.data;
    }
    throw Exception('Failed to create job');
  }

  @override
  Future<JobModel> getJob(String jobId) async {
    final result = await _apiClient.get<JobModel>(
      JobsEndPoint.byJobId(jobId),
      fromJson: (json) => JobModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<JobModel>) {
      return result.data;
    }
    throw Exception('Failed to get job');
  }

  @override
  Future<JobModel> getJobStatus(String jobId) async {
    final result = await _apiClient.get<JobModel>(
      JobsEndPoint.status(jobId),
      fromJson: (json) => JobModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<JobModel>) {
      return result.data;
    }
    throw Exception('Failed to get job status');
  }

  @override
  Future<void> cancelJob(String jobId) async {
    final result = await _apiClient.post<void>(
      JobsEndPoint.cancel(jobId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to cancel job');
    }
  }

  @override
  Future<void> removeJob(String jobId) async {
    final result = await _apiClient.delete(JobsEndPoint.byJobId(jobId));
    if (result is ApiFailure) {
      throw Exception('Failed to remove job');
    }
  }

  @override
  Future<void> downloadJobResults(String jobId, String savePath) async {
    final response = await _apiClient.dio.download(
      JobsEndPoint.download(jobId),
      savePath,
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to download job results');
    }
  }
}
