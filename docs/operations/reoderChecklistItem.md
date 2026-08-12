# Reorder an item in a playbook run's checklist

Original OpenAPI operationId: `reoderChecklistItem`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/checklists/{checklist}/reorder`
- Summary: Reorder an item in a playbook run's checklist
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose checklist will be modified.
- `checklist` (path, required, integer) - Zero-based index of the checklist to modify.

## Request body
- required: False
- description: Reorder checklist item payload.
- content:
  - `application/json` -> object

## Responses
- `200`: Item successfully reordered.
- `400`: No description available.
- `500`: No description available.
