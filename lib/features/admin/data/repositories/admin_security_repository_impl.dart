import 'package:flutter_mattermost/features/auth/data/models/ldap_diagnostic_result_model.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/session_entity.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/features/admin/data/datasources/admin_security_data_source.dart';
import 'package:flutter_mattermost/features/admin/domain/repositories/admin_security_repository.dart';

@LazySingleton(as: AdminSecurityRepository)
class AdminSecurityRepositoryImpl implements AdminSecurityRepository {
  final AdminSecurityDataSource _dataSource;

  AdminSecurityRepositoryImpl(this._dataSource);

  @override
  Future<void> testLDAPConnection() => _dataSource.testLDAPConnection();

  @override
  Future<void> syncLDAP() => _dataSource.syncLDAP();

  @override
  Future<List<LdapDiagnosticResultModel>> testLDAPDiagnostics() =>
      _dataSource.testLDAPDiagnostics();

  @override
  Future<String> getSAMLMetadata() => _dataSource.getSAMLMetadata();

  @override
  Future<Map<String, dynamic>> getSAMLCertificateStatus() =>
      _dataSource.getSAMLCertificateStatus();

  @override
  Future<void> uploadSAMLCertificate({
    String? publicPath,
    String? privatePath,
  }) => _dataSource.uploadSAMLCertificate(
    publicPath: publicPath,
    privatePath: privatePath,
  );

  @override
  Future<List<SessionEntity>> getSessions(String userId) =>
      _dataSource.getSessions(userId);

  @override
  Future<void> revokeAllSessionsForUser(String userId) =>
      _dataSource.revokeAllSessionsForUser(userId);

  @override
  Future<Map<String, dynamic>> getMFAStatus() => _dataSource.getMFAStatus();

  @override
  Future<void> requestPasswordReset(String email) =>
      _dataSource.requestPasswordReset(email);
}
