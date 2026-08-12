# Delete a property field

Original OpenAPI operationId: `DeletePropertyField`
- Method: `DELETE`
- Path: `/api/v4/properties/groups/{group_name}/{object_type}/fields/{field_id}`
- Summary: Delete a property field
- Description: Deletes a property field and all its associated values. Returns 409 Conflict if the field has active linked dependents; unlink or delete dependent fields first.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group
- `object_type` (path, required, string) - The type of object this property field applies to
- `field_id` (path, required, string) - Property field ID

## Request body
No request body.

## Responses
- `200`: Property field deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `409`: The field has active linked dependents. Unlink or delete dependent fields before deleting the source.

