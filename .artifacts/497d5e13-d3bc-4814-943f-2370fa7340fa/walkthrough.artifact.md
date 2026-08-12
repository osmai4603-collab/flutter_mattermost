# Walkthrough - Integrating Missing Operations and Strongly-Typed Models

I have completed the task of analyzing all operations in `docs/operations`, integrating missing ones into the `datasources`, and ensuring every operation returns its corresponding model instead of generic maps.

## Changes Overview

### 1. Data Source Enhancements
I have updated over 20 DataSources across various features to include missing operations from the OpenAPI documentation and ensured that return types are strongly-typed models.

#### Key DataSources Updated:
- **Users**: [UsersRemoteDataSource](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/users/data/datasources/users_remote_data_source.dart)
    - Added: `getUserLoginType`, `publishUserTyping`, `attachDeviceExtraProps`, etc.
    - Updated: `getTotalUsersStats`, `getUserTermsOfService`, and others now return models like `UsersStatsModel` and `UserTermsOfServiceModel`.
- **Teams**: [TeamsRemoteDataSource](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/teams/data/datasources/teams_remote_data_source.dart)
    - Added: `addTeamMember`, `inviteUsersToTeam`, `softDeleteTeam`, `getTeamIcon`, etc.
    - Updated: `getTeamStats`, `getTeamMember` now return `TeamStatsModel` and `TeamMemberModel`.
- **Channels**: [ChannelRemoteDataSource](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/channels/data/datasources/channels_remote_data_source.dart)
    - Added: `addChannelMember`, `getChannelMembers`, `sidebarCategory` operations, etc.
    - Updated: `getChannelStats`, `markChannelAsViewed` now return `ChannelStatsModel` and `ChannelUnreadModel`.
- **Posts/Chat**: [PostRemoteDataSource](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/chat/data/datasources/chat_remote_data_sources.dart)
    - Added: `deleteAcknowledgementForPost`, `getPostsUsage`, `setThreadUnreadByPostId`, etc.
    - Updated: `getPostInfo` now returns `PostInfoModel`.
- **Playbooks**: [PlaybooksRemoteDataSource](file:///C:/Users/HC/Documents/projects/flutter_mattermost/lib/features/common/data/datasources/playbooks_remote_data_source.dart)
    - Added: `changeOwner`, `deletePlaybook`, `endPlaybookRun`, `restartPlaybookRun`, etc.
- **Admin Features**: Updated `AdminConfig`, `AdminCloud`, `AdminSecurity`, `AdminDataRetention`, and `AdminPlugins` data sources with missing operations and models.

### 2. Model Integration
- Integrated existing models like `UsersStatsModel`, `UserTermsOfServiceModel`, `UploadSessionModel`, `CustomAttributeValueModel`, `ChannelStatsModel`, and many others into the data source method signatures.
- This ensures that the application layer receives structured data, improving type safety and reducing runtime errors.

### 3. Missing Operations Cleanup
I systematically went through the `missing_operations.txt` file (which contained over 200 items) and ensured each one is either already implemented or has been added to the appropriate data source.

## Verification Results
- All updated DataSources maintain their `injectable` annotations for DI.
- Method signatures match the requirements of returning typed models.
- API endpoints used in new methods were verified against `UsersEndPoint`, `TeamsEndPoint`, `ChannelsEndPoint`, etc.

> [!NOTE]
> Some operations from the documentation are variants or aliases of existing methods. I have ensured that the underlying API implementation covers all documented functionality.

> [!TIP]
> After these changes, it is recommended to run the build runner to update any generated code for DI or models:
> `dart run build_runner build --delete-conflicting-outputs`
