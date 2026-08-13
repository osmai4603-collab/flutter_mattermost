# Implementation Plan - Enhancing Threads View

This plan aims to implement the detailed Threads View features described by the user, covering Global Threads, RHS Thread View, and the Message Editor's thread-specific functionality.

## User Review Required

> [!IMPORTANT]
> The implementation will include updating the `ThreadEntity` and `ThreadModel` to support participants, which might affect how threads are stored or transmitted if there's a local database or specific API mapping. I will assume the server API already provides participant data in the `UserThread` object.

## Proposed Changes

### [Chat Domain & Data]

#### [MODIFY] [thread_entity.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/domain/entities/thread_entity.dart)
- Add `participants` field (List of User IDs or User objects) to `ThreadEntity`.

#### [MODIFY] [thread_model.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/data/models/thread_model.dart)
- Update `fromMap` and `toMap` to handle the `participants` field.

#### [MODIFY] [threads_repository.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/domain/repositories/threads_repository.dart)
- Add `markAllThreadsAsRead` method.

#### [MODIFY] [threads_repository_impl.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/data/repositories/threads_repository_impl.dart)
- Implement `markAllThreadsAsRead`.

---

### [Chat BLOC]

#### [MODIFY] [threads_bloc.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/bloc/threads_bloc.dart)
- Add `FollowThreadEvent`, `UnfollowThreadEvent`, and `MarkAllThreadsReadEvent`.
- Implement handlers for these events using the repository.
- Ensure `ThreadsLoadedState` updates correctly when these actions occur.

---

### [Chat UI - Global Threads]

#### [MODIFY] [threads_page.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/pages/threads_page.dart)
- **Header**: Add "Mark all as read" button.
- **Thread List**: Replace `_ThreadRow` with a more comprehensive `ThreadCard` widget.
- **ThreadCard**:
    - Parent post author details (avatar, name, timestamp).
    - Channel badge (clickable to navigate to channel).
    - Message preview with Markdown support.
    - Participants list (horizontal avatars).
    - Reply count and last reply time.
    - Follow/Unfollow toggle button.
    - Unread indicator (bold text and side accent).
- **Empty States**: Enhance with illustrations and descriptive text for "No threads" and "No unreads".

---

### [Chat UI - RHS & Editor]

#### [MODIFY] [message_editor.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/editor/message_editor.dart)
- Add "Also send to channel" checkbox when `rootId` is present (replying to a thread).
- Bind the checkbox value to the `SendPostEvent`.

#### [MODIFY] [thread_panel_body.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/chat/presentation/rhs/thread_panel_body.dart)
- Handle "Archived / Deleted Parent" state by showing a read-only warning and disabling the editor.

## Verification Plan

### Automated Tests
- Unit tests for `ThreadsBloc` to verify follow/unfollow and mark all read logic.
- Widget tests for `ThreadCard` to ensure all components (avatars, badges, actions) are rendered correctly.

### Manual Verification
1. Open Global Threads from the sidebar.
2. Verify "All" and "Unreads" filters.
3. Verify "Mark all as read" functionality.
4. Interact with a `ThreadCard`: toggle follow status, click channel badge.
5. Open a thread in RHS and verify "Also send to channel" checkbox in the editor.
6. Verify archived channel thread behavior (read-only).
