# Get a user by email

Original OpenAPI operationId: `GetUserByEmail`
- Method: `GET`
- Path: `/api/v4/users/email/{email}`
- Summary: Get a user by email
- Description: Get a user object by providing a user email. Sensitive information will be sanitized out.
##### Permissions
Requires an active session and for the current session to be able to view another user's email based on the server's privacy settings.

- Tags: users

## Parameters
- `email` (path, required, string) - User Email

## Request body
No request body.

## Responses
- `200`: User retrieval successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
