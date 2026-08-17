# Walkthrough - Hidden Replies in Message List

We have updated the main chat interface to hide replies (non-root messages) from the direct message list. These replies are now only accessible through the thread view in the right-hand sidebar (RHS).

## Changes Made

### Chat UI
- **Filtered Message List**: Modified the `PostList` widget in [message_list.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/widgets/message_list.dart) to filter out any post that has a `rootId`. This ensures that only original messages (root posts) are displayed in the main channel flow.
- **Maintained Thread Context**: The logic that calculates reply counts and thread participants still processes all messages (including hidden replies). This ensures that the "Replies" footer on root messages remains accurate and functional.
- **Consistent Indicators**: Adjusted the "New Messages" and date separator logic to align with the filtered list of visible root posts.

## Verification Results

- **Root Messages**: Only original messages appear in the main chat.
- **Replies**: When a user replies to a message, the reply no longer appears as a new item in the main list.
- **Thread Access**: Clicking the "Replies" link on a root message correctly opens the RHS sidebar, where all replies in the thread are visible as expected.
