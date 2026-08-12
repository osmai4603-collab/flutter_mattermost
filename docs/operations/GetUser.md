# Get a user

Original OpenAPI operationId: `GetUser`
- Method: `GET`
- Path: `/api/v4/users/{user_id}`
- Summary: Get a user
- Description: Get a user a object. Sensitive information will be sanitized out.
##### Permissions
Requires an active session but no other permissions.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID. This can also be "me" which will point to the current user.

## Request body
No request body.

## Responses
- `200`: User retrieval successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
