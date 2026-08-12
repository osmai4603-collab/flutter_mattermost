# Detach a reattached plugin process

Original OpenAPI operationId: `DetachPlugin`
- Method: `POST`
- Path: `/api/v4/plugins/{plugin_id}/detach`
- Summary: Detach a reattached plugin process
- Description: Detaches a previously reattached plugin from the server.
This endpoint is only exposed over a local socket.

##### Permissions
Must have `manage_system` permission.

- Tags: plugins

## Parameters
- `plugin_id` (path, required, string) - The ID of the plugin to detach.

## Request body
No request body.

## Responses
- `200`: Plugin detached successfully
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
