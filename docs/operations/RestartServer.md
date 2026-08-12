# Restart the system after an upgrade from Team Edition to Enterprise Edition

Original OpenAPI operationId: `RestartServer`
- Method: `POST`
- Path: `/api/v4/restart`
- Summary: Restart the system after an upgrade from Team Edition to Enterprise Edition
- Description: It restarts the current running mattermost instance to execute the new Enterprise binary.
__Minimum server version__: 5.27
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Restart started
  - `application/json` -> StatusOK
- `403`: No description available.
