# Enable personal access token

Original OpenAPI operationId: `EnableUserAccessToken`
- Method: `POST`
- Path: `/api/v4/users/tokens/enable`
- Summary: Enable personal access token
- Description: Re-enable a personal access token that has been disabled.

__Minimum server version__: 4.4

##### Permissions
Must have `create_user_access_token` permission. For non-self requests, must also have the `edit_other_users` permission.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Personal access token enable successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
