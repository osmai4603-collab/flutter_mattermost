# Search users

Original OpenAPI operationId: `SearchUsers`
- Method: `POST`
- Path: `/api/v4/users/search`
- Summary: Search users
- Description: Get a list of users based on search criteria provided in the request body. Searches are typically done against username, full name, nickname and email unless otherwise configured by the server.
##### Permissions
Requires an active session and `read_channel` and/or `view_team` permissions for any channels or teams specified in the request body.

- Tags: users

## Parameters
No parameters.

## Request body
- required: True
- description: Search criteria
- content:
  - `application/json` -> object

## Responses
- `200`: User list retrieval successful
  - `application/json` -> array of User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
