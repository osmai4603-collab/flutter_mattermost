# Convert group message to private channel

Original OpenAPI operationId: `ConvertGroupMessageToChannel`
- Method: `POST`
- Path: `/api/v4/channels/{channel_id}/convert_to_channel`
- Summary: Convert group message to private channel
- Description: Converts a group message channel into a private channel in the specified team.
##### Permissions
Must have `create_private_channel` permission in the destination team.

- Tags: channels, group message

## Parameters
- `channel_id` (path, required, string) - Group message channel ID

## Request body
- required: True
- content:
  - `application/json` -> object

## Responses
- `200`: Conversion successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
