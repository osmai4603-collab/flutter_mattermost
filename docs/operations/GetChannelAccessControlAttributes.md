# Get access control attributes for a channel

Original OpenAPI operationId: `GetChannelAccessControlAttributes`
- Method: `GET`
- Path: `/api/v4/channels/{channel_id}/access_control/attributes`
- Summary: Get access control attributes for a channel
- Description: Retrieves the effective access control policy attributes for a specific channel.
This can be used to understand what attributes are currently being applied to the channel by the access control system.
##### Permissions
Must have `read_channel` permission for the specified channel.

- Tags: access control, channels

## Parameters
- `channel_id` (path, required, string) - The ID of the channel.

## Request body
No request body.

## Responses
- `200`: Access control attributes retrieved successfully.
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `500`: No description available.
