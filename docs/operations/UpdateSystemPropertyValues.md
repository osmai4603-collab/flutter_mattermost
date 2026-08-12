# Update property values for the system

Original OpenAPI operationId: `UpdateSystemPropertyValues`
- Method: `PATCH`
- Path: `/api/v4/properties/groups/{group_name}/system/values`
- Summary: Update property values for the system
- Description: Update one or more property values attached to the Mattermost instance itself. Uses upsert semantics: creates the value if it doesn't exist, updates it if it does. Requires system administrator access. All field IDs must reference `system` object-type fields in the specified group; template field IDs are rejected with 400.

- Tags: properties

## Parameters
- `group_name` (path, required, string) - The name of the property group

## Request body
- required: True
- description: Array of property values to update
- content:
  - `application/json` -> array of object

## Responses
- `200`: System property values update successful
  - `application/json` -> array of PropertyValue
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
