# Fix StatefulShellBranch Parameterized Route Exception

The app is currently crashing with the exception: `The default location of a StatefulShellBranch cannot be a parameterized route`. This is caused by using `StatefulShellRoute` in `lib/app/routes/integration_route.dart` where the branches start with routes containing the `:team` path parameter.

## Proposed Changes

### Routing Configuration

#### [MODIFY] [integration_route.dart](file:///home/osmsoftwareengineering/StudioProjects/flutter_mattermost/lib/app/routes/integration_route.dart)
Restructure `integrationRoute` to use nesting. By wrapping the `StatefulShellRoute` in a `GoRoute` that handles the `/:team/integrations` path, we can make the branch routes relative (e.g., `incoming`, `outgoing`) so they no longer contain path parameters in their individual `path` strings. This satisfies the `go_router` requirement while maintaining the desired URL structure and team context.

- Wrap `StatefulShellRoute.indexedStack` inside a `GoRoute` with path `/:team/integrations`.
- Add a `redirect` to the parent `GoRoute` to ensure that navigating to `/:team/integrations` defaults to the first integration branch (e.g., `incoming`).
- Change the `path` of each branch's root `GoRoute` to be relative (e.g., `incoming`, `outgoing`, `commands`, `bots`, `oauth`).
- Ensure all builders still receive the `team` parameter from `state.pathParameters`.

## Verification Plan

### Manual Verification
- Run the app and verify it no longer crashes on startup.
- Navigate to a team and then to the Integrations section.
- Verify that switching between integration tabs (Incoming Webhooks, Outgoing Webhooks, etc.) works correctly and preserves state if intended.
- Verify that the URL correctly reflects the team and the selected integration section.
