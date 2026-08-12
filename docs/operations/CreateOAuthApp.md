# Register OAuth app

Original OpenAPI operationId: `CreateOAuthApp`
- Method: `POST`
- Path: `/api/v4/oauth/apps`
- Summary: Register OAuth app
- Description: Register an OAuth 2.0 client application with Mattermost as the service provider.
##### Permissions
Must have `manage_oauth` permission.

- Tags: OAuth

## Parameters
No parameters.

## Request body
- required: True
- description: OAuth application to register
- content:
  - `application/json` -> object

## Responses
- `201`: App registration successful
  - `application/json` -> OAuthApp
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
