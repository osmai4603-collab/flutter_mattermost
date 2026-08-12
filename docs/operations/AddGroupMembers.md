# Adds members to a custom group

Original OpenAPI operationId: `AddGroupMembers`
- Method: `POST`
- Path: `/api/v4/groups/{group_id}/members`
- Summary: Adds members to a custom group
- Description: Adds members to a custom group.

##### Permissions
Must have `custom_group_manage_members` permission for the given group.

__Minimum server version__: 6.3

- Tags: groups

## Parameters
- `group_id` (path, required, string) - The ID of the group.

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Successfully added the group members.
  - `application/json` -> array of GroupMember
- `403`: No description available.
- `404`: Can't find the group.
- `501`: If the group does not have a `source` value of `custom`.
