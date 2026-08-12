# Link a LDAP group

Original OpenAPI operationId: `LinkLdapGroup`
- Method: `POST`
- Path: `/api/v4/ldap/groups/{remote_id}/link`
- Summary: Link a LDAP group
- Description: ##### Permissions
Must have `manage_system` permission.
__Minimum server version__: 5.11

- Tags: LDAP

## Parameters
- `remote_id` (path, required, string) - Group GUID

## Request body
No request body.

## Responses
- `201`: LDAP group successfully linked
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
