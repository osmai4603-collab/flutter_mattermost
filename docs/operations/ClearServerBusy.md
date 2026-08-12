# Clears the server busy (high load) flag

Original OpenAPI operationId: `ClearServerBusy`
- Method: `DELETE`
- Path: `/api/v4/server_busy`
- Summary: Clears the server busy (high load) flag
- Description: Marks the server as not having high load which re-enables non-critical services such as search, statuses and typing notifications.

__Minimum server version__: 5.20

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Server busy flag cleared successfully
  - `application/json` -> StatusOK
- `403`: No description available.
