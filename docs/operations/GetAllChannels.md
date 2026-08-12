# Get a list of all channels

Original OpenAPI operationId: `GetAllChannels`
- Method: `GET`
- Path: `/api/v4/channels`
- Summary: Get a list of all channels
- Description: ##### Permissions
`manage_system`

- Tags: channels

## Parameters
- `not_associated_to_group` (query, optional, string) - A group id to exclude channels that are associated with that group via GroupChannel records. This can also be left blank with `not_associated_to_group=`.
- `page` (query, optional, integer) - The page to select.
- `per_page` (query, optional, integer) - The number of channels per page.
- `exclude_default_channels` (query, optional, boolean) - Whether to exclude default channels (ex Town Square, Off-Topic) from the results.
- `include_deleted` (query, optional, boolean) - Include channels that have been archived. This correlates to the `DeleteAt` flag being set in the database.
- `include_total_count` (query, optional, boolean) - Appends a total count of returned channels inside the response object - ex: `{ "channels": [], "total_count" : 0 }`.
- `exclude_policy_constrained` (query, optional, boolean) - If set to true, channels which are part of a data retention policy will be excluded. The `sysconsole_read_compliance` permission is required to use this parameter.
__Minimum server version__: 5.35

## Request body
No request body.

## Responses
- `200`: Channel list retrieval successful
  - `application/json` -> ChannelListWithTeamData
- `400`: No description available.
- `401`: No description available.
- `404`: No description available.
