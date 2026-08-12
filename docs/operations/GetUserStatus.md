# Get user status

Original OpenAPI operationId: `GetUserStatus`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/status`
- Summary: Get user status
- Description: Get user status by id from the server.
##### Permissions
Must be authenticated.

- Tags: status

## Parameters
- `user_id` (path, required, string) - User ID

## Request body
No request body.

## Responses
- `200`: User status retrieval successful
  - `application/json` -> Status
- `400`: No description available.
- `401`: No description available.
