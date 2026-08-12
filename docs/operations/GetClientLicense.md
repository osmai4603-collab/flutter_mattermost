# Get client license

Original OpenAPI operationId: `GetClientLicense`
- Method: `GET`
- Path: `/api/v4/license/client`
- Summary: Get client license
- Description: Get a subset of the server license needed by the client.
##### Permissions
No permission required but having the `manage_system` permission returns more information.

- Tags: system

## Parameters
- `format` (query, required, string) - Must be `old`, other formats not implemented yet

## Request body
No request body.

## Responses
- `200`: License retrieval successful
- `400`: No description available.
- `501`: No description available.
