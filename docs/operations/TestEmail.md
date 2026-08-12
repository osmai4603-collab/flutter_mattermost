# Send a test email

Original OpenAPI operationId: `TestEmail`
- Method: `POST`
- Path: `/api/v4/email/test`
- Summary: Send a test email
- Description: Send a test email to make sure you have your email settings configured correctly. Optionally provide a configuration in the request body to test. If no valid configuration is present in the request body the current server configuration will be tested.
##### Permissions
Must have `manage_system` permission.

- Tags: system

## Parameters
No parameters.

## Request body
- required: True
- description: Mattermost configuration
- content:
  - `application/json` -> Config

## Responses
- `200`: Email successful sent
  - `application/json` -> StatusOK
- `403`: No description available.
- `500`: No description available.
