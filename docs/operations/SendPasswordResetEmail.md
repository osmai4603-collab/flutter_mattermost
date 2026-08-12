# Send password reset email

Original OpenAPI operationId: `SendPasswordResetEmail`
- Method: `POST`
- Path: `/api/v4/users/password/reset/send`
- Summary: Send password reset email
- Description: Send an email containing a link for resetting the user's password. The link will contain a one-use, timed recovery code tied to the user's account. Only works for non-SSO users.
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
- `200`: Email sent if account exists
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
