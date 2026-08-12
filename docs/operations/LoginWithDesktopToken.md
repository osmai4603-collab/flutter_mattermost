# Login using desktop token

Original OpenAPI operationId: `LoginWithDesktopToken`
- Method: `POST`
- Path: `/api/v4/users/login/desktop_token`
- Summary: Login using desktop token
- Description: Login to Mattermost with a short-lived desktop token.
##### Permissions No permission required.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Desktop token login successful
  - `application/json` -> User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
