# Update the assignee of an item

Original OpenAPI operationId: `itemSetAssignee`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/checklists/{checklist}/item/{item}/assignee`
- Summary: Update the assignee of an item
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose item will get a new assignee.
- `checklist` (path, required, integer) - Zero-based index of the checklist whose item will get a new assignee.
- `item` (path, required, integer) - Zero-based index of the item that will get a new assignee.

## Request body
- required: False
- description: User ID of the new assignee.
- content:
  - `application/json` -> object

## Responses
- `200`: Item's assignee successfully updated.
- `400`: No description available.
- `500`: No description available.
