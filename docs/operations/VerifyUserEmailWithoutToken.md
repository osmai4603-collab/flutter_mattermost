# Verify user email by ID

Original OpenAPI operationId: `VerifyUserEmailWithoutToken`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/email/verify/member`
- Summary: Verify user email by ID
- Description: Verify the email used by a user without a token.

__Minimum server version__: 5.24

##### Permissions

Must have `manage_system` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: User email verification successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
