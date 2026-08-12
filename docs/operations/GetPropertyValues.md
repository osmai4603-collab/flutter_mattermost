# Get property values for a target

Original OpenAPI operationId: `GetPropertyValues`
- Method: `GET`
- Path: `/api/v4/properties/groups/{group_name}/{object_type}/values/{target_id}`
- Summary: Get property values for a target
- Description: Get all property values for a specific target within a group. Uses cursor-based pagination. The `template` object type cannot have values and will return 400. The `system` object type must use the dedicated `/api/v4/properties/groups/{group_name}/system/values` endpoint and will return 400 on this route.

**Delta sync via `since`:** When `since > 0`, the endpoint returns only rows whose `update_at` is greater than the cutoff, *including* tombstoned rows.

**Cursor key must match the active ordering:** in delta mode (`since > 0`) the endpoint orders by `update_at` and pagination requires `cursor_update_at`; otherwise it orders by `create_at` and pagination requires `cursor_create_at`.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group
- `object_type` (path, required, string) - The type of object
- `target_id` (path, required, string) - The ID of the target object
- `since` (query, optional, integer) - Unix timestamp in milliseconds. When greater than 0, returns values with `update_at` greater than or equal to this value, including tombstones.

- `cursor_id` (query, optional, string) - The ID of the last property value from the previous page, for cursor-based pagination.
- `cursor_create_at` (query, optional, integer) - The `create_at` timestamp of the last property value from the previous page. Required alongside `cursor_id` when `since` is absent. Mutually exclusive with `cursor_update_at`.

- `cursor_update_at` (query, optional, integer) - The `update_at` timestamp of the last property value from the previous page. Required alongside `cursor_id` when `since` is present. Mutually exclusive with `cursor_create_at`.

- `per_page` (query, optional, integer) - The number of property values per page.

## Request body
No request body.

## Responses
- `200`: Property values retrieval successful
  - `application/json` -> array of PropertyValue
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
