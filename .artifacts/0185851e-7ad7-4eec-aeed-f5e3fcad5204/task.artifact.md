# Task List - Implement Missing API Operations

- [x] Catalog and Map Operations
- [x] Update Admin Feature Data Sources
    - [x] AdminRemoteClusterDataSource: Add `UploadRemoteClusterData`, `GetRemoteClusterInfo`
    - [x] AdminCloudDataSource: Add `GetInstallationInfo`, `PostCwsWebhook`
    - [x] AdminAgentsDataSource: [NEW] Implement `GetAgents`, `GetAgentsStatus`
    - [x] AdminComplianceDataSource: Add `GetSystemAudits`, `AddAuditLogCertificate`, `RemoveAuditLogCertificate`
    - [x] AdminSecurityDataSource: Add `DeleteSamlIdpCertificate`, `AddUserToGroupSyncables`, `InvalidateCaches`
- [x] Update Users Feature Data Sources
    - [x] UsersRemoteDataSource: Add `DeleteUser`, `PermanentDeleteAllUsers`, `GetUserAccessTokens`
- [x] Update Teams Feature Data Sources
    - [x] TeamMembersRemoteDataSource: Add `AddMemberFromInvite`
- [x] Update Chat Feature Data Sources
    - [x] EmojiRemoteDataSource: Verified `autocompleteCustomEmoji` exists.
