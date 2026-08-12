# Search teams

Original OpenAPI operationId: `SearchTeams`
- Method: `POST`
- Path: `/api/v4/teams/search`
- Summary: Search teams
- Description: Search teams based on search term and options provided in the request body.

##### Permissions
Logged in user only shows open teams
Logged in user with "manage_system" permission shows all teams

- Tags: teams

## Parameters
No parameters.

## Request body
- required: True
- description: Search criteria
- content:
  - `application/json` -> object

## Responses
- `200`: Paginated teams response. (Note that the non-paginated response—returned if the request body does not contain both `page` and `per_page` fields—is a simple array of teams.)
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
