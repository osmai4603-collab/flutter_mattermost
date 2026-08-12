import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_jobs_data_source.dart';
import 'package:flutter_mattermost/features/admin/data/models/job_model.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_jobs_repository.dart';

@LazySingleton(as: AdminJobsRepository)
class AdminJobsRepositoryImpl implements AdminJobsRepository {
  final AdminJobsDataSource _dataSource;

  AdminJobsRepositoryImpl(this._dataSource);

  @override
  Future<List<JobModel>> getJobs({int page = 0, int perPage = 100}) =>
      _dataSource.getJobs(page: page, perPage: perPage);

  @override
  Future<List<String>> getJobTypes() => _dataSource.getJobTypes();

  @override
  Future<JobModel> createJob({
    required String jobType,
    String? description,
    Map<String, dynamic>? data,
  }) => _dataSource.createJob(
    jobType: jobType,
    description: description,
    data: data,
  );

  @override
  Future<void> cancelJob(String jobId) => _dataSource.cancelJob(jobId);

  @override
  Future<void> removeJob(String jobId) => _dataSource.removeJob(jobId);
}
