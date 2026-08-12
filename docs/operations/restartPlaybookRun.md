# Restart a playbook run

Original OpenAPI operationId: `restartPlaybookRun`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/restart`
- Summary: Restart a playbook run
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to restart.

## Request body
No request body.

## Responses
- `200`: Playbook run restarted.
- `500`: No description available.
