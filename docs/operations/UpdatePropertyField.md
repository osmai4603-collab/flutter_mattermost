# Update a property field

Original OpenAPI operationId: `UpdatePropertyField`
- Method: `PATCH`
- Path: `/api/v4/properties/groups/{group_name}/{object_type}/fields/{field_id}`
- Summary: Update a property field
- Description: Partially update a property field by providing only the fields you want to update. Omitted fields will not be updated. The `attrs` object uses merge semantics: only the keys present in the patch are updated; omitted keys are preserved. Setting a key to `null` removes it from attrs.

**Immutable fields:** `target_type`, `target_id`, and `object_type` cannot be changed after creation and are ignored if included in the patch.

**Linked fields:** Fields with a `linked_field_id` cannot have their `type` or `attrs.options` modified (returns 400). The `linked_field_id` can only be cleared (set to empty string `""`) to unlink the field; it cannot be changed to a different value. For non-linked fields, `linked_field_id` cannot be set to a new value (linking is only allowed at creation time).

**Propagation:** When a template field's options are updated, the changes propagate atomically to all fields that link to it.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group
- `object_type` (path, required, string) - The type of object this property field applies to
- `field_id` (path, required, string) - Property field ID

## Request body
- required: True
- description: Property field patch object
- content:
  - `application/json` -> PropertyFieldPatch

## Responses
- `200`: Property field update successful
  - `application/json` -> PropertyField
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `409`: Name conflict with an existing field, or cannot change type of a field that has active linked dependents.

