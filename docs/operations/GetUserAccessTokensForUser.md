# Get user access tokens

Original OpenAPI operationId: `GetUserAccessTokensForUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/tokens`
- Summary: Get user access tokens
- Description: Get a list of user access tokens for a user. Does not include the actual authentication tokens. Use query parameters for paging.

__Minimum server version__: 4.1

##### Permissions
Must have `read_user_access_token` permission. For non-self requests, must also have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of tokens per page.

## Request body
No request body.

## Responses
- `200`: User access tokens retrieval successful
  - `application/json` -> array of UserAccessTokenSanitized
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
