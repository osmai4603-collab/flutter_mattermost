# Delete user's preferences

Original OpenAPI operationId: `DeletePreferences`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/preferences/delete`
- Summary: Delete user's preferences
- Description: Delete a list of the user's preferences.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: preferences

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: List of preference objects
- content:
  - `application/json` -> array of Preference

## Responses
- `200`: User preferences saved successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
