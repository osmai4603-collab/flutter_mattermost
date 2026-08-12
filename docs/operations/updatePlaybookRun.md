# Update a playbook run

Original OpenAPI operationId: `updatePlaybookRun`
- Method: `PATCH`
- Path: `/plugins/playbooks/api/v0/runs/{id}`
- Summary: Update a playbook run
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to retrieve.

## Request body
- required: False
- description: Playbook run update payload.
- content:
  - `application/json` -> object

## Responses
- `200`: Playbook run successfully updated.
- `400`: No description available.
- `500`: No description available.
