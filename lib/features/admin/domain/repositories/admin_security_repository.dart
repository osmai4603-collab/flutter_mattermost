import 'package:flutter_mattermost/features/auth/data/models/ldap_diagnostic_result_model.dart';
import 'package:flutter_mattermost/features/auth/domain/entities/session_entity.dart';

abstract class AdminSecurityRepository {
  Future<void> testLDAPConnection();
  Future<void> syncLDAP();
  Future<List<LdapDiagnosticResultModel>> testLDAPDiagnostics();
  Future<String> getSAMLMetadata();
  Future<Map<String, dynamic>> getSAMLCertificateStatus();
  Future<void> uploadSAMLCertificate({String? publicPath, String? privatePath});
  Future<List<SessionEntity>> getSessions(String userId);
  Future<void> revokeAllSessionsForUser(String userId);
  Future<Map<String, dynamic>> getMFAStatus();
  Future<void> requestPasswordReset(String email);
}
