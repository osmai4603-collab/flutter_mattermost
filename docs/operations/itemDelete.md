# Delete an item of a playbook run's checklist

Original OpenAPI operationId: `itemDelete`
- Method: `DELETE`
- Path: `/plugins/playbooks/api/v0/runs/{id}/checklists/{checklist}/item/{item}`
- Summary: Delete an item of a playbook run's checklist
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose checklist will be modified.
- `checklist` (path, required, integer) - Zero-based index of the checklist to modify.
- `item` (path, required, integer) - Zero-based index of the item to modify.

## Request body
No request body.

## Responses
- `204`: Item successfully deleted.
- `400`: No description available.
- `500`: No description available.
