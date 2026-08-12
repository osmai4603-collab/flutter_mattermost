# Channel members counts for each group that has atleast one member in the channel

Original OpenAPI operationId: `GetChannelMemberCountsByGroup`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/member_counts_by_group`
- Summary: Channel members counts for each group that has atleast one member in the channel
- Description: Returns a set of ChannelMemberCountByGroup objects which contain a `group_id`, `channel_member_count` and a `channel_member_timezones_count`.
##### Permissions
Must have `read_channel` permission for the given channel.
__Minimum server version__: 5.24

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `include_timezones` (query, optional, boolean) - Defines if member timezone counts should be returned or not

## Request body
No request body.

## Responses
- `200`: Successfully returns member counts by group for the given channel.
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
