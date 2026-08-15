# Implementation Plan - Fetching Real Data for Admin Console Pages

This plan outlines the steps to replace hardcoded/default data in various Admin Console pages with real data fetched from the Mattermost API.

## User Review Required

> [!IMPORTANT]
> Some pages like "Users Management" show columns for "Messages Posted" and "Channel Count" which are not natively part of the `UserEntity`. These will be hidden or set to "N/A" if the specific reporting API for these counts is not easily accessible, to avoid showing incorrect mock data.

## Proposed Changes

### [Admin Feature]

#### [MODIFY] [AnalyticsEntity](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/admin/domain/entities/analytics_entity.dart)
- Fix the `_intOf` method to correctly return the value for the requested metric name instead of always checking for `total_users`.

#### [MODIFY] [AdminConsoleSiteOverviewPage](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/admin/presentation/pages/site_overview_page.dart)
- Integrate `AdminConfigRepository` to fetch analytics data.
- Replace hardcoded metrics ("Total Channels", "Posts & Messages") with data from `AnalyticsEntity`.
- Replace hardcoded server version, uptime, and database info in the health banner with data from the system configuration.
- Fetch real values for the system health checklist if available (e.g., SMTP status, Plugin status).

#### [MODIFY] [AdminConsoleUsersManagementPage](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/admin/presentation/pages/users_management/users_management_page.dart)
- Remove `_defaultUsers` mock data.
- Ensure the UI handles empty states and errors gracefully without falling back to mock users.
- Update "Member Since" to use `createAt` from `UserEntity`.

#### [MODIFY] [AdminConsoleTeamsManagementPage](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/admin/presentation/pages/users_management/teams_management_page.dart)
- Remove `_defaultTeams` mock data.
- Fetch `TeamStatsEntity` for each team to display real member and channel counts instead of hardcoded strings.

#### [MODIFY] [AdminConsoleChannelsManagementPage](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/admin/presentation/pages/users_management/channels_management_page.dart)
- Remove `_defaultChannels` mock data.
- Fetch `ChannelStats` for each channel to display real member counts.
- Ensure "Team" name is displayed correctly (currently hardcoded as "Core Engineering").

## Verification Plan

### Automated Tests
- No new automated tests are planned, but existing tests for the admin feature should pass.
- Verify that the app still builds and runs correctly.

### Manual Verification
- Navigate to the Admin Console pages (Site Overview, Users, Teams, Channels).
- Verify that data is being loaded (loading indicators should appear).
- Verify that the data displayed matches what is expected from a real or test server (no more "1248" users or "Jan 2024" dates across the board).
- Check the logs to ensure no API errors are occurring during data fetching.
