# Get team groups by channels

Original OpenAPI operationId: `GetGroupsAssociatedToChannelsByTeam`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/groups_by_channels`
- Summary: Get team groups by channels
- Description: Retrieve the set of groups associated with the channels in the given team grouped by channel.

##### Permissions
Must have the `list_team_channels` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `team_id` (path, required, string) - Team GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of groups per page.
- `filter_allow_reference` (query, optional, boolean) - Boolean which filters in the group entries with the `allow_reference` attribute set.
- `paginate` (query, optional, boolean) - Boolean to determine whether the pagination should be applied or not

## Request body
No request body.

## Responses
- `200`: Group list retrieval successful
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `500`: No description available.
- `501`: No description available.
