# Send verification email

Original OpenAPI operationId: `SendVerificationEmail`
- Method: `POST`
- Path: `/api/v4/users/email/verify/send`
- Summary: Send verification email
- Description: Send an email with a verification link to a user that has an email matching the one in the request body. This endpoint will return success even if the email does not match any users on the system.
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
- `200`: Email send successful if email exists
  - `application/json` -> StatusOK
- `400`: No description available.
