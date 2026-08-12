# Get users

Original OpenAPI operationId: `GetUsers`
- Method: `GET`
- Path: `/api/v4/users`
- Summary: Get users
- Description: Get a page of a list of users. Based on query string parameters, select users from a team, channel, or select users not in a specific channel.
Since server version 4.0, some basic sorting is available using the `sort` query parameter. Sorting is currently only supported when selecting users on a team.
Some fields, like `email_verified` and `notify_props`, are only visible for the authorized user or if the authorized user has the `manage_system` permission.
##### Permissions
Requires an active session and (if specified) membership to the channel or team being selected from.

- Tags: users

## Parameters
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of users per page.
- `in_team` (query, optional, string) - The ID of the team to get users for.
- `not_in_team` (query, optional, string) - The ID of the team to exclude users for. Must not be used with "in_team" query parameter.
- `in_channel` (query, optional, string) - The ID of the channel to get users for.
- `not_in_channel` (query, optional, string) - The ID of the channel to exclude users for. Must be used with "in_channel" query parameter.
- `in_group` (query, optional, string) - The ID of the group to get users for. Must have `manage_system` permission.
- `group_constrained` (query, optional, boolean) - When used with `not_in_channel` or `not_in_team`, returns only the users that are allowed to join the channel or team based on its group constrains.
- `abac_match_only` (query, optional, boolean) - When used with `not_in_channel`, restricts the result to users whose attributes satisfy the channel's Attribute-Based Access Control (ABAC) membership policy.

On private channels with an ABAC policy this filter is always applied regardless of this parameter (hard gate). On public channels with an advisory ABAC policy the full not_in_channel candidate list is returned by default; set this to `true` to fetch only the matching subset of candidates (for example to annotate recommended members in the invite UI).

__Minimum server version__: 11.8

- `without_team` (query, optional, boolean) - Whether or not to list users that are not on any team. This option takes precendence over `in_team`, `in_channel`, and `not_in_channel`.
- `active` (query, optional, boolean) - Whether or not to list only users that are active. This option cannot be used along with the `inactive` option.
- `inactive` (query, optional, boolean) - Whether or not to list only users that are deactivated. This option cannot be used along with the `active` option.
- `role` (query, optional, string) - Returns users that have this role.
- `sort` (query, optional, string) - Sort is only available in conjunction with certain options below. The paging parameter is also always available.

##### `in_team`
Can be "", "last_activity_at" or "create_at".
When left blank, sorting is done by username.
Note that when "last_activity_at" is specified, an additional "last_activity_at" field will be returned in the response packet.
__Minimum server version__: 4.0
##### `in_channel`
Can be "", "status".
When left blank, sorting is done by username. `status` will sort by User's current status (Online, Away, DND, Offline), then by Username.
__Minimum server version__: 4.7
##### `in_group`
Can be "", "display_name".
When left blank, sorting is done by username. `display_name` will sort alphabetically by user's display name.
__Minimum server version__: 7.7

- `roles` (query, optional, string) - Comma separated string used to filter users based on any of the specified system roles

Example: `?roles=system_admin,system_user` will return users that are either system admins or system users

__Minimum server version__: 5.26

- `channel_roles` (query, optional, string) - Comma separated string used to filter users based on any of the specified channel roles, can only be used in conjunction with `in_channel`

Example: `?in_channel=4eb6axxw7fg3je5iyasnfudc5y&channel_roles=channel_user` will return users that are only channel users and not admins or guests

__Minimum server version__: 5.26

- `team_roles` (query, optional, string) - Comma separated string used to filter users based on any of the specified team roles, can only be used in conjunction with `in_team`

Example: `?in_team=4eb6axxw7fg3je5iyasnfudc5y&team_roles=team_user` will return users that are only team users and not admins or guests

__Minimum server version__: 5.26


## Request body
No request body.

## Responses
- `200`: User page retrieval successful
  - `application/json` -> array of User
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
