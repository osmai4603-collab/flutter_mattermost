# Update the state of an item

Original OpenAPI operationId: `itemSetState`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/checklists/{checklist}/item/{item}/state`
- Summary: Update the state of an item
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose checklist will be modified.
- `checklist` (path, required, integer) - Zero-based index of the checklist to modify.
- `item` (path, required, integer) - Zero-based index of the item to modify.

## Request body
- required: False
- description: Update checklist item's state payload.
- content:
  - `application/json` -> object

## Responses
- `200`: Item's state successfully updated.
- `400`: No description available.
- `500`: No description available.
