# Implementation Plan - Saved Messages (Bookmarking) Feature

Implement the "Saved Messages" feature as a personal bookmarking tool, providing easy access to flagged posts through both the Left Sidebar (LHS), Right Sidebar (RHS), and a dedicated main view.

## User Review Required

> [!IMPORTANT]
> The "Saved Messages" feature corresponds to "Flagged Posts" in the Mattermost API and webapp. The UI will use the "Saved Messages" (الرسائل المحفوظة) terminology as requested.

## Proposed Changes

### [Navigation & Sidebar]

#### [MODIFY] [channel_route.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/app/routes/channel_route.dart)
- Add route for `/:team/saved` (Saved Messages page).

#### [MODIFY] [channel_sidebar.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/channels/presentation/widgets/channel_sidebar.dart)
- Add a "Global Sections" area above the categories.
- Include "Threads" and "Saved Messages" links.
- "Saved Messages" link will navigate to the new page.

### [UI Components]

#### [NEW] [saved_messages_page.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/pages/saved_messages_page.dart)
- A full-screen page to view all saved messages.
- Reuses the core listing logic from `SavedPinnedPanel`.
- Header with title and count.

#### [MODIFY] [saved_pinned_panel.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/rhs/saved_pinned_panel.dart)
- Refactor to support a more "card-like" UI as per user spec.
- **Card Enhancements**:
    - Add Channel link at the top (e.g., #channel-name).
    - Add "Jump to message" action.
    - Highlight bookmark icon (filled/colored) when saved.
    - Add quick actions (Emoji, Reply, Share).
- **Empty State**:
    - Add an illustration (using `FlutterLogo` or a placeholder icon if no specific asset is available).
    - Add detailed instructions in Arabic.
- **Header**:
    - Add total count of items.

### [Functionality]

#### [MODIFY] [post_row.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/post_row.dart) (if applicable) or `_PostRow` in `saved_pinned_panel.dart`.
- Ensure the "Jump to Message" logic correctly navigates to the channel and scrolls to the specific post ID.

## Verification Plan

### Manual Verification
- Verify the "Saved Messages" link appears in the LHS.
- Verify clicking it opens the main page.
- Verify clicking the bookmark icon in a channel header opens the RHS panel.
- Verify the RHS panel UI matches the "card" specification.
- Verify "Jump to message" works across different channels.
- Verify the Empty State displays correctly with the new instructions.
