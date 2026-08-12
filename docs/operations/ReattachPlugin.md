# Reattach a plugin process

Original OpenAPI operationId: `ReattachPlugin`
- Method: `POST`
- Path: `/api/v4/plugins/reattach`
- Summary: Reattach a plugin process
- Description: Reattaches the server to an already running plugin process.
This endpoint is only exposed over a local socket.

##### Permissions
Must have `manage_system` permission.

- Tags: plugins

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> PluginReattachRequest

## Responses
- `200`: Plugin reattached successfully
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
