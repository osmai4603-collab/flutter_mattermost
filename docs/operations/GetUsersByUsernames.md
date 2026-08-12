# Get users by usernames

Original OpenAPI operationId: `GetUsersByUsernames`
- Method: `POST`
- Path: `/api/v4/users/usernames`
- Summary: Get users by usernames
- Description: Get a list of users based on a provided list of usernames.
##### Permissions
Requires an active session but no other permissions.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: List of usernames
- content:
  - `application/json` -> array of string

## Responses
- `200`: User list retrieval successful
  - `application/json` -> array of User
- `400`: No description available.
- `401`: No description available.
