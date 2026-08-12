# List a user's preferences by category

Original OpenAPI operationId: `GetPreferencesByCategory`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/preferences/{category}`
- Summary: List a user's preferences by category
- Description: Lists the current user's stored preferences in the given category.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: preferences

## Parameters
- `user_id` (path, required, string) - User GUID
- `category` (path, required, string) - The category of a group of preferences

## Request body
No request body.

## Responses
- `200`: A list of all of the current user's preferences in the given category
  - `application/json` -> array of Preference
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
