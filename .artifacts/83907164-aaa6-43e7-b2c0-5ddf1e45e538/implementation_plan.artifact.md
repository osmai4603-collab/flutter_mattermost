# Implementation Plan - Team and Channel Management Enhancements

This plan outlines the steps to implement a team creation popup, sync channel sidebar with channel creation, and implement favorite/unfavorite functionality in the channel header.

## Proposed Changes

### [Team Management]

#### [MODIFY] [team_repository.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/teams/domain/repositories/team_repository.dart)
- Add `createTeam` method to the interface.

#### [MODIFY] [team_repository_impl.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/teams/data/repositories/team_repository_impl.dart)
- Implement `createTeam` using `TeamsRemoteDataSource`.

#### [MODIFY] [team_bloc.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/teams/presentation/bloc/team_bloc.dart)
- Add `CreateTeamEvent`.
- Add `TeamCreatedState` (optional, or just reload teams).
- Handle `CreateTeamEvent` in the bloc.

#### [NEW] [create_new_team.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/teams/presentation/pages/create_new_team.dart)
- Create a new dialog for team creation, styled similar to `create_new_channel.dart`.

#### [MODIFY] [team_switcher.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/widgets/team_switcher.dart)
- Update `_AddTeamIcon` to show the `CreateNewTeam` dialog.

---

### [Channel Management & Sidebar Sync]

#### [VERIFY] [create_new_channel.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/pages/create_new_channel.dart)
- Ensure channel creation logic is correct and it triggers a refresh in `ChannelBloc`.

#### [MODIFY] [channel_sidebar.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/widgets/channel_sidebar/channel_sidebar.dart)
- Ensure it listens to `ChannelBloc` and rebuilds when a new channel is added. (Already seems to be the case, will verify).

---

### [Favorite/Unfavorite Functionality]

#### [MODIFY] [channel_header.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/channel_header.dart)
- Ensure the favorite button correctly calls `ToggleFavoriteEvent`. (Already implemented, will verify).
- Ensure errors are handled and displayed (e.g., via `BlocListener`).

#### [VERIFY] [channel_bloc.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/bloc/channel_bloc.dart)
- Ensure `ToggleFavoriteEvent` correctly updates the local state and the server.

## Verification Plan

### Automated Tests
- N/A (Manual verification on device/emulator is preferred for UI interactions).

### Manual Verification
1.  Open the app and tap the "Add Team" button in the team switcher.
2.  Fill in the team details and save. Verify the team appears in the list.
3.  Create a new channel using the "Create Channel" dialog. Verify it appears in the sidebar under the selected category.
4.  Open a channel and tap the star icon in the header. Verify the channel moves to the "Favorites" category in the sidebar.
5.  Tap the star icon again to unfavorite. Verify it moves back to its original category.
