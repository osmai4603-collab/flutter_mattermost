# Get server busy expiry time.

Original OpenAPI operationId: `GetServerBusyExpires`
- Method: `GET`
- Path: `/api/v4/server_busy`
- Summary: Get server busy expiry time.
- Description: Gets the timestamp corresponding to when the server busy flag will be automatically cleared.

__Minimum server version__: 5.20

##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Server busy expires timestamp retrieved successfully
  - `application/json` -> Server_Busy
- `403`: No description available.
