# Update channel's privacy

Original OpenAPI operationId: `UpdateChannelPrivacy`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/privacy`
- Summary: Update channel's privacy
- Description: Updates channel's privacy allowing changing a channel from Public to Private and back.

__Minimum server version__: 5.16

##### Permissions
`manage_team` permission for the channels team on version < 5.28. `convert_public_channel_to_private` permission for the channel if updating privacy to 'P' on version >= 5.28. `convert_private_channel_to_public` permission for the channel if updating privacy to 'O' on version >= 5.28.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Channel conversion successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
