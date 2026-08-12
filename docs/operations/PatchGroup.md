# Patch a group

Original OpenAPI operationId: `PatchGroup`
- Method: `PUT`
- Path: `/api/v4/groups/{group_id}/patch`
- Summary: Patch a group
- Description: Partially update a group by providing only the fields you want to update. Omitted fields will not be updated. The fields that can be updated are defined in the request body, all other provided fields will be ignored.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID

## Request body
- required: True
- description: Group object that is to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Group patch successful
  - `application/json` -> Group
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
