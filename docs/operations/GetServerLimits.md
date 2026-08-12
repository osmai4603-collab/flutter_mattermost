# Gets the server limits for the server

Original OpenAPI operationId: `GetServerLimits`
- Method: `GET`
- Path: `/api/v4/limits/server`
- Summary: Gets the server limits for the server
- Description: Gets the server limits for the server
##### Permissions
Requires `sysconsole_read_user_management_users`.

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: App limits for server
  - `application/json` -> array of ServerLimits
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
