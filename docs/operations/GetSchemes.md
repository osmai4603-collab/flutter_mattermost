# Get the schemes.

Original OpenAPI operationId: `GetSchemes`
- Method: `GET`
- Path: `/api/v4/schemes`
- Summary: Get the schemes.
- Description: Get a page of schemes. Use the query parameters to modify the behaviour of this endpoint.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.0

- Tags: schemes

## Parameters
- `scope` (query, optional, string) - Limit the results returned to the provided scope, either `team` or `channel`.
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of schemes per page.

## Request body
No request body.

## Responses
- `200`: Scheme list retrieval successful
  - `application/json` -> array of Scheme
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
