# Restore a previously deleted group.

Original OpenAPI operationId: `RestoreGroup`
- Method: `POST`
- Path: `/api/v4/groups/{group_id}/restore`
- Summary: Restore a previously deleted group.
- Description: Restores a previously deleted custom group, allowing it to be used normally.
May not be used with LDAP groups.
##### Permissions Must have `restore_custom_group` permission for the given group.
__Minimum server version__: 7.7

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID

## Request body
No request body.

## Responses
- `200`: Group restored successfully
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
