# Get user statuses by id

Original OpenAPI operationId: `GetUsersStatusesByIds`
- Method: `POST`
- Path: `/api/v4/users/status/ids`
- Summary: Get user statuses by id
- Description: Get a list of user statuses by id from the server.
##### Permissions
Must be authenticated.

- Tags: status

## Parameters
No parameters.

## Request body
- required: True
- description: List of user ids to fetch
- content:
  - `application/json` -> array of string

## Responses
- `200`: User statuses retrieval successful
  - `application/json` -> array of Status
- `400`: No description available.
- `401`: No description available.
