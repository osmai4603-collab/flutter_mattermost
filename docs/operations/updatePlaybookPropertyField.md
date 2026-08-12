# Update a property field for a playbook

Original OpenAPI operationId: `updatePlaybookPropertyField`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/property_fields/{field_id}`
- Summary: Update a property field for a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook containing the property field.
- `field_id` (path, required, string) - ID of the property field to update.

## Request body
- required: False
- description: Property field update payload
- content:
  - `application/json` -> PropertyFieldRequest

## Responses
- `200`: Property field updated successfully.
  - `application/json` -> PropertyField
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
