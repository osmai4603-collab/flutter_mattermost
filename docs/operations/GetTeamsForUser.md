# Get a user's teams

Original OpenAPI operationId: `GetTeamsForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/teams`
- Summary: Get a user's teams
- Description: Get a list of teams that a user is on.
##### Permissions
Must be authenticated as the user or have the `manage_system` permission.

- Tags: teams

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Team list retrieval successful
  - `application/json` -> array of Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
