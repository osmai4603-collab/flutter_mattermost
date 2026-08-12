# Get an OAuth app

Original OpenAPI operationId: `GetOAuthApp`
- Method: `GET`
- Path: `/api/v4/oauth/apps/{app_id}`
- Summary: Get an OAuth app
- Description: Get an OAuth 2.0 client application registered with Mattermost.
##### Permissions
If app creator, must have `mange_oauth` permission otherwise `manage_system_wide_oauth` permission is required.

- Tags: OAuth

## Parameters
- `app_id` (path, required, string) - Application client id

## Request body
No request body.

## Responses
- `200`: App retrieval successful
  - `application/json` -> OAuthApp
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
