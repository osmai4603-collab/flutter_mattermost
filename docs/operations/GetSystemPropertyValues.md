# Get property values for the system

Original OpenAPI operationId: `GetSystemPropertyValues`
- Method: `GET`
- Path: `/api/v4/properties/groups/{group_name}/system/values`
- Summary: Get property values for the system
- Description: Get all property values attached to the Mattermost instance itself within a group. System-scoped values are readable by any authenticated user. This endpoint is the dedicated route for `system` object type; the `{object_type}/values/{target_id}` route returns 400 for `system`.

**Delta sync via `since`:** When `since > 0`, the endpoint returns only rows whose `update_at` is greater than the cutoff, *including* tombstones.

**Cursor key must match the active ordering:** in delta mode (`since > 0`) the endpoint orders by `update_at` and pagination requires `cursor_update_at`; otherwise it orders by `create_at` and pagination requires `cursor_create_at`.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group
- `since` (query, optional, integer) - Unix timestamp in milliseconds. When greater than 0, returns values with `update_at` greater than or equal to this value, including tombstones.

- `cursor_id` (query, optional, string) - The ID of the last property value from the previous page, for cursor-based pagination.
- `cursor_create_at` (query, optional, integer) - The `create_at` timestamp of the last property value from the previous page. Required alongside `cursor_id` when `since` is absent. Mutually exclusive with `cursor_update_at`.

- `cursor_update_at` (query, optional, integer) - The `update_at` timestamp of the last property value from the previous page. Required alongside `cursor_id` when `since` is present. Mutually exclusive with `cursor_create_at`.

- `per_page` (query, optional, integer) - The number of property values per page.

## Request body
No request body.

## Responses
- `200`: System property values retrieval successful
  - `application/json` -> array of PropertyValue
- `400`: No description available.
- `401`: No description available.
