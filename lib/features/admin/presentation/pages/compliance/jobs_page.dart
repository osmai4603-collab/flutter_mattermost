import 'package:flutter/material.dart';
import 'package:flutter_mattermost/core/di/injection.dart';
import 'package:flutter_mattermost/core/enums/job_status.dart';
import 'package:flutter_mattermost/core/theme/app_theme.dart';
import 'package:flutter_mattermost/core/theme/mattermost_colors.dart';
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
    final colors = AppTheme.of(context);
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
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _cancelJob(JobEntity job) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.cancelJob(job.id);
      if (!mounted) return;
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Future<void> _removeJob(JobEntity job) async {
    final colors = AppTheme.of(context);
    try {
      await _repository.removeJob(job.id);
      if (!mounted) return;
      _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: colors.errorTextColor,
        ),
      );
    }
  }

  Color _statusColor(JobStatus status, MattermostColors colors) {
    return switch (status) {
      JobStatus.success => colors.onlineIndicator,
      JobStatus.inProgress => colors.buttonBg,
      JobStatus.pending => colors.awayIndicator,
      JobStatus.canceled || JobStatus.cancelRequested => colors.errorTextColor,
      JobStatus.error => colors.errorTextColor,
      _ => colors.centerChannelColor.withValues(alpha: 0.54),
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: Container(
          color: colors.centerChannelBg,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              'Jobs',
              style: TextStyle(
                color: colors.centerChannelColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: colors.buttonBg),
                  )
                : _error != null
                ? Center(
                    child: Text(
                      'Could not load jobs: $_error',
                      style: TextStyle(
                        color: colors.errorTextColor,
                        fontSize: 13,
                      ),
                    ),
                  )
                : _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colors = AppTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_types.isNotEmpty) ...[
            Text(
              'Run a job type:',
              style: TextStyle(
                color: colors.centerChannelColor.withValues(alpha: 0.54),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final type in _types)
                  ActionChip(
                    label: Text(type, style: const TextStyle(fontSize: 12)),
                    onPressed: () => _runType(type),
                    backgroundColor: colors.mentionHighlightBg,
                    side: BorderSide(
                      color: colors.centerChannelColor.withValues(alpha: 0.12),
                    ),
                    labelStyle: TextStyle(color: colors.buttonBg),
                  ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          Expanded(
            child: _jobs.isEmpty
                ? Center(
                    child: Text(
                      'No jobs recorded',
                      style: TextStyle(
                        color: colors.centerChannelColor.withValues(
                          alpha: 0.38,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: _jobs.length,
                    separatorBuilder: (_, _) => Divider(
                      color: colors.centerChannelColor.withValues(alpha: 0.10),
                      height: 1,
                    ),
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
                                style: TextStyle(
                                  color: colors.centerChannelColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 100,
                              child: Text(
                                job.status.value,
                                style: TextStyle(
                                  color: _statusColor(job.status, colors),
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
                                style: TextStyle(
                                  color: colors.centerChannelColor.withValues(
                                    alpha: 0.54,
                                  ),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              job.createAtDate?.toString().split('.').first ??
                                  '—',
                              style: TextStyle(
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.38,
                                ),
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(width: 12),
                            if (job.status == JobStatus.pending ||
                                job.status == JobStatus.inProgress)
                              IconButton(
                                tooltip: 'Cancel',
                                onPressed: () => _cancelJob(job),
                                icon: Icon(
                                  Icons.stop_circle_outlined,
                                  color: colors.awayIndicator,
                                  size: 18,
                                ),
                              ),
                            IconButton(
                              tooltip: 'Delete Job',
                              onPressed: () => _removeJob(job),
                              icon: Icon(
                                Icons.delete_outline,
                                color: colors.centerChannelColor.withValues(
                                  alpha: 0.38,
                                ),
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
