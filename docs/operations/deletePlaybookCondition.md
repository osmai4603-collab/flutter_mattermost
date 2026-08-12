# Delete a playbook condition

Original OpenAPI operationId: `deletePlaybookCondition`
- Method: `DELETE`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/conditions/{conditionID}`
- Summary: Delete a playbook condition
- Description: Delete a condition from a playbook. Run conditions cannot be deleted as they are read-only snapshots.
- Tags: Conditions
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook.
- `conditionID` (path, required, string) - ID of the condition to delete.

## Request body
No request body.

## Responses
- `204`: Condition successfully deleted.
- `400`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
