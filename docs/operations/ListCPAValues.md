# List Custom Profile Attribute values

Original OpenAPI operationId: `ListCPAValues`
- Method: `GET`
- Path: `/api/v4/users/{user_id}/custom_profile_attributes`
- Summary: List Custom Profile Attribute values
- Description: List all the Custom Profile Attributes values for specified user.

__Minimum server version__: 10.5

##### Permissions
Must have `view members` permission.

- Tags: custom profile attributes

## Parameters
- `user_id` (path, required, string) - User GUID

## Request body
No request body.

## Responses
- `200`: Custom Profile Attribute values fetch successful. Result may be empty.
  - `application/json` -> <no schema>
  - `schema` -> <no schema>
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
