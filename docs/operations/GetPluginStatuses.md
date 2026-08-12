# Get plugins status

Original OpenAPI operationId: `GetPluginStatuses`
- Method: `GET`
- Path: `/api/v4/plugins/statuses`
- Summary: Get plugins status
- Description: Returns the status for plugins installed anywhere in the cluster

##### Permissions
No permissions required.

__Minimum server version__: 4.4

- Tags: plugins

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Plugin status retreived successfully
  - `application/json` -> array of PluginStatus
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
