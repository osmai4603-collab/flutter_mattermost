# Update an OAuth app

Original OpenAPI operationId: `UpdateOAuthApp`
- Method: `PUT`
- Path: `/api/v4/oauth/apps/{app_id}`
- Summary: Update an OAuth app
- Description: Update an OAuth 2.0 client application based on OAuth struct.
##### Permissions
If app creator, must have `mange_oauth` permission otherwise `manage_system_wide_oauth` permission is required.

- Tags: OAuth

## Parameters
- `app_id` (path, required, string) - Application client id

## Request body
- required: True
- description: OAuth application to update
- content:
  - `application/json` -> object

## Responses
- `200`: App update successful
  - `application/json` -> OAuthApp
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
