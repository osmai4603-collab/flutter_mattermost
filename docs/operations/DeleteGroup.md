# Deletes a custom group

Original OpenAPI operationId: `DeleteGroup`
- Method: `DELETE`
- Path: `/api/v4/groups/{group_id}`
- Summary: Deletes a custom group
- Description: Soft deletes a custom group.

##### Permissions
Must have `custom_group_delete` permission for the given group.

__Minimum server version__: 6.3

- Tags: groups

## Parameters
- `group_id` (path, required, string) - The ID of the group.

## Request body
No request body.

## Responses
- `200`: Successfully deleted the group.
  - `application/json` -> StatusOK
- `403`: No description available.
- `404`: Group is already deleted or doesn't exist.
- `501`: The group doesn't have a `source` value of `custom`.
