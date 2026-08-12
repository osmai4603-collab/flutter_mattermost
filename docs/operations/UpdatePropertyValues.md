# Update property values for a target

Original OpenAPI operationId: `UpdatePropertyValues`
- Method: `PATCH`
- Path: `/api/v4/properties/groups/{group_name}/{object_type}/values/{target_id}`
- Summary: Update property values for a target
- Description: Update one or more property values for a specific target within a group. Uses upsert semantics: creates the value if it doesn't exist, updates it if it does. All field IDs must belong to the specified group. The `template` object type cannot have values and will return 400. The `system` object type must use the dedicated `/api/v4/properties/groups/{group_name}/system/values` endpoint and will return 400 on this route.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group
- `object_type` (path, required, string) - The type of object
- `target_id` (path, required, string) - The ID of the target object

## Request body
- required: True
- description: Array of property values to update
- content:
  - `application/json` -> array of object

## Responses
- `200`: Property values update successful
  - `application/json` -> array of PropertyValue
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
