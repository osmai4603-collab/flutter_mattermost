# Get a page of channels which use this scheme.

Original OpenAPI operationId: `GetChannelsForScheme`
- Method: `GET`
- Path: `/api/v4/schemes/{scheme_id}/channels`
- Summary: Get a page of channels which use this scheme.
- Description: Get a page of channels which use this scheme. The provided Scheme ID should be for a Channel-scoped Scheme.
Use the query parameters to modify the behaviour of this endpoint.

##### Permissions
`manage_system` permission is required.

__Minimum server version__: 5.0

- Tags: schemes

## Parameters
- `scheme_id` (path, required, string) - Scheme GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of channels per page.

## Request body
No request body.

## Responses
- `200`: Channel list retrieval successful
  - `application/json` -> array of Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
