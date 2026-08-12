# Update a playbook run's status

Original OpenAPI operationId: `updatePlaybookRunStatus`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/runs/{id}/status`
- Summary: Update a playbook run's status
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to update.

## Request body
- required: False
- description: Payload to change the playbook run's status update message.
- content:
  - `application/json` -> object

## Responses
- `200`: Playbook run updated.
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
