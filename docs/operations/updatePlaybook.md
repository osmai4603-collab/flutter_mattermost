# Update a playbook

Original OpenAPI operationId: `updatePlaybook`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}`
- Summary: Update a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to update.

## Request body
- required: False
- description: Playbook payload
- content:
  - `application/json` -> Playbook

## Responses
- `200`: Playbook succesfully updated.
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
