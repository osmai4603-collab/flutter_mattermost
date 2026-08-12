# Update a channel

Original OpenAPI operationId: `UpdateChannel`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}`
- Summary: Update a channel
- Description: Update a channel. The fields that can be updated are listed as parameters. Omitted fields will be treated as blanks.
##### Permissions
If updating a public channel, `manage_public_channel_members` permission is required. If updating a private channel, `manage_private_channel_members` permission is required.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
- required: True
- description: Channel object to be updated
- content:
  - `application/json` -> object

## Responses
- `200`: Channel update successful
  - `application/json` -> Channel
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
