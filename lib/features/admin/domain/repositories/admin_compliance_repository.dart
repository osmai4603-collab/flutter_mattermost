
import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';
import 'package:flutter_mattermost/features/admin/data/models/audit_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/compliance_report_model.dart';

abstract class AdminComplianceRepository {
  Future<List<ComplianceReportModel>> getComplianceReports();
  Future<ComplianceReportModel> createComplianceReport({
    required String jobName,
    required ComplianceReportType reportType,
  });
  Future<void> removeComplianceReport(String reportId);
  Future<List<AuditModel>> getAudits({int page = 0, int perPage = 100});
}
