# Create a custom group

Original OpenAPI operationId: `CreateGroup`
- Method: `POST`
- Path: `/api/v4/groups`
- Summary: Create a custom group
- Description: Create a `custom` type group.

#### Permission
Must have `create_custom_group` permission.

__Minimum server version__: 6.3

- Tags: groups

## Parameters
No parameters.

## Request body
- required: True
- description: Group object and initial members.
- content:
  - `application/json` -> object

## Responses
- `201`: Group creation and memberships successful.
- `400`: No description available.
- `403`: No description available.
- `501`: Group has an invalid `source`, or
`allow_reference` is not `true`, or
group has a `remote_id`.

