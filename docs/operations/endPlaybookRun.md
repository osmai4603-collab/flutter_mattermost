# End a playbook run

Original OpenAPI operationId: `endPlaybookRun`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/end`
- Summary: End a playbook run
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to end.

## Request body
No request body.

## Responses
- `200`: Playbook run ended
- `500`: No description available.
