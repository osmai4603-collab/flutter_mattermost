# Get configuration

Original OpenAPI operationId: `GetConfig`
- Method: `GET`
- Path: `/api/v4/config`
- Summary: Get configuration
- Description: Retrieve the current server configuration
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
- `remove_masked` (query, optional, boolean) - Remove masked values from the exported configuration.

__Minimum server version__: 10.4.0

- `remove_defaults` (query, optional, string) - Remove default values from the exported configuration.

__Minimum server version__: 10.4.0


## Request body
No request body.

## Responses
- `200`: Configuration retrieval successful
  - `application/json` -> Config
- `400`: No description available.
- `403`: No description available.
