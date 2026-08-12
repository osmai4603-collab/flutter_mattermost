# Generate MFA secret

Original OpenAPI operationId: `GenerateMfaSecret`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/mfa/generate`
- Summary: Generate MFA secret
- Description: Generates an multi-factor authentication secret for a user and returns it as a string and as base64 encoded QR code image.
##### Permissions
Must be logged in as the user or have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: MFA secret generation successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
