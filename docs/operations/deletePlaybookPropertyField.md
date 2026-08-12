# Delete a property field for a playbook

Original OpenAPI operationId: `deletePlaybookPropertyField`
- Method: `DELETE`
- Path: `/plugins/playbooks/api/v0/playbooks/{id}/property_fields/{field_id}`
- Summary: Delete a property field for a playbook
- Tags: Playbooks
- Security: [{'BearerAuth': []}]

## Parameters
- `id` (path, required, string) - ID of the playbook containing the property field.
- `field_id` (path, required, string) - ID of the property field to delete.

## Request body
No request body.

## Responses
- `204`: Property field deleted successfully.
- `403`: No description available.
- `500`: No description available.
