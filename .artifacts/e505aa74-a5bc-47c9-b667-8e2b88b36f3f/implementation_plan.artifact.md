# Implementation Plan - Saved Messages Feature

This plan aims to enhance the "Saved Messages" (flagged posts) feature to match the detailed specifications provided by the user, ensuring consistency across both the main page and the Right Sidebar (RHS).

## User Review Required

> [!IMPORTANT]
> The current implementation already uses Mattermost's "Flagging" mechanism for Saved Messages. We will enhance the existing `SavedPinnedPanel` to meet the visual and functional requirements.

## Proposed Changes

### Feature: Saved Messages Page & RHS Panel

#### [MODIFY] [saved_pinned_panel.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/rhs/saved_pinned_panel.dart)
- Update `_SavedPinnedPanelState` to track channel archive status.
- Refactor `_channelNames` to store more info about channels (e.g., if they are archived).
- Update `_PostRow` (the card component):
    - Display a badge for archived channels using `l10n.channelViewArchivedChannel`.
    - Correcty handle deleted messages (`post.deleteAt > 0`) showing `l10n.postDeleted`.
    - Correcty handle edited messages (`post.editAt > 0`) showing `l10n.postEdited`.
    - Ensure the "Jump to Message" button matches the spec.
    - Enhance "Quick Actions" bar: Add Emoji reaction picker (placeholder/icon), Reply (opens thread), and Share.
    - Ensure `channelName` click navigates to the channel (it already does via `onTap` of the whole row, but we can make it more explicit).

#### [MODIFY] [rhs_container.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/rhs/rhs_container.dart)
- Fix the `RhsPanel.flagged` case in `_RhsBody` to return `SavedPinnedPanel(isPinned: false)` instead of a generic empty body.

#### [MODIFY] [saved_messages_page.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/pages/saved_messages_page.dart)
- Ensure the header styling (title and total count) is consistent with the webapp/spec.

## Verification Plan

### Automated Tests
- N/A (UI-centric change, manual verification preferred).

### Manual Verification
1. Open "Saved Messages" from the Left Sidebar.
    - Verify header title and count.
    - Verify the list of cards.
    - Verify empty state if no messages are saved.
2. Interact with a Saved Message card:
    - Click "Jump" to navigate to the original channel context.
    - Click the bookmark icon to "Unsave" and observe the message disappear.
    - Verify Emoji, Reply, and Share buttons are present.
3. Verify handling of special states:
    - Save a message from a channel that gets archived later. Verify the "Archived" badge appears.
    - Edit/Delete a saved message in its original channel. Verify the card updates (or reflects the status).
4. Open the Right Sidebar (RHS) and select "Saved Messages".
    - Verify it shows the same list of cards in a more compact width.
