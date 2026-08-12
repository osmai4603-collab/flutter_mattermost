# Enable plugin

Original OpenAPI operationId: `EnablePlugin`
- Method: `POST`
- Path: `/api/v4/plugins/{plugin_id}/enable`
- Summary: Enable plugin
- Description: Enable a previously uploaded plugin. Plugins must be enabled in the server's config settings.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 4.4

- Tags: plugins

## Parameters
- `plugin_id` (path, required, string) - Id of the plugin to be enabled

## Request body
No request body.

## Responses
- `200`: Plugin enabled successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
