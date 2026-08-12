# Update a playbook condition

Original OpenAPI operationId: `updatePlaybookCondition`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/conditions/{conditionID}`
- Summary: Update a playbook condition
- Description: Update an existing condition for a playbook.
- Tags: Conditions
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook.
- `conditionID` (path, required, string) - ID of the condition to update.

## Request body
- required: False
- description: Updated condition payload.
- content:
  - `application/json` -> Condition

## Responses
- `200`: Updated condition.
  - `application/json` -> Condition
- `400`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
