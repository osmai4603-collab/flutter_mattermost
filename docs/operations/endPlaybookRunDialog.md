# End a playbook run from dialog

Original OpenAPI operationId: `endPlaybookRunDialog`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/runs/{id}/end`
- Summary: End a playbook run from dialog
- Description: This is an internal endpoint to end a playbook run via a confirmation dialog, submitted by a user in the webapp.
- Tags: Internal
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to end.

## Request body
No request body.

## Responses
- `200`: Playbook run ended
- `500`: No description available.
