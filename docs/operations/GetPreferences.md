# Get the user's preferences

Original OpenAPI operationId: `GetPreferences`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/preferences`
- Summary: Get the user's preferences
- Description: Get a list of the user's preferences.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: preferences

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User preferences retrieval successful
  - `application/json` -> array of Preference
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
