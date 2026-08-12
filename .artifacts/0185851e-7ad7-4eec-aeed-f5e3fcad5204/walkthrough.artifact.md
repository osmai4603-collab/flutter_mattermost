# API Operations Implementation Walkthrough

I have analyzed the API operations in `docs/operations/` and identified several missing or incomplete implementations in the `datasources`. I have implemented the most critical missing operations across several features.

## Changes Made

### Admin Feature
- **AdminRemoteClusterDataSource**:
    - Added `uploadRemoteClusterData` (`POST /remotecluster/upload/{upload_id}`).
    - Added `getRemoteClusterInfo` (`GET /sharedchannels/remote_info/{remote_id}`).
- **AdminCloudDataSource**:
    - Added `getInstallationInfo` (`GET /cloud/installation`).
    - Added `postCwsWebhook` (`POST /cloud/webhook`).
- **AdminAgentsDataSource** [NEW]:
    - Implemented `getAgents` (`GET /agents`).
    - Implemented `getAgentsStatus` (`GET /agents/status`).
- **AdminComplianceDataSource**:
    - Added `getSystemAudits` (`GET /audits`).
    - Added `addAuditLogCertificate` (`POST /audit_logs/certificate`).
    - Added `removeAuditLogCertificate` (`DELETE /audit_logs/certificate`).
- **AdminSecurityDataSource**:
    - Added `deleteSAMLIdpCertificate` (`DELETE /saml/certificate/idp`).
    - Added `addUserToGroupSyncables` (`POST /ldap/users/{user_id}/group_sync_memberships`).
    - Added `invalidateCaches` (`POST /caches/invalidate`).

### Users Feature
- **UsersRemoteDataSource**:
    - Added `deleteUser` (`DELETE /users/{user_id}`).
    - Added `permanentDeleteAllUsers` (`DELETE /users`).
    - Added `getUserAccessTokens` (`GET /users/tokens`).

### Teams Feature
- **TeamMembersRemoteDataSource**:
    - Added `addMemberFromInvite` (`POST /teams/members/invite`).

## Verification Results

- All new methods follow the established `ApiClient` pattern and use the correct `Endpoints` constants.
- The `Injectable` annotations are preserved for automatic dependency injection.
- The data models used for return types (e.g., `AgentModel`, `AuditModel`) were verified to exist.

> [!NOTE]
> Due to the large number of operations (over 300 total), I have focused on the core and admin features. Further iterations may be needed for specific plugins like Playbooks if required.
