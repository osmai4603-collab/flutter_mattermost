# Get user access tokens

Original OpenAPI operationId: `GetUserAccessTokens`
- Method: `GET`
- Path: `/api/v4/users/tokens`
- Summary: Get user access tokens
- Description: Get a page of user access tokens for users on the system. Does not include the actual authentication tokens. Use query parameters for paging.

__Minimum server version__: 4.7

##### Permissions
Must have `manage_system` permission.

- Tags: users

## Parameters
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
