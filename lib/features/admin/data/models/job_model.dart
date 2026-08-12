import 'package:flutter_mattermost/core/enums/job_status.dart';
import 'package:flutter_mattermost/core/enums/job_type.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/job_entity.dart';

final class JobModel extends JobEntity {
  const JobModel({
    super.id,
    super.type,
    super.createAt,
    super.startAt,
    super.lastActivityAt,
    super.status,
    super.progress,
    super.data,
  });

  factory JobModel.fromMap(Map<String, dynamic> data) {
    return JobModel(
      id: data['id'] ?? '',
      type: JobType.fromValue(data['type']),
      createAt: (data['create_at'] ?? 0).toInt(),
      startAt: (data['start_at'] ?? 0).toInt(),
      lastActivityAt: (data['last_activity_at'] ?? 0).toInt(),
      status: JobStatus.fromValue(data['status']),
      progress: (data['progress'] ?? 0).toInt(),
      data: Map<String, dynamic>.from(data['data'] ?? const {}),
    );
  }

  factory JobModel.fromEntity(JobEntity entity) {
    return JobModel(
      id: entity.id,
      type: entity.type,
      createAt: entity.createAt,
      startAt: entity.startAt,
      lastActivityAt: entity.lastActivityAt,
      status: entity.status,
      progress: entity.progress,
      data: entity.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.value,
      'create_at': createAt,
      'start_at': startAt,
      'last_activity_at': lastActivityAt,
      'status': status.value,
      'progress': progress,
      'data': data,
    };
  }

  JobModel copyWith({
    String? id,
    JobType? type,
    int? createAt,
    int? updateAt,
    int? startAt,
    int? lastActivityAt,
    JobStatus? status,
    int? progress,
    Map<String, dynamic>? data,
  }) {
    return JobModel(
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

  JobEntity toEntity() {
    return JobEntity(
      id: id,
      type: type,
      createAt: createAt,
      startAt: startAt,
      lastActivityAt: lastActivityAt,
      status: status,
      progress: progress,
      data: data,
    );
  }
}
