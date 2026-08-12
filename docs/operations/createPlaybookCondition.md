# Create a playbook condition

Original OpenAPI operationId: `createPlaybookCondition`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/conditions`
- Summary: Create a playbook condition
- Description: Create a new condition for a playbook.
- Tags: Conditions
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to create a condition for.

## Request body
- required: False
- description: Condition payload.
- content:
  - `application/json` -> Condition

## Responses
- `201`: Created condition.
  - `application/json` -> Condition
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
