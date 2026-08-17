# Implementation Plan - Remove Direct Replies from Message List

Remove the display of replies (non-root posts) from the main chat message list, making them accessible only via the thread footer (RHS).

## User Review Required

> [!IMPORTANT]
> Replies will no longer appear as individual items in the main chat flow. Users will need to click on the "Replies" link at the bottom of a message to view the conversation thread in the right-hand sidebar.

## Proposed Changes

### [Chat Feature]

#### [MODIFY] [message_list.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/message_list.dart)
- Update the `_PostListBody` build loop to skip posts that have a non-empty `rootId`.
- Adjust the logic for date separators and "New Messages" indicators to ensure they work correctly with the filtered list of root posts.

## Verification Plan

### Automated Tests
- N/A

### Manual Verification
- **Message List**: Verify that only root messages are displayed in the channel.
- **Replies**: Verify that replying to a message does not add a new item to the main list, but updates the reply count on the root message.
- **Thread Panel**: Verify that clicking the reply count still opens the RHS with the full thread (root + replies).
