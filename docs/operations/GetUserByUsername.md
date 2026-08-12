# Get a user by username

Original OpenAPI operationId: `GetUserByUsername`
- Method: `GET`
- Path: `/api/v4/users/username/{username}`
- Summary: Get a user by username
- Description: Get a user object by providing a username. Sensitive information will be sanitized out.
##### Permissions
Requires an active session but no other permissions.

- Tags: users

## Parameters
- `username` (path, required, string) - Username

## Request body
No request body.

## Responses
- `200`: User retrieval successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
