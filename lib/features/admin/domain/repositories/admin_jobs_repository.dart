import 'package:flutter_mattermost/features/admin/data/models/job_model.dart';

abstract class AdminJobsRepository {
  Future<List<JobModel>> getJobs({int page = 0, int perPage = 100});
  Future<List<String>> getJobTypes();
  Future<JobModel> createJob({
    required String jobType,
    String? description,
    Map<String, dynamic>? data,
  });
  Future<void> cancelJob(String jobId);
  Future<void> removeJob(String jobId);
}
