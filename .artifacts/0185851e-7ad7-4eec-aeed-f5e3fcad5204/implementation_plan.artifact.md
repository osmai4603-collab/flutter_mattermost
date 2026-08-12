# Analyze and Implement Missing API Operations

The goal is to analyze the API operations defined in `docs/operations/` and ensure that all missing operations are implemented in the appropriate `datasources` in the project.

## User Review Required

> [!IMPORTANT]
> There are approximately 287 operations that appear to be missing or named differently in the current data sources. Implementing all of them in a single task is extremely large. I will proceed with a systematic analysis and implement them feature by feature, starting with the most critical ones (Admin, Users, Channels, Teams, Posts).

> [!WARNING]
> Many operations might already be implemented but with different names than the OpenAPI `operationId`. I will perform a semantic check (checking paths and methods) to avoid duplication.

## Proposed Changes

### Research & Analysis
- [ ] Catalog all operations from `docs/operations/*.md`.
- [ ] Map each operation to a feature based on its tags.
- [ ] Compare the (Method, Path) of each operation with existing `endpoints.dart` and `datasources`.

### Feature: Admin
- [ ] Update `admin_access_control_data_source.dart` with missing operations.
- [ ] Update `admin_cloud_data_source.dart`.
- [ ] Update `admin_compliance_data_source.dart`.
- [ ] Update `admin_config_data_source.dart`.
- [ ] Update `admin_content_flagging_data_source.dart`.
- [ ] Update `admin_custom_properties_data_source.dart`.
- [ ] Update `admin_data_retention_data_source.dart`.
- [ ] Update `admin_imports_exports_data_source.dart`.
- [ ] Update `admin_jobs_data_source.dart`.
- [ ] Update `admin_license_data_source.dart`.
- [ ] Update `admin_plugins_data_source.dart`.
- [ ] Update `admin_remotecluster_data_source.dart`.
- [ ] Update `admin_reports_data_source.dart`.
- [ ] Update `admin_security_data_source.dart`.
- [ ] Update `admin_shared_channels_data_source.dart`.

### Feature: Users
- [ ] Update `users_remote_data_source.dart`.
- [ ] Update `user_preferences_remote_data_source.dart`.
- [ ] Update `user_status_remote_data_source.dart`.

### Feature: Channels
- [ ] Update `channels_remote_data_source.dart`.
- [ ] Update `channel_members_remote_data_source.dart`.

### Feature: Teams
- [ ] Update `teams_remote_data_source.dart`.
- [ ] Update `team_members_remote_data_source.dart`.

### Feature: Chat (Posts, Emoji, Files, Reactions)
- [ ] Update `chat_remote_data_sources.dart`.
- [ ] Update `emoji_remote_data_source.dart`.
- [ ] Update `files_remote_data_source.dart`.
- [ ] Update `reactions_remote_data_source.dart`.

## Verification Plan

### Automated Tests
- I will verify that the new methods are added correctly to the interfaces and implementations.
- I will check that the endpoints are correctly defined in `core/endpoints/`.

### Manual Verification
- N/A for data source implementation without UI, but I will ensure the code compiles and `injectable` can generate the necessary code.
