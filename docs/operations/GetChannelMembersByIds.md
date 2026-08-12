# Get channel members by ids

Original OpenAPI operationId: `GetChannelMembersByIds`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/members/ids`
- Summary: Get channel members by ids
- Description: Get a list of channel members based on the provided user ids.
##### Permissions
Must have the `read_channel` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- description: List of user ids.
- content:
  - `application/json` -> array of string

## Responses
- `200`: Channel member list retrieval successful
  - `application/json` -> array of ChannelMember
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
