# Get all owners

Original OpenAPI operationId: `getOwners`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/owners`
- Summary: Get all owners
- Description: Get the owners of all playbook runs, filtered by team.
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `team_id` (query, required, string) - ID of the team to filter by.

## Request body
No request body.

## Responses
- `200`: A list of owners.
  - `application/json` -> array of OwnerInfo
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
