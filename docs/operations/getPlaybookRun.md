# Get a playbook run

Original OpenAPI operationId: `getPlaybookRun`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/runs/{id}`
- Summary: Get a playbook run
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to retrieve.

## Request body
No request body.

## Responses
- `200`: Playbook run
  - `application/json` -> PlaybookRun
- `403`: No description available.
- `500`: No description available.
