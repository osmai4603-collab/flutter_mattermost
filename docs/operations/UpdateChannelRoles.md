# Update channel roles

Original OpenAPI operationId: `UpdateChannelRoles`
- Method: `PUT`
- Path: `/api/v4/channels/{channel_id}/members/{user_id}/roles`
- Summary: Update channel roles
- Description: Update a user's roles for a channel.
##### Permissions
Must have `manage_channel_roles` permission for the channel.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID
- `user_id` (path, required, string) - User GUID

## Request body
- required: True
- description: Space-delimited channel roles to assign to the user
- content:
  - `application/json` -> object

## Responses
- `200`: Channel roles update successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
