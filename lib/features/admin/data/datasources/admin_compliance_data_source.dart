import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/enums/compliance_report_type.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/audit_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/compliance_report_model.dart';

abstract class AdminComplianceDataSource {
  Future<List<ComplianceReportModel>> getComplianceReports({
    int page = 0,
    int perPage = 60,
  });
  Future<ComplianceReportModel> createComplianceReport({
    required String jobName,
    required ComplianceReportType reportType,
  });
  Future<ComplianceReportModel> getComplianceReport(String reportId);
  Future<void> removeComplianceReport(String reportId);
  Future<void> downloadComplianceReport(String reportId, String savePath);
  Future<List<AuditModel>> getAudits({
    int page = 0,
    int perPage = 60,
    String? userId,
    String? action,
    int? startDate,
    int? endDate,
  });
  Future<List<AuditModel>> getSystemAudits({
    int page = 0,
    int perPage = 60,
  });
  Future<void> addAuditLogCertificate(String filePath);
  Future<void> removeAuditLogCertificate();
}

@LazySingleton(as: AdminComplianceDataSource)
class AdminComplianceDataSourceImpl implements AdminComplianceDataSource {
  final ApiClient _apiClient;

  AdminComplianceDataSourceImpl(this._apiClient);

  @override
  Future<List<ComplianceReportModel>> getComplianceReports({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<ComplianceReportModel>>(
      ComplianceEndPoint.reports,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => ComplianceReportModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<ComplianceReportModel>>) {
      return result.data;
    }
    throw Exception('Failed to get compliance reports');
  }

  @override
  Future<ComplianceReportModel> createComplianceReport({
    required String jobName,
    required ComplianceReportType reportType,
  }) async {
    final result = await _apiClient.post<ComplianceReportModel>(
      ComplianceEndPoint.reports,
      data: {'job_name': jobName, 'type': reportType.value, 'desc': jobName},
      fromJson: (json) =>
          ComplianceReportModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ComplianceReportModel>) {
      return result.data;
    }
    throw Exception('Failed to create compliance report');
  }

  @override
  Future<ComplianceReportModel> getComplianceReport(String reportId) async {
    final result = await _apiClient.get<ComplianceReportModel>(
      ComplianceEndPoint.reports2(reportId),
      fromJson: (json) =>
          ComplianceReportModel.fromMap(json as Map<String, dynamic>),
    );
    if (result is ApiSuccess<ComplianceReportModel>) {
      return result.data;
    }
    throw Exception('Failed to get compliance report');
  }

  @override
  Future<void> removeComplianceReport(String reportId) async {
    final result = await _apiClient.delete(
      ComplianceEndPoint.reports2(reportId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to remove compliance report');
    }
  }

  @override
  Future<void> downloadComplianceReport(
    String reportId,
    String savePath,
  ) async {
    final response = await _apiClient.dio.download(
      ComplianceEndPoint.reportsDownload(reportId),
      savePath,
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to download compliance report');
    }
  }

  @override
  Future<List<AuditModel>> getAudits({
    int page = 0,
    int perPage = 60,
    String? userId,
    String? action,
    int? startDate,
    int? endDate,
  }) async {
    final result = await _apiClient.get<List<AuditModel>>(
      AuditLogsEndPoint.base,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'user_id': userId,
        'action': action,
        'start_date': startDate,
        'end_date': endDate,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AuditModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AuditModel>>) {
      return result.data;
    }
    throw Exception('Failed to get audit log');
  }

  @override
  Future<List<AuditModel>> getSystemAudits({
    int page = 0,
    int perPage = 60,
  }) async {
    final result = await _apiClient.get<List<AuditModel>>(
      AuditsEndPoint.root,
      queryParameters: {'page': page, 'per_page': perPage},
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AuditModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AuditModel>>) {
      return result.data;
    }
    throw Exception('Failed to get system audits');
  }

  @override
  Future<void> addAuditLogCertificate(String filePath) async {
    // Assuming file upload for certificate
    // In OpenAPI it's just POST /audit_logs/certificate
    final result = await _apiClient.post<void>(
      AuditLogsEndPoint.certificate,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to add audit log certificate');
    }
  }

  @override
  Future<void> removeAuditLogCertificate() async {
    final result = await _apiClient.delete(
      AuditLogsEndPoint.certificate,
    );
    if (result is ApiFailure) {
      throw Exception('Failed to remove audit log certificate');
    }
  }
}
