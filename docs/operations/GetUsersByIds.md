# Get users by ids

Original OpenAPI operationId: `GetUsersByIds`
- Method: `POST`
- Path: `/api/v4/users/ids`
- Summary: Get users by ids
- Description: Get a list of users based on a provided list of user ids.
##### Permissions
Requires an active session but no other permissions.

- Tags: users

## Parameters
- `since` (query, optional, integer) - Only return users that have been modified since the given Unix timestamp (in milliseconds).

__Minimum server version__: 5.14


## Request body
- required: True
- description: List of user ids
- content:
  - `application/json` -> array of string

## Responses
- `200`: User list retrieval successful
  - `application/json` -> array of User
- `400`: No description available.
- `401`: No description available.
