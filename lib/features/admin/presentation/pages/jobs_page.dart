import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/job_status.dart';
import 'package:flutter_mattermost/features/admin/data/models/job_model.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/job_entity.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_jobs_repository.dart';

/// صفحة الوظائف الخلفية: قائمة + إلغاء + حذف + تشغيل.
class AdminConsoleJobsPage extends StatefulWidget {
  const AdminConsoleJobsPage({super.key});

  @override
  State<AdminConsoleJobsPage> createState() => _AdminConsoleJobsPageState();
}

class _AdminConsoleJobsPageState extends State<AdminConsoleJobsPage> {
  final AdminJobsRepository _repository = getIt<AdminJobsRepository>();

  List<JobEntity> _jobs = [];
  List<String> _types = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait<dynamic>([
        _repository.getJobs(perPage: 100),
        _repository.getJobTypes(),
      ]);
      if (!mounted) return;
      setState(() {
        _jobs = results[0] as List<JobModel>;
        _types = results[1] as List<String>;
      });
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _runType(String type) async {
    try {
      await _repository.createJob(
        jobType: type,
        description: 'Manual run from console',
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Job created')));
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _cancelJob(JobEntity job) async {
    try {
      await _repository.cancelJob(job.id);
      if (!mounted) return;
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _removeJob(JobEntity job) async {
    try {
      await _repository.removeJob(job.id);
      if (!mounted) return;
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Color _statusColor(JobStatus status) {
    return switch (status) {
      JobStatus.success => Colors.lightGreenAccent,
      JobStatus.inProgress => Colors.blueAccent,
      JobStatus.pending => Colors.orangeAccent,
      JobStatus.canceled || JobStatus.cancelRequested => Colors.redAccent,
      JobStatus.error => Colors.redAccent,
      _ => Colors.white54,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        Expanded(
          child: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                )
              : _error != null
              ? Center(
                  child: Text(
                    'Could not load jobs: $_error',
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                    ),
                  ),
                )
              : _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.schedule_outlined,
            color: Colors.blueAccent,
            size: 20,
          ),
          const SizedBox(width: 10),
          const Text(
            'Jobs',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Refresh',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_types.isNotEmpty) ...[
            const Text(
              'Run a job type:',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final type in _types)
                  ActionChip(
                    label: Text(type, style: const TextStyle(fontSize: 12)),
                    onPressed: () => _runType(type),
                    backgroundColor: const Color(0xFF181825),
                    side: const BorderSide(color: Colors.white12),
                    labelStyle: const TextStyle(color: Colors.blueAccent),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: _jobs.isEmpty
                ? const Center(
                    child: Text(
                      'No jobs recorded',
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ListView.separated(
                    itemCount: _jobs.length,
                    separatorBuilder: (_, _) =>
                        const Divider(color: Colors.white10, height: 1),
                    itemBuilder: (context, index) {
                      final job = _jobs[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 130,
                              child: Text(
                                job.type.value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                job.status.value,
                                style: TextStyle(
                                  color: _statusColor(job.status),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                job.data.containsKey('description') == true
                                    ? job.data['description'].toString()
                                    : (job.data.toString()),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              job.createAtDate?.toString().split('.').first ??
                                  '—',
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (job.status == JobStatus.pending ||
                                job.status == JobStatus.inProgress)
                              IconButton(
                                tooltip: 'Cancel',
                                onPressed: () => _cancelJob(job),
                                icon: const Icon(
                                  Icons.stop_circle_outlined,
                                  color: Colors.orangeAccent,
                                  size: 18,
                                ),
                              ),
                            IconButton(
                              tooltip: 'Delete Job',
                              onPressed: () => _removeJob(job),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.white38,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
