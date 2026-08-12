# Create a user access token

Original OpenAPI operationId: `CreateUserAccessToken`
- Method: `POST`
- Path: `/api/v4/users/{user_id}/tokens`
- Summary: Create a user access token
- Description: Generate a user access token that can be used to authenticate with the Mattermost REST API.

__Minimum server version__: 4.1

##### Permissions
Must have `create_user_access_token` permission. For non-self requests, must also have the `edit_other_users` permission.

- Tags: users

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `201`: User access token creation successful
  - `application/json` -> UserAccessToken
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
