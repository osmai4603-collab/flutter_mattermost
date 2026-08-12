# Create a team

Original OpenAPI operationId: `CreateTeam`
- Method: `POST`
- Path: `/api/v4/teams`
- Summary: Create a team
- Description: Create a new team on the system.
##### Permissions
Must be authenticated and have the `create_team` permission.

- Tags: teams

## Parameters
No parameters.

## Request body
- required: True
- description: Team that is to be created
- content:
  - `application/json` -> object

## Responses
- `201`: Team creation successful
  - `application/json` -> Team
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
