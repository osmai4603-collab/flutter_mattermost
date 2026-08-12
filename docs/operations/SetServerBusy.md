# Set the server busy (high load) flag

Original OpenAPI operationId: `SetServerBusy`
- Method: `POST`
- Path: `/api/v4/server_busy`
- Summary: Set the server busy (high load) flag
- Description: Marks the server as currently having high load which disables non-critical services such as search, statuses and typing notifications.

__Minimum server version__: 5.20

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
- `seconds` (query, optional, string) - Number of seconds until server is automatically marked as not busy.

## Request body
No request body.

## Responses
- `200`: Server busy flag set successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `403`: No description available.
