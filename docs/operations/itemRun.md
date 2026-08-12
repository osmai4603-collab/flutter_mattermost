# Run an item's slash command

Original OpenAPI operationId: `itemRun`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/checklists/{checklist}/item/{item}/run`
- Summary: Run an item's slash command
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose item will be executed.
- `checklist` (path, required, integer) - Zero-based index of the checklist whose item will be executed.
- `item` (path, required, integer) - Zero-based index of the item whose slash command will be executed.

## Request body
No request body.

## Responses
- `200`: Item's slash command successfully executed.
  - `application/json` -> TriggerIdReturn
- `400`: No description available.
- `500`: No description available.
