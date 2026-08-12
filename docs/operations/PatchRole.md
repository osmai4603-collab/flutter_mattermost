# Patch a role

Original OpenAPI operationId: `PatchRole`
- Method: `PUT`
- Path: `/api/v4/roles/{role_id}/patch`
- Summary: Patch a role
- Description: Partially update a role by providing only the fields you want to update. Omitted fields will not be updated. The fields that can be updated are defined in the request body, all other provided fields will be ignored.

##### Permissions
Must have `sysconsole_write_user_management_permissions` or `manage_system` permission. When updating the role of a system admin, the `manage_system` permission is mandatory.

__Minimum server version__: 4.9

- Tags: roles

## Parameters
- `role_id` (path, required, string) - Role GUID

## Request body
- required: True
- description: Role object to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Role patch successful
  - `application/json` -> Role
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
