# Get total count of users in the system matching the specified filters

Original OpenAPI operationId: `GetTotalUsersStatsFiltered`
- Method: `GET`
- Path: `/api/v4/users/stats/filtered`
- Summary: Get total count of users in the system matching the specified filters
- Description: Get a count of users in the system matching the specified filters.

__Minimum server version__: 5.26

##### Permissions
Must have `manage_system` permission.

- Tags: users

## Parameters
- `in_team` (query, optional, string) - The ID of the team to get user stats for.
- `in_channel` (query, optional, string) - The ID of the channel to get user stats for.
- `include_deleted` (query, optional, boolean) - If deleted accounts should be included in the count.
- `include_bots` (query, optional, boolean) - If bot accounts should be included in the count.
- `roles` (query, optional, string) - Comma separated string used to filter users based on any of the specified system roles

Example: `?roles=system_admin,system_user` will include users that are either system admins or system users

- `channel_roles` (query, optional, string) - Comma separated string used to filter users based on any of the specified channel roles, can only be used in conjunction with `in_channel`

Example: `?in_channel=4eb6axxw7fg3je5iyasnfudc5y&channel_roles=channel_user` will include users that are only channel users and not admins or guests

- `team_roles` (query, optional, string) - Comma separated string used to filter users based on any of the specified team roles, can only be used in conjunction with `in_team`

Example: `?in_team=4eb6axxw7fg3je5iyasnfudc5y&team_roles=team_user` will include users that are only team users and not admins or guests


## Request body
No request body.

## Responses
- `200`: Filtered User stats retrieval successful
  - `application/json` -> UsersStats
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
