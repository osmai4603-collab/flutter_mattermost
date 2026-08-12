import 'package:flutter_mattermost/core/enums/compliance_report_status.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';
import 'package:flutter_mattermost/features/admin/domain/entities/compliance_report_entity.dart';

final class ComplianceReportModel extends ComplianceReportEntity {
  const ComplianceReportModel({
    super.id,
    super.createAt,
    super.userId,
    super.status,
    super.count,
    super.desc,
    super.type,
    super.startAt,
    super.endAt,
    super.keywords,
    super.emails,
  });

  factory ComplianceReportModel.fromMap(Map<String, dynamic> data) {
    return ComplianceReportModel(
      id: data['id'] ?? '',
      createAt: (data['create_at'] ?? 0).toInt(),
      userId: data['user_id'] ?? '',
      status: ComplianceReportStatus.fromValue(data['status']),
      count: (data['count'] ?? 0).toInt(),
      desc: data['desc'] ?? '',
      type: ComplianceReportType.fromValue(data['type']),
      startAt: (data['start_at'] ?? 0).toInt(),
      endAt: (data['end_at'] ?? 0).toInt(),
      keywords: data['keywords'] ?? '',
      emails: data['emails'] ?? '',
    );
  }

  factory ComplianceReportModel.fromEntity(ComplianceReportEntity entity) {
    return ComplianceReportModel(
      id: entity.id,
      createAt: entity.createAt,
      userId: entity.userId,
      status: entity.status,
      count: entity.count,
      desc: entity.desc,
      type: entity.type,
      startAt: entity.startAt,
      endAt: entity.endAt,
      keywords: entity.keywords,
      emails: entity.emails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'create_at': createAt,
      'user_id': userId,
      'status': status.value,
      'count': count,
      'desc': desc,
      'type': type.value,
      'start_at': startAt,
      'end_at': endAt,
      'keywords': keywords,
      'emails': emails,
    };
  }

  @override
  ComplianceReportModel copyWith({
    String? id,
    int? createAt,
    String? userId,
    ComplianceReportStatus? status,
    int? count,
    String? desc,
    ComplianceReportType? type,
    int? startAt,
    int? endAt,
    String? keywords,
    String? emails,
  }) {
    return ComplianceReportModel(
      id: id ?? this.id,
      createAt: createAt ?? this.createAt,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      count: count ?? this.count,
      desc: desc ?? this.desc,
      type: type ?? this.type,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      keywords: keywords ?? this.keywords,
      emails: emails ?? this.emails,
    );
  }

  ComplianceReportEntity toEntity() {
    return ComplianceReportEntity(
      id: id,
      createAt: createAt,
      userId: userId,
      status: status,
      count: count,
      desc: desc,
      type: type,
      startAt: startAt,
      endAt: endAt,
      keywords: keywords,
      emails: emails,
    );
  }
}
