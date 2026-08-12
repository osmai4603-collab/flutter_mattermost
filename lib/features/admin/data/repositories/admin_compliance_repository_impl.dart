import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';
import 'package:flutter_mattermost/features/admin/data/models/audit_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/compliance_report_model.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_compliance_data_source.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_compliance_repository.dart';

@LazySingleton(as: AdminComplianceRepository)
class AdminComplianceRepositoryImpl implements AdminComplianceRepository {
  final AdminComplianceDataSource _dataSource;

  AdminComplianceRepositoryImpl(this._dataSource);

  @override
  Future<List<ComplianceReportModel>> getComplianceReports() =>
      _dataSource.getComplianceReports();

  @override
  Future<ComplianceReportModel> createComplianceReport({
    required String jobName,
    required ComplianceReportType reportType,
  }) => _dataSource.createComplianceReport(
    jobName: jobName,
    reportType: reportType,
  );

  @override
  Future<void> removeComplianceReport(String id) =>
      _dataSource.removeComplianceReport(id);

  @override
  Future<List<AuditModel>> getAudits({int page = 0, int perPage = 100}) =>
      _dataSource.getAudits(page: page, perPage: perPage);
}
