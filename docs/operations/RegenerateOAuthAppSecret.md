# Regenerate OAuth app secret

Original OpenAPI operationId: `RegenerateOAuthAppSecret`
- Method: `POST`
- Path: `/api/v4/oauth/apps/{app_id}/regen_secret`
- Summary: Regenerate OAuth app secret
- Description: Regenerate the client secret for an OAuth 2.0 client application registered with Mattermost.
##### Permissions
If app creator, must have `mange_oauth` permission otherwise `manage_system_wide_oauth` permission is required.

- Tags: OAuth

## Parameters
- `app_id` (path, required, string) - Application client id

## Request body
No request body.

## Responses
- `200`: Secret regeneration successful
  - `application/json` -> OAuthApp
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
