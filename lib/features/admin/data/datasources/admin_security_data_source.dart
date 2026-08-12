import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_mattermost/core/endpoints/endpoints.dart';
import 'package:flutter_mattermost/core/network/api_client.dart';
import 'package:flutter_mattermost/core/network/api_result.dart';
import 'package:flutter_mattermost/features/admin/data/models/allowed_ip_range_model.dart';
import 'package:flutter_mattermost/features/admin/data/models/audit_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/ldap_diagnostic_result_model.dart';
import 'package:flutter_mattermost/features/auth/data/models/session_model.dart';
import 'package:flutter_mattermost/features/groups/data/models/ldap_group_model.dart';

abstract class AdminSecurityDataSource {
  Future<void> testLDAPConnection();
  Future<void> testLDAP();
  Future<void> syncLDAP();
  Future<List<LdapDiagnosticResultModel>> testLDAPDiagnostics();
  Future<List<LDAPGroupModel>> getLDAPGroups({
    int page = 0,
    int perPage = 60,
    String? q,
  });
  Future<void> uploadLDAPCertificates({
    String? publicPath,
    String? privatePath,
  });
  Future<void> deleteLDAPPublicCertificate();
  Future<void> deleteLDAPPrivateCertificate();
  Future<String> getSAMLMetadata();
  Future<Map<String, dynamic>> getSAMLCertificateStatus();
  Future<void> uploadSAMLCertificate({String? publicPath, String? privatePath});
  Future<void> resetSAMLData();
  Future<List<SessionModel>> getSessions(String userId);
  Future<void> revokeSessionsForUser(String userId, List<String> sessionIds);
  Future<void> revokeAllSessionsForUser(String userId);
  Future<Map<String, dynamic>> getMFAStatus();
  Future<void> resetPassword(
    String userId,
    String currentPassword,
    String newPassword,
  );
  Future<void> requestPasswordReset(String email);
  Future<Map<String, dynamic>> linkLDAPGroups(String remoteId);
  Future<Map<String, dynamic>> migrateLDAPId(Map<String, dynamic> data);
  Future<Map<String, dynamic>> getSAMLIdpCertificate();
  Future<void> uploadSAMLMetadataFromIdp(String filePath);
  Future<void> deleteSAMLIdpCertificate();
  Future<void> addUserToGroupSyncables(String userId);
  Future<void> invalidateCaches();
  Future<Map<String, dynamic>> getMyIp();
  Future<Map<String, dynamic>> getAuditLogsCertificate();
  Future<List<AllowedIPRangeModel>> getIpFilters();
  Future<List<AllowedIPRangeModel>> applyIpFilters(
    List<AllowedIPRangeModel> filters,
  );
  Future<List<AuditModel>> getAudits({int page = 0, int perPage = 60});

  // Missing operations from docs
  Future<void> unlinkLDAPGroup(String remoteId);
}

@LazySingleton(as: AdminSecurityDataSource)
class AdminSecurityDataSourceImpl implements AdminSecurityDataSource {
  final ApiClient _apiClient;

  AdminSecurityDataSourceImpl(this._apiClient);

  @override
  Future<void> testLDAPConnection() async {
    final result = await _apiClient.post<void>(
      LdapEndPoint.testConnection,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('LDAP connection test failed');
    }
  }

  @override
  Future<void> testLDAP() async {
    final result = await _apiClient.post<void>(
      LdapEndPoint.test,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('LDAP test failed');
    }
  }

  @override
  Future<void> syncLDAP() async {
    final result = await _apiClient.post<void>(
      LdapEndPoint.sync,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('LDAP sync failed');
    }
  }

  @override
  Future<List<LdapDiagnosticResultModel>> testLDAPDiagnostics() async {
    final result = await _apiClient.get<List<LdapDiagnosticResultModel>>(
      LdapEndPoint.testDiagnostics,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => LdapDiagnosticResultModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<LdapDiagnosticResultModel>>) {
      return result.data;
    }
    throw Exception('LDAP diagnostics failed');
  }

