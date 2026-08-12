# Patch Custom Profile Attribute values

Original OpenAPI operationId: `PatchCPAValues`
- Method: `PATCH`
- Path: `/api/v4/custom_profile_attributes/values`
- Summary: Patch Custom Profile Attribute values
- Description: Partially update a set of values on the requester's Custom
Profile Attribute fields by providing only the information you
want to update. Omitted fields will not be updated. The fields
that can be updated are defined in the request body, all other
provided fields will be ignored.

**Note:** Values for fields with `attrs.protected = true` cannot be
updated and will return an error.

__Minimum server version__: 10.5

##### Permissions
Must be authenticated.

- Tags: custom profile attributes

## Parameters
No parameters.

## Request body
- required: True
- description: Custom Profile Attribute values that are to be updated
- content:
  - `application/json` -> array of object

## Responses
- `200`: Custom Profile Attribute values patch successful
  - `application/json` -> array of object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
