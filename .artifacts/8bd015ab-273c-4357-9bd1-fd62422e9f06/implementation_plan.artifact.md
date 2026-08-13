# Implementation Plan - Admin Console Routing Fix

Ensure the Admin Console routing is robust, fully featured, and consistent with the project's stateful navigation architecture.

## User Review Required

> [!IMPORTANT]
> The Admin Console will be refactored to use 18 separate `StatefulShellBranch`es. This ensures that each section (Overview, Logs, Security, etc.) maintains its own state (e.g., scroll position, form data) when switching between them in the sidebar.

## Proposed Changes

### [Routing]

#### [MODIFY] [admin_console_route.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/app/routes/admin_console_route.dart)
- Update `AdminConsoleRoutes` constants to include `analytics`.
- Refactor `adminRoute` to include 18 branches, one for each `AdminConsoleSection` enum value.
- Map each branch to the correct page component (e.g., branch 0 -> Overview/Analytics, branch 1 -> Logs).

### [UI Components]

#### [MODIFY] [admin_sidebar.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/admin/presentation/widgets/admin_sidebar.dart)
- Add a "Back" button in the header (a back arrow icon) that navigates back to the team home page.
- This provides a clear exit path from the Admin Console back to the chat interface.

#### [MODIFY] [admin_console_shell.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/features/admin/presentation/widgets/admin_console_shell.dart)
- Ensure the `onSelected` callback correctly triggers `navigationShell.goBranch`.
- Verify the `selected` section logic correctly maps the current branch index to the enum.

## Verification Plan

### Manual Verification
- Verify navigating to `/admin_console` loads the Overview (Analytics) page.
- Verify clicking different sections in the Admin Sidebar updates the content and URL.
- Verify that switching between sections preserves state (e.g., scroll partially down Logs, switch to Users, switch back to Logs; it should stay scrolled).
- Verify the "Back" button in the Admin Sidebar correctly returns to the chat interface.
