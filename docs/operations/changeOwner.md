# Update playbook run owner

Original OpenAPI operationId: `changeOwner`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/runs/{id}/owner`
- Summary: Update playbook run owner
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run whose owner will be changed.

## Request body
- required: False
- description: Payload to change the playbook run's owner.
- content:
  - `application/json` -> object

## Responses
- `200`: Owner successfully changed.
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
