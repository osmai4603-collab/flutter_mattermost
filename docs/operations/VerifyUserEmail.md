# Verify user email

Original OpenAPI operationId: `VerifyUserEmail`
- Method: `POST`
- Path: `/api/v4/users/email/verify`
- Summary: Verify user email
- Description: Verify the email used by a user to sign-up their account with.
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
- `200`: User email verification successful
  - `application/json` -> StatusOK
- `400`: No description available.
