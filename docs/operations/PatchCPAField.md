# Patch a Custom Profile Attribute field

Original OpenAPI operationId: `PatchCPAField`
- Method: `PATCH`
- Path: `/api/v4/custom_profile_attributes/fields/{field_id}`
- Summary: Patch a Custom Profile Attribute field
- Description: Partially update a Custom Profile Attribute field by providing
only the fields you want to update. Omitted fields will not be
updated. The fields that can be updated are defined in the
request body, all other provided fields will be ignored.

**Note:** Fields with `attrs.protected = true` cannot be
modified and will return an error.

__Minimum server version__: 10.5

##### Permissions
Must have `manage_system` permission.

- Tags: custom profile attributes

## Parameters
- `field_id` (path, required, string) - Custom Profile Attribute field GUID

## Request body
- required: True
- description: Custom Profile Attribute field that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Custom Profile Attribute field patch successful
  - `application/json` -> PropertyField
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `422`: Validation error. Returned when a `name` change does not match the required identifier pattern, is a CEL reserved word, or when `attrs.display_name` exceeds 255 characters.

  - `application/json` -> AppError
