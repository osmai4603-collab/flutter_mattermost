# Add an item to a playbook run's checklist

Original OpenAPI operationId: `addChecklistItem`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/runs/{id}/checklists/{checklist}/add`
- Summary: Add an item to a playbook run's checklist
- Description: The most common pattern to add a new item is to only send its title as the request payload. By default, it is an open item, with no assignee and no slash command.
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose checklist will be modified.
- `checklist` (path, required, integer) - Zero-based index of the checklist to modify.

## Request body
- required: False
- description: Checklist item payload.
- content:
  - `application/json` -> object

## Responses
- `200`: Item successfully added.
- `default`: Error response
  - `application/json` -> Error
