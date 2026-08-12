# Get current usage of teams

Original OpenAPI operationId: `GetTeamsUsage`
- Method: `GET`
- Path: `/api/v4/usage/teams`
- Summary: Get current usage of teams
- Description: Retrieve rounded total number of teams for this instance.
##### Permissions Must be authenticated.

- Tags: usage

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Total number of teams returned successfully
  - `application/json` -> object
- `401`: No description available.
- `500`: No description available.
