# Get user's sessions

Original OpenAPI operationId: `GetSessions`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/sessions`
- Summary: Get user's sessions
- Description: Get a list of sessions by providing the user GUID. Sensitive information will be sanitized out.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User session retrieval successful
  - `application/json` -> array of Session
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
