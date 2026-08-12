# Get authorized OAuth apps

Original OpenAPI operationId: `GetAuthorizedOAuthAppsForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/oauth/apps/authorized`
- Summary: Get authorized OAuth apps
- Description: Get a page of OAuth 2.0 client applications authorized to access a user's account.
##### Permissions
Must be authenticated as the user or have `edit_other_users` permission.

- Tags: OAuth

## Parameters
- `user_id` (path, required, string) - User GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of apps per page.

## Request body
No request body.

## Responses
- `200`: OAuthApp list retrieval successful
  - `application/json` -> array of OAuthApp
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
