# Removes members from a custom group

Original OpenAPI operationId: `DeleteGroupMembers`
- Method: `DELETE`
- Path: `/api/v4/groups/{group_id}/members`
- Summary: Removes members from a custom group
- Description: Soft deletes a custom group members.

##### Permissions
Must have `custom_group_manage_members` permission for the given group.

__Minimum server version__: 6.3

- Tags: groups

## Parameters
- `group_id` (path, required, string) - The ID of the group to delete.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Successfully deleted the group members.
  - `application/json` -> array of GroupMember
- `403`: No description available.
- `404`: Can't find the group.
- `501`: If the group does not have a `source` value of `custom`.
