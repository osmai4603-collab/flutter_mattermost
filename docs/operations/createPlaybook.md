# Create a playbook

Original OpenAPI operationId: `createPlaybook`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/playbooks`
- Summary: Create a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
No parameters.

## Request body
- required: False
- description: Playbook
- content:
  - `application/json` -> object

## Responses
- `201`: ID of the created playbook.
  - `application/json` -> object
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
