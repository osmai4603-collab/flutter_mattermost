# Create a property field for a playbook

Original OpenAPI operationId: `createPlaybookPropertyField`
- Method: `POST`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/property_fields`
- Summary: Create a property field for a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook to create a property field for.

## Request body
- required: False
- description: Property field creation payload
- content:
  - `application/json` -> PropertyFieldRequest

## Responses
- `201`: Property field created successfully.
  - `application/json` -> PropertyField
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
