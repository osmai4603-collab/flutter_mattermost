# Set a property value for a playbook run

Original OpenAPI operationId: `setRunPropertyValue`
- Method: `PUT`
- Path: `/plugins/playbooks/api/v0/runs/{id}/property_fields/{field_id}/value`
- Summary: Set a property value for a playbook run
- Tags: PlaybookRuns
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook run to set property value for.
- `field_id` (path, required, string) - ID of the property field to set value for.

## Request body
- required: False
- description: Property value payload
- content:
  - `application/json` -> PropertyValueRequest

## Responses
- `200`: Property value set successfully.
  - `application/json` -> PropertyValue
- `400`: No description available.
- `403`: No description available.
- `500`: No description available.
