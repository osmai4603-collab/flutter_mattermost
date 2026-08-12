# Logout from the Mattermost server

Original OpenAPI operationId: `Logout`
- Method: `POST`
- Path: `/api/v4/users/logout`
- Summary: Logout from the Mattermost server
- Description: ##### Permissions
An active session is required

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `201`: User logout successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `403`: No description available.
