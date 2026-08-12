# Team members minus group members.

Original OpenAPI operationId: `TeamMembersMinusGroupMembers`
- Method: `GET`
- Path: `/api/v4/teams/{team_id}/members_minus_group_members`
- Summary: Team members minus group members.
- Description: Get the set of users who are members of the team minus the set of users who are members of the given groups.
Each user object contains an array of group objects representing the group memberships for that user.
Each user object contains the boolean fields `scheme_guest`, `scheme_user`, and `scheme_admin` representing the roles that user has for the given team.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 5.14

- Tags: teams

## Parameters
- `team_id` (path, required, string) - Team GUID
- `group_ids` (query, required, string) - A comma-separated list of group ids.
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of users per page.

## Request body
No request body.

## Responses
- `200`: Successfully returns users specified by the pagination, and the total_count.
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
