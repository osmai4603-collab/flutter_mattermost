# Disable plugin

Original OpenAPI operationId: `DisablePlugin`
- Method: `POST`
- Path: `/api/v4/plugins/{plugin_id}/disable`
- Summary: Disable plugin
- Description: Disable a previously enabled plugin. Plugins must be enabled in the server's config settings.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 4.4

- Tags: plugins

## Parameters
- `plugin_id` (path, required, string) - Id of the plugin to be disabled

## Request body
No request body.

## Responses
- `200`: Plugin disabled successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
