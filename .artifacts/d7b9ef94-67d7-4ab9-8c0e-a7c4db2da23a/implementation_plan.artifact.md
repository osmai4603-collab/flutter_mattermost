# Implementation Plan - Team Selection & DM Sidebar Improvements

Enhance team selection logic to be seamless, automatically select a default channel, and improve Direct Message sidebar with member names and accurate user status.

## User Review Required

> [!IMPORTANT]
> The team switching will now be "seamless", meaning the old sidebar content remains visible until the new team's channels are loaded, avoiding the `CircularProgressIndicator`.
> The default channel selected upon team switch will prioritize the first Public or Private channel found in the team.

## Proposed Changes

### [Channel Feature]

#### [MODIFY] [channel_bloc.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/bloc/channel_bloc.dart)
- Update `LoadChannelsForTeamEvent` to include a `seamless` boolean flag.
- In `_onLoadChannels`, skip emitting `ChannelLoadingState` if `seamless` is true.
- Improve default channel selection logic to prioritize `ChannelType.open` or `ChannelType.private`.

#### [MODIFY] [team_switcher.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/widgets/team_switcher.dart)
- Update `TeamSwitcher` to dispatch `LoadChannelsForTeamEvent` with `seamless: true` when a team is tapped.
- Ensure the `userId` is passed correctly to the event.

### [User Status & DM Feature]

#### [MODIFY] [user_status_bloc.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/users/presentation/bloc/user_status_bloc.dart)
- Add a new event `LoadMyStatusEvent` to fetch the current user's status.
- Ensure `LoadUserStatusesEvent` can also handle fetching the current user's status if needed.

#### [MODIFY] [channel_sidebar_header.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/widgets/channel_sidebar/channel_sidebar_header.dart)
- Integrate `_UserChip` into the header to display the current user's profile and status indicator prominently.

#### [MODIFY] [direct_message_category_widget.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/widgets/channel_sidebar/direct_message_category_widget.dart)
- Ensure statuses and profiles are requested for all DM/GM counterparts, including the current user for "self-DMs".

## Verification Plan

### Automated Tests
- N/A (Manual verification on device preferred for UI/UX flow).

### Manual Verification
- **Team Switch**: Tap different teams and verify the sidebar updates without a spinner and selects a public channel by default.
- **DM Sidebar**: Open the DM category and verify names are shown as "First Last" or "username" and status indicators (online, away, etc.) are present and correct.
- **User Status**: Check the sidebar header to see the current user's status matches their actual status.
