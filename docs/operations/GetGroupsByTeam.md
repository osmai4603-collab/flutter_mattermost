# Get team groups

Original OpenAPI operationId: `GetGroupsByTeam`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/groups`
- Summary: Get team groups
- Description: Retrieve the list of groups associated with a given team.

##### Permissions
Must have the `list_team_channels` permission.

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `team_id` (path, required, string) - Team GUID
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of groups per page.
- `filter_allow_reference` (query, optional, boolean) - Boolean which filters in the group entries with the `allow_reference` attribute set.
- `include_member_count` (query, optional, boolean) - Boolean which adds a `member_count` field to each group object.
- `include_timezones` (query, optional, boolean) - Boolean which adds timezone information for group members.
- `include_total_count` (query, optional, boolean) - Boolean which adds total count of groups in the response.
- `include_archived` (query, optional, boolean) - Boolean which includes archived groups in the response.
- `filter_archived` (query, optional, boolean) - Boolean which filters out archived groups from the response.
- `filter_parent_team_permitted` (query, optional, boolean) - Boolean which filters groups based on parent team permissions.
- `filter_has_member` (query, optional, string) - User ID to filter groups that have this member.
- `include_member_ids` (query, optional, boolean) - Boolean which adds member IDs to the group objects.
- `only_syncable_sources` (query, optional, boolean) - Boolean which includes groups from syncable sources.

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
