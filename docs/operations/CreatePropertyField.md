# Create a property field

Original OpenAPI operationId: `CreatePropertyField`
- Method: `POST`
- Path: `/api/v4/properties/groups/{group_name}/{object_type}/fields`
- Summary: Create a property field
- Description: Create a new property field for a specific group and object type.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group
- `object_type` (path, required, string) - The type of object this property field applies to

## Request body
- required: True
- description: Property field object to create
- content:
  - `application/json` -> object

## Responses
- `201`: Property field creation successful
  - `application/json` -> PropertyField
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `409`: A property field with the same name already exists at the same or a conflicting hierarchy level.

