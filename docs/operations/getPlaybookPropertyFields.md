# Get property fields for a playbook

Original OpenAPI operationId: `getPlaybookPropertyFields`
- Method: `GET`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/property_fields`
- Summary: Get property fields for a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to retrieve property fields from.
- `updated_since` (query, optional, integer) - Filter results to only include property fields updated after this timestamp (Unix time in milliseconds).

## Request body
No request body.

## Responses
- `200`: List of property fields for the playbook.
  - `application/json` -> array of PropertyField
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
