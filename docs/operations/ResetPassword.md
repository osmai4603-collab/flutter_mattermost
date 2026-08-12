# Reset password

Original OpenAPI operationId: `ResetPassword`
- Method: `POST`
- Path: `/api/v4/users/password/reset`
- Summary: Reset password
- Description: Update the password for a user using a one-use, timed recovery code tied to the user's account. Only works for non-SSO users.
##### Permissions
No permissions required.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: User password update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
