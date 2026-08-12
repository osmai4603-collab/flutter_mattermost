# Get timezones in a channel

Original OpenAPI operationId: `GetChannelMembersTimezones`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/timezones`
- Summary: Get timezones in a channel
- Description: Get a list of timezones for the users who are in this channel.

__Minimum server version__: 5.6

##### Permissions
Must have the `read_channel` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Timezone retrieval successful
  - `application/json` -> array of string
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
