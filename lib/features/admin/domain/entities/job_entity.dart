import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/enums/job_status.dart';
import 'package:flutter_mattermost/core/enums/job_type.dart';

class JobEntity extends Entity {
  final String id;
  final JobType type;
  final int createAt;
  final int startAt;
  final int lastActivityAt;
  final JobStatus status;
  final int progress;
  final Map<String, dynamic> data;

  const JobEntity({
    this.id = '',
    this.type = JobType.unknown,
    this.createAt = 0,
    this.startAt = 0,
    this.lastActivityAt = 0,
    this.status = JobStatus.pending,
    this.progress = 0,
    this.data = const {},
  });

  @override
  List<Object?> get props => [
        id,
        type,
        createAt,
        startAt,
        lastActivityAt,
        status,
        progress,
        data,
      ];

  JobEntity copyWith({
    String? id,
    JobType? type,
    int? createAt,
    int? startAt,
    int? lastActivityAt,
    JobStatus? status,
    int? progress,
    Map<String, dynamic>? data,
  }) {
    return JobEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      createAt: createAt ?? this.createAt,
      startAt: startAt ?? this.startAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      data: data ?? this.data,
    );
  }

  DateTime? get createAtDate => createAt != 0
      ? DateTime.fromMillisecondsSinceEpoch(createAt).toLocal()
      : null;
}
