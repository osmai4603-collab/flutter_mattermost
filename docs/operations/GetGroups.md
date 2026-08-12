# Get groups

Original OpenAPI operationId: `GetGroups`
- Method: `GET`
- Path: `/api/v4/groups`
- Summary: Get groups
- Description: Retrieve a list of all groups not associated to a particular channel or team.

If you use `not_associated_to_team`, you must be a team admin for that particular team (permission to manage that team).

If you use `not_associated_to_channel`, you must be a channel admin for that particular channel (permission to manage that channel).

__Minimum server version__: 5.11

- Tags: groups

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of groups per page.
- `q` (query, optional, string) - String to pattern match the `name` and `display_name` field. Will return all groups whose `name` and `display_name` field match any of the text.
- `include_member_count` (query, optional, boolean) - Boolean which adds the `member_count` attribute to each group JSON object
- `not_associated_to_team` (query, optional, string) - Team GUID which is used to return all the groups not associated to this team
- `not_associated_to_channel` (query, optional, string) - Group GUID which is used to return all the groups not associated to this channel
- `since` (query, optional, integer) - Only return groups that have been modified since the given Unix timestamp (in milliseconds). All modified groups, including deleted and created groups, will be returned.
__Minimum server version__: 5.24

- `filter_allow_reference` (query, optional, boolean) - Boolean which filters the group entries with the `allow_reference` attribute set.

## Request body
No request body.

## Responses
- `200`: Group list retrieval successful
  - `application/json` -> array of Group
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `501`: No description available.
