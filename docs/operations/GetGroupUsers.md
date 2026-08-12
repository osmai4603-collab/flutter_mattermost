# Get group users

Original OpenAPI operationId: `GetGroupUsers`
- Method: `GET`
- Path: `/api/v4/groups/{group_id}/members`
- Summary: Get group users
- Description: Retrieve the list of users associated with a given group.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `group_id` (path, required, string) - Group GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of groups per page.

## Request body
No request body.

## Responses
- `200`: User list retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
