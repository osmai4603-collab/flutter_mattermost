# Get info on an OAuth app

Original OpenAPI operationId: `GetOAuthAppInfo`
- Method: `GET`
- Path: `/api/v4/oauth/apps/{app_id}/info`
- Summary: Get info on an OAuth app
- Description: Get public information about an OAuth 2.0 client application registered with Mattermost. The application's client secret will be blanked out.
##### Permissions
Must be authenticated.

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
- `404`: No description available.
- `501`: No description available.
