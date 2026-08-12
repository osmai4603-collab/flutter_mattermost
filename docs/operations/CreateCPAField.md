# Create a Custom Profile Attribute field

Original OpenAPI operationId: `CreateCPAField`
- Method: `POST`
- Path: `/api/v4/custom_profile_attributes/fields`
- Summary: Create a Custom Profile Attribute field
- Description: Create a new Custom Profile Attribute field on the system.

__Minimum server version__: 10.5

##### Permissions
Must have `manage_system` permission.

- Tags: custom profile attributes

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `application/json` -> object

## Responses
- `201`: Custom Profile Attribute field creation successful
  - `application/json` -> PropertyField
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `422`: Validation error. Returned when `name` does not match the required identifier pattern, is a CEL reserved word, or when `attrs.display_name` exceeds 255 characters.

  - `application/json` -> AppError
