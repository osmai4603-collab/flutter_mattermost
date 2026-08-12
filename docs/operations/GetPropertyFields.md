# Get property fields

Original OpenAPI operationId: `GetPropertyFields`
- Method: `GET`
- Path: `/api/v4/properties/groups/{group_name}/{object_type}/fields`
- Summary: Get property fields
- Description: Get a list of property fields for a specific group and object type. Uses cursor-based pagination.

**Scope modes (mutually exclusive):**

- **Hierarchical scope** (`channel_id` and/or `team_id`): returns fields scoped to the named resource *and every ancestor scope above it*. System-level rows are always included; team-level rows are included when `team_id` is set; channel-level rows are included only when `channel_id` is set. When `channel_id` is provided, the channel's team is resolved server-side, so any `team_id` the caller passes is ignored. For DM and GM channels there is no parent team, so the hierarchy collapses to `system → channel` and no team-scoped rows are returned. Requires the caller to have `read_channel` for the channel and/or `view_team` for the team.

- **Single-target scope** (`target_type` + `target_id`): returns fields scoped to exactly one resource. `target_type` must be `system`, `team`, or `channel`; `target_id` is required for `team` and `channel`.

Mixing the two modes (any of `channel_id`/`team_id` together with any of `target_type`/`target_id`) returns 400. Omitting both modes also returns 400, except for the system case below.

**System-object:** when `object_type` is `system`, the endpoint always resolves to `target_type=system` and ignores any `channel_id`, `team_id`, `target_type`, or `target_id` the caller may have passed. System-object fields can only live at the system scope by invariant, so any other scope is a semantic no-op rather than an error.

**Delta sync via `since`:** When `since > 0`, the endpoint returns rows whose `update_at` is **greater than or equal to** the cutoff, *including* tombstoned rows (`delete_at > 0`). The inclusive boundary lets clients safely re-use the highest `update_at` seen on a previous page as the next `since` value without missing rows that happened to share that millisecond. Rows within a delta page are ordered by `(update_at, id)` and the cursor disambiguates same-millisecond rows across pages.

**Cursor source:** the client owns the cursor. The initial delta-sync request omits `since` (or sends `since=0`). For subsequent requests the client persists the `update_at` and `id` of the last row in the response and passes them back as `cursor_update_at` and `cursor_id` alongside the same `since` value. This mirrors the cursor convention used by the shared-channel post-sync API.

**Cursor key must match the active ordering:** in delta mode (`since > 0`) the endpoint orders by `update_at` and pagination requires `cursor_update_at`; otherwise it orders by `create_at` and pagination requires `cursor_create_at`. Passing the wrong key for the active mode returns 400.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group
- `object_type` (path, required, string) - The type of object to retrieve property fields for
- `channel_id` (query, optional, string) - Hierarchical scope. When set, the response includes system-level rows, team-level rows for the channel's team, and channel-level rows for this channel. Mutually exclusive with `target_type` and `target_id`. Requires `read_channel` on the channel.

- `team_id` (query, optional, string) - Hierarchical scope. When set without `channel_id`, the response includes system-level and team-level rows for this team. When `channel_id` is also set, this value is ignored — the channel's team is resolved server-side and used instead. Mutually exclusive with `target_type` and `target_id`. Requires `view_team` on the team.

- `target_type` (query, optional, string) - Single-target scope. One of `system`, `team`, or `channel`. Required in single-target mode. Mutually exclusive with `channel_id` and `team_id`.

- `target_id` (query, optional, string) - Single-target scope. Required when `target_type` is `channel` or `team`. Mutually exclusive with `channel_id` and `team_id`.

- `since` (query, optional, integer) - Unix timestamp in milliseconds. When greater than 0, returns fields with `update_at` greater than or equal to this value, including tombstones.

- `cursor_id` (query, optional, string) - The ID of the last property field from the previous page, for cursor-based pagination.
- `cursor_create_at` (query, optional, integer) - The `create_at` timestamp of the last property field from the previous page. Required alongside `cursor_id` when `since` is absent. Mutually exclusive with `cursor_update_at`.

- `cursor_update_at` (query, optional, integer) - The `update_at` timestamp of the last property field from the previous page. Required alongside `cursor_id` when `since` is present. Mutually exclusive with `cursor_create_at`.

- `per_page` (query, optional, integer) - The number of property fields per page.

## Request body
No request body.

## Responses
- `200`: Property fields retrieval successful
  - `application/json` -> array of PropertyField
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
