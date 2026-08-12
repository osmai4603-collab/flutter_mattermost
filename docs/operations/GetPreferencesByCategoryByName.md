# Get a specific user preference

Original OpenAPI operationId: `GetPreferencesByCategoryByName`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/preferences/{category}/name/{preference_name}`
- Summary: Get a specific user preference
- Description: Gets a single preference for the current user with the given category and name.
##### Permissions
Must be logged in as the user being updated or have the `edit_other_users` permission.

- Tags: preferences

## Parameters
- `user_id` (path, required, string) - User GUID
- `category` (path, required, string) - The category of a group of preferences
- `preference_name` (path, required, string) - The name of the preference

## Request body
No request body.

## Responses
- `200`: A single preference for the current user in the current categorylist of all of the current user's preferences in the given category.

  - `application/json` -> Preference
- `400`: No description available.
- `401`: No description available.
