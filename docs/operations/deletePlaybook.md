# Delete a playbook

Original OpenAPI operationId: `deletePlaybook`
- Method: `DELETE`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}`
- Summary: Delete a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to delete.

## Request body
No request body.

## Responses
- `204`: Playbook successfully deleted.
- `403`: No description available.
- `500`: No description available.
