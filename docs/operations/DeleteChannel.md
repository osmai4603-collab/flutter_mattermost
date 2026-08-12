# Delete a channel

Original OpenAPI operationId: `DeleteChannel`
- Method: `DELETE`
- Path: `/api/v4/channels/{channel_id}`
- Summary: Delete a channel
- Description: Archives a channel. This will set the `deleteAt` to the current timestamp in the database. Soft deleted channels may not be accessible in the user interface. They can be viewed and unarchived in the **System Console > User Management > Channels** based on your license. Direct and group message channels cannot be deleted.

As of server version 5.28, optionally use the `permanent=true` query parameter to permanently delete the channel for compliance reasons. To use this feature `ServiceSettings.EnableAPIChannelDeletion` must be set to `true` in the server's configuration. If you permanently delete a channel this action is not recoverable outside of a database backup.

##### Permissions
`delete_public_channel` permission if the channel is public,
`delete_private_channel` permission if the channel is private,
or have `manage_system` permission.

- Tags: channels

## Parameters
- `channel_id` (path, required, string) - Channel GUID

## Request body
No request body.

## Responses
- `200`: Channel deletion successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
