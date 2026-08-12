# Get total count of users in the system

Original OpenAPI operationId: `GetTotalUsersStats`
- Method: `GET`
- Path: `/api/v4/users/stats`
- Summary: Get total count of users in the system
- Description: Get a total count of users in the system.
##### Permissions
Must be authenticated.

- Tags: users

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: User stats retrieval successful
  - `application/json` -> UsersStats
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
