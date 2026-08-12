# Get posts for reporting and compliance purposes using cursor-based pagination

Original OpenAPI operationId: `GetPostsForReporting`
- Method: `POST`
- Path: `/api/v4/reports/posts`
- Summary: Get posts for reporting and compliance purposes using cursor-based pagination
- Description: Get posts from a specific channel for reporting, compliance, and auditing purposes. This endpoint uses cursor-based pagination to efficiently retrieve large datasets.
The cursor is an opaque, base64-encoded token that contains all pagination state. Clients should treat the cursor as an opaque string and pass it back unchanged. When a cursor is provided, query parameters from the initial request are embedded in the cursor and take precedence over request body parameters.
##### Permissions
Requires `manage_system` permission (system admin only).
##### License
Requires an Enterprise license (or higher).
##### Features
- Cursor-based pagination for efficient large dataset retrieval - Support for both create_at and update_at time fields - Ascending or descending sort order - Time range filtering with optional end_time - Include/exclude deleted posts - Exclude system posts (any type starting with "system_") - Optional metadata enrichment (file info, reactions, emojis, priority, acknowledgements)

- Tags: reports

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Posts retrieved successfully
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
