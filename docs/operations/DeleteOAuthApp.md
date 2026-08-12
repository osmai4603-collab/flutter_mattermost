# Delete an OAuth app

Original OpenAPI operationId: `DeleteOAuthApp`
- Method: `DELETE`
- Path: `/api/v4/oauth/apps/{app_id}`
- Summary: Delete an OAuth app
- Description: Delete and unregister an OAuth 2.0 client application 
##### Permissions
If app creator, must have `mange_oauth` permission otherwise `manage_system_wide_oauth` permission is required.

- Tags: OAuth

## Parameters
- `app_id` (path, required, string) - Application client id

## Request body
No request body.

## Responses
- `200`: App deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
