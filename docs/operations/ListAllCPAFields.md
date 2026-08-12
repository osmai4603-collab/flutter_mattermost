# List all the Custom Profile Attributes fields

Original OpenAPI operationId: `ListAllCPAFields`
- Method: `GET`
- Path: `/api/v4/custom_profile_attributes/fields`
- Summary: List all the Custom Profile Attributes fields
- Description: List all the Custom Profile Attributes fields.

__Minimum server version__: 10.5

##### Permissions
Must be authenticated.

- Tags: custom profile attributes

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Custom Profile Attributes fetch successful. Result may be empty.
  - `application/json` -> array of PropertyField
- `401`: No description available.
