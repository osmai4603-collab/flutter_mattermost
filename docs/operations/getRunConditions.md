# List run conditions

Original OpenAPI operationId: `getRunConditions`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/{id}/conditions`
- Summary: List run conditions
- Description: Retrieve a paged list of conditions for a run. Run conditions are read-only snapshots copied from the playbook.
- Tags: Conditions
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the run to retrieve conditions from.
- `page` (query, optional, integer) - Zero-based index of the page to request.
- `per_page` (query, optional, integer) - Number of conditions to return per page.

## Request body
No request body.

## Responses
- `200`: A paged list of run conditions.
  - `application/json` -> ConditionList
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
