# List playbook conditions

Original OpenAPI operationId: `getPlaybookConditions`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/conditions`
- Summary: List playbook conditions
- Description: Retrieve a paged list of conditions for a playbook.
- Tags: Conditions
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to retrieve conditions from.
- `page` (query, optional, integer) - Zero-based index of the page to request.
- `per_page` (query, optional, integer) - Number of conditions to return per page.

## Request body
No request body.

## Responses
- `200`: A paged list of playbook conditions.
  - `application/json` -> ConditionList
- `403`: No description available.
- `500`: No description available.
