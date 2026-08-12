# Get current user's recaps

Original OpenAPI operationId: `GetRecapsForUser`
- Method: `GET`
- Path: `/api/v4/recaps`
- Summary: Get current user's recaps
- Description: Get a paginated list of recaps created by the authenticated user.
##### Permissions
Must be authenticated.
__Minimum server version__: 11.2

- Tags: recaps, ai

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of recaps per page.

## Request body
No request body.

## Responses
- `200`: Recaps retrieval successful
  - `application/json` -> array of Recap
- `400`: No description available.
- `401`: No description available.