  @override
  Future<List<LDAPGroupModel>> getLDAPGroups({
    int page = 0,
    int perPage = 60,
    String? q,
  }) async {
    final result = await _apiClient.get<List<LDAPGroupModel>>(
      LdapEndPoint.groups,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (q != null && q.isNotEmpty) 'q': q,
      },
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => LDAPGroupModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<LDAPGroupModel>>) {
      return result.data;
    }
    throw Exception('Failed to get LDAP groups');
  }

  @override
  Future<void> uploadLDAPCertificates({
    String? publicPath,
    String? privatePath,
  }) async {
    if (publicPath != null) {
      final public = await _apiClient.dio.post(
        LdapEndPoint.certificatePublic,
        data: FormData.fromMap({
          'certificate': await MultipartFile.fromFile(publicPath),
        }),
      );
      if (public.statusCode == null || public.statusCode! >= 400) {
        throw Exception('Failed to upload LDAP public certificate');
      }
    }
    if (privatePath != null) {
      final private = await _apiClient.dio.post(
        LdapEndPoint.certificatePrivate,
        data: FormData.fromMap({
          'certificate': await MultipartFile.fromFile(privatePath),
        }),
      );
      if (private.statusCode == null || private.statusCode! >= 400) {
        throw Exception('Failed to upload LDAP private certificate');
      }
    }
  }

  @override
  Future<void> deleteLDAPPublicCertificate() async {
    final result = await _apiClient.delete(LdapEndPoint.certificatePublic);
    if (result is ApiFailure) {
      throw Exception('Failed to delete LDAP public certificate');
    }
  }

  @override
  Future<void> deleteLDAPPrivateCertificate() async {
    final result = await _apiClient.delete(LdapEndPoint.certificatePrivate);
    if (result is ApiFailure) {
      throw Exception('Failed to delete LDAP private certificate');
    }
  }

  @override
  Future<String> getSAMLMetadata() async {
    final result = await _apiClient.get<String>(
      SamlEndPoint.metadata,
      fromJson: (json) => json.toString(),
    );
    if (result is ApiSuccess<String>) {
      return result.data;
    }
    throw Exception('Failed to get SAML metadata');
  }

  @override
  Future<Map<String, dynamic>> getSAMLCertificateStatus() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SamlEndPoint.certificateStatus,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get SAML certificate status');
  }

  @override
  Future<void> uploadSAMLCertificate({
    String? publicPath,
    String? privatePath,
  }) async {
    if (publicPath != null) {
      final public = await _apiClient.dio.post(
        SamlEndPoint.certificatePublic,
        data: FormData.fromMap({
          'certificate': await MultipartFile.fromFile(publicPath),
        }),
      );
      if (public.statusCode == null || public.statusCode! >= 400) {
        throw Exception('Failed to upload public certificate');
      }
    }
    if (privatePath != null) {
      final private = await _apiClient.dio.post(
        SamlEndPoint.certificatePrivate,
        data: FormData.fromMap({
          'certificate': await MultipartFile.fromFile(privatePath),
        }),
      );
      if (private.statusCode == null || private.statusCode! >= 400) {
        throw Exception('Failed to upload private certificate');
      }
    }
  }

  @override
  Future<void> resetSAMLData() async {
    final result = await _apiClient.post<void>(
      SamlEndPoint.resetAuthData,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to reset SAML data');
    }
  }

  @override
  Future<List<SessionModel>> getSessions(String userId) async {
    final result = await _apiClient.get<List<SessionModel>>(
      UsersEndPoint.sessions(userId),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => SessionModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<SessionModel>>) {
      return result.data;
    }
    throw Exception('Failed to get sessions');
  }

  @override
  Future<void> revokeSessionsForUser(
    String userId,
    List<String> sessionIds,
  ) async {
    final result = await _apiClient.post<void>(
      UsersEndPoint.sessionsRevoke(userId),
      data: {'session_ids': sessionIds},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to revoke sessions');
    }
  }

  @override
  Future<void> revokeAllSessionsForUser(String userId) async {
    final result = await _apiClient.post<void>(
      UsersEndPoint.sessionsRevokeAll2(userId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to revoke all sessions');
    }
  }

  @override
  Future<Map<String, dynamic>> getMFAStatus() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      UsersEndPoint.mfaCheck,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get MFA status');
  }

  @override
  Future<void> resetPassword(
    String userId,
    String currentPassword,
    String newPassword,
  ) async {
    final result = await _apiClient.put<void>(
      UsersEndPoint.password(userId),
      data: {'current_password': currentPassword, 'new_password': newPassword},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to reset password');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    final result = await _apiClient.post<void>(
      UsersEndPoint.passwordResetSend,
      data: {'email': email},
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to request password reset');
    }
  }

  @override
  Future<Map<String, dynamic>> linkLDAPGroups(String remoteId) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      LdapEndPoint.groupsLink(remoteId),
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to link LDAP groups for $remoteId');
  }

  @override
  Future<Map<String, dynamic>> migrateLDAPId(Map<String, dynamic> data) async {
    final result = await _apiClient.post<Map<String, dynamic>>(
      LdapEndPoint.migrateid,
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to migrate LDAP IDs');
  }

  @override
  Future<Map<String, dynamic>> getSAMLIdpCertificate() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      SamlEndPoint.certificateIdp,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get SAML IdP certificate');
  }

  @override
  Future<void> uploadSAMLMetadataFromIdp(String filePath) async {
    final response = await _apiClient.dio.post(
      SamlEndPoint.metadatafromidp,
      data: FormData.fromMap({
        'certificate': await MultipartFile.fromFile(filePath),
      }),
    );
    if (response.statusCode == null || response.statusCode! >= 400) {
      throw Exception('Failed to upload SAML metadata from IdP');
    }
  }

  @override
  Future<void> deleteSAMLIdpCertificate() async {
    final result = await _apiClient.delete(
      SamlEndPoint.certificateIdp,
    );
    if (result is ApiFailure) {
      throw Exception('Failed to delete SAML IdP certificate');
    }
  }

  @override
  Future<void> addUserToGroupSyncables(String userId) async {
    final result = await _apiClient.post<void>(
      LdapEndPoint.usersGroupSyncMemberships(userId),
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to add user to group syncables');
    }
  }

  @override
  Future<void> invalidateCaches() async {
    final result = await _apiClient.post<void>(
      CachesEndPoint.invalidate,
      fromJson: (_) {},
    );
    if (result is ApiFailure) {
      throw Exception('Failed to invalidate caches');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyIp() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      IpFilteringEndPoint.myIp,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get my IP');
  }

  @override
  Future<Map<String, dynamic>> getAuditLogsCertificate() async {
    final result = await _apiClient.get<Map<String, dynamic>>(
      AuditLogsEndPoint.certificate,
      fromJson: (json) => json as Map<String, dynamic>,
    );
    if (result is ApiSuccess<Map<String, dynamic>>) {
      return result.data;
    }
    throw Exception('Failed to get audit logs certificate');
  }

  @override
  Future<List<AllowedIPRangeModel>> getIpFilters() async {
    final result = await _apiClient.get<List<AllowedIPRangeModel>>(
      IpFilteringEndPoint.root,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AllowedIPRangeModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AllowedIPRangeModel>>) {
      return result.data;
    }
    throw Exception('Failed to get IP filters');
  }

  @override
  Future<List<AllowedIPRangeModel>> applyIpFilters(
    List<AllowedIPRangeModel> filters,
  ) async {
    final result = await _apiClient.post<List<AllowedIPRangeModel>>(
      IpFilteringEndPoint.root,
      data: filters.map((f) => f.toMap()).toList(),
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => AllowedIPRangeModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
    if (result is ApiSuccess<List<AllowedIPRangeModel>>) {
      return result.data;
    }
    throw Exception('Failed to apply IP filters');
  }

  @override
  Future<List<AuditModel>> getAudits({
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
    throw Exception('Failed to get audits');
  }

  @override
  Future<void> unlinkLDAPGroup(String remoteId) async {
    final result = await _apiClient.delete(
      LdapEndPoint.groupsLink(remoteId),
    );
    if (result is ApiFailure) {
      throw Exception('Failed to unlink LDAP group for $remoteId');
    }
  }
}
