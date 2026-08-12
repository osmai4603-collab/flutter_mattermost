# Get analytics

Original OpenAPI operationId: `GetAnalyticsOld`
- Method: `GET`
- Path: `/api/v4/analytics/old`
- Summary: Get analytics
- Description: Get some analytics data about the system. This endpoint uses the old format, the `/analytics` route is reserved for the new format when it gets implemented.

The returned JSON changes based on the `name` query parameter but is always key/value pairs.

__Minimum server version__: 4.0

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
- `name` (query, optional, string) - Possible values are "standard", "bot_post_counts_day", "post_counts_day", "user_counts_with_posts_day" or "extra_counts"
- `team_id` (query, optional, string) - The team ID to filter the data by

## Request body
No request body.

## Responses
- `200`: Analytics retrieval successful
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
