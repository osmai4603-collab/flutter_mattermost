# Delete a link for LDAP group

Original OpenAPI operationId: `UnlinkLdapGroup`
- Method: `DELETE`
- Path: `/api/v4/ldap/groups/{remote_id}/link`
- Summary: Delete a link for LDAP group
- Description: ##### Permissions
Must have `manage_system` permission.
__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `remote_id` (path, required, string) - Group GUID

## Request body
No request body.

## Responses
- `200`: Successfully deleted ldap group link
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
