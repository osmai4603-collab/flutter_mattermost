# Delete a Custom Profile Attribute field

Original OpenAPI operationId: `DeleteCPAField`
- Method: `DELETE`
- Path: `/api/v4/custom_profile_attributes/fields/{field_id}`
- Summary: Delete a Custom Profile Attribute field
- Description: Marks a Custom Profile Attribute field and all its values as
deleted.

__Minimum server version__: 10.5

##### Permissions
Must have `manage_system` permission.

- Tags: custom profile attributes

## Parameters
- `field_id` (path, required, string) - Custom Profile Attribute field GUID

## Request body
No request body.

## Responses
- `200`: Custom Profile Attribute field deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
