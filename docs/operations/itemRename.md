# Update an item of a playbook run's checklist

Original OpenAPI operationId: `itemRename`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/checklists/{checklist}/item/{item}`
- Summary: Update an item of a playbook run's checklist
- Description: Update the title, slash command, and description of an item in one of the playbook run's checklists.
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose checklist will be modified.
- `checklist` (path, required, integer) - Zero-based index of the checklist to modify.
- `item` (path, required, integer) - Zero-based index of the item to modify.

## Request body
- required: False
- description: Update checklist item payload.
- content:
  - `application/json` -> object

## Responses
- `200`: Item updated.
- `400`: No description available.
- `500`: No description available.
