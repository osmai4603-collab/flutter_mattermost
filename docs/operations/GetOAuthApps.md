# Get OAuth apps

Original OpenAPI operationId: `GetOAuthApps`
- Method: `GET`
- Path: `/api/v4/oauth/apps`
- Summary: Get OAuth apps
- Description: Get a page of OAuth 2.0 client applications registered with Mattermost.
##### Permissions
With `manage_oauth` permission, the apps registered by the logged in user are returned. With `manage_system_wide_oauth` permission, all apps regardless of creator are returned.

- Tags: OAuth

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of apps per page.

## Request body
No request body.

## Responses
- `200`: OAuthApp list retrieval successful
  - `application/json` -> array of OAuthApp
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
