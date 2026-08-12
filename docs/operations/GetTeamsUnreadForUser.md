# Get team unreads for a user

Original OpenAPI operationId: `GetTeamsUnreadForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams/unread`
- Summary: Get team unreads for a user
- Description: Get the count for unread messages and mentions in the teams the user is a member of.
##### Permissions
Must be logged in.

- Tags: teams

## Parameters
- `user_id` (path, required, string) - User GUID
- `exclude_team` (query, required, string) - Optional team id to be excluded from the results
- `include_collapsed_threads` (query, optional, boolean) - Boolean to determine whether the collapsed threads should be included or not

## Request body
No request body.

## Responses
- `200`: Team unreads retrieval successful
  - `application/json` -> array of TeamUnread
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
