# Finish a playbook

Original OpenAPI operationId: `finish`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/finish`
- Summary: Finish a playbook
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to finish.

## Request body
No request body.

## Responses
- `200`: Playbook run finished.
- `500`: No description available.
