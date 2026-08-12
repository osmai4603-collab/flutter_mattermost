# List all playbooks

Original OpenAPI operationId: `getPlaybooks`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/playbooks`
- Summary: List all playbooks
- Description: Retrieve a paged list of playbooks, filtered by team, and sorted by title, number of stages or number of steps.
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `team_id` (query, required, string) - ID of the team to filter by.
- `page` (query, optional, integer) - Zero-based index of the page to request.
- `per_page` (query, optional, integer) - Number of playbooks to return per page.
- `sort` (query, optional, string) - Field to sort the returned playbooks by title, number of stages or total number of steps.
- `direction` (query, optional, string) - Direction (ascending or descending) followed by the sorting of the playbooks.
- `with_archived` (query, optional, boolean) - Includes archived playbooks in the result.

## Request body
No request body.

## Responses
- `200`: A paged list of playbooks.
  - `application/json` -> PlaybookList
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
