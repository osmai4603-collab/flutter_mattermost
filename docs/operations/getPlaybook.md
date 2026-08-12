# Get a playbook

Original OpenAPI operationId: `getPlaybook`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}`
- Summary: Get a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to retrieve.

## Request body
No request body.

## Responses
- `200`: Playbook.
  - `application/json` -> Playbook
- `403`: No description available.
- `500`: No description available.
