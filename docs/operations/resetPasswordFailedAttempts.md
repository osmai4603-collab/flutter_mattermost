# Reset the failed password attempts for a user

Original OpenAPI operationId: `resetPasswordFailedAttempts`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/reset_failed_attempts`
- Summary: Reset the failed password attempts for a user
- Description: Reset the FailedAttempts field for a user to 0. This will only work for ldap and email/password users.

##### Permissions

Requires `sysconsole_write_user_management_users` permission.

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: User's thread update successful
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
