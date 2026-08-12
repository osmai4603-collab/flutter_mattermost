# Get channel groups

Original OpenAPI operationId: `GetGroupsByChannel`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/groups`
- Summary: Get channel groups
- Description: Retrieve the list of groups associated with a given channel.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of groups per page.
- `filter_allow_reference` (query, optional, boolean) - Boolean which filters the group entries with the `allow_reference` attribute set.

## Request body
No request body.

## Responses
- `200`: Group list retrieval successful
  - `application/json` -> array of Group
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
