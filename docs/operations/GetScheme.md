# Get a scheme

Original OpenAPI operationId: `GetScheme`
- Method: `GET`
- Path: `/api/v4/schemes/{scheme_id}`
- Summary: Get a scheme
- Description: Get a scheme from the provided scheme id.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.0

- Tags: schemes

## Parameters
- `scheme_id` (path, required, string) - Scheme GUID

## Request body
No request body.

## Responses
- `200`: Scheme retrieval successful
  - `application/json` -> Scheme
- `401`: No description available.
- `404`: No description available.
- `501`: No description available.
