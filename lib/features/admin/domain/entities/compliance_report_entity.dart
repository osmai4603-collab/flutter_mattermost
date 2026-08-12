import 'package:flutter_mattermost/core/entities/entity.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_status.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';

class ComplianceReportEntity extends Entity {
  final String id;
  final int createAt;
  final String userId;
  final ComplianceReportStatus status;
  final int count;
  final String desc;
  final ComplianceReportType type;
  final int startAt;
  final int endAt;
  final String keywords;
  final String emails;

  const ComplianceReportEntity({
    this.id = '',
    this.createAt = 0,
    this.userId = '',
    this.status = ComplianceReportStatus.created,
    this.count = 0,
    this.desc = '',
    this.type = ComplianceReportType.daily,
    this.startAt = 0,
    this.endAt = 0,
    this.keywords = '',
    this.emails = '',
  });

  @override
  List<Object?> get props => [
        id,
        createAt,
        userId,
        status,
        count,
        desc,
        type,
        startAt,
        endAt,
        keywords,
        emails,
      ];

  ComplianceReportEntity copyWith({
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
    return ComplianceReportEntity(
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

  DateTime? get createAtDate => createAt != 0
      ? DateTime.fromMillisecondsSinceEpoch(createAt).toLocal()
      : null;
}
