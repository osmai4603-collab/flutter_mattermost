# Reorder property fields for a playbook

Original OpenAPI operationId: `reorderPlaybookPropertyFields`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/property_fields/reorder`
- Summary: Reorder property fields for a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Property fields reordered successfully.
  - `application/json` -> array of PropertyField
- `400`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
