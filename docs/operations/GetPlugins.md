# Get plugins

Original OpenAPI operationId: `GetPlugins`
- Method: `GET`
- Path: `/api/v4/plugins`
- Summary: Get plugins
- Description: Get a list of inactive and a list of active plugin manifests. Plugins must be enabled in the server's config settings.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 4.4

- Tags: plugins

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Plugins retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
