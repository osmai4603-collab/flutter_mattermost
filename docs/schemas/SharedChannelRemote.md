# SharedChannelRemote

Original OpenAPI schema: `SharedChannelRemote`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The id of the shared channel remote
- `channel_id`: string
  - The id of the channel
- `creator_id`: string
  - Id of the user that invited the remote to share the channel
- `create_at`: integer
  - Time in milliseconds that the remote was invited to the channel
- `update_at`: integer
  - Time in milliseconds that the shared channel remote record was last updated
- `delete_at`: integer
  - Time in milliseconds that the shared chanenl remote record was deleted
- `is_invite_accepted`: boolean
  - Indicates if the invite has been accepted by the remote
- `is_invite_confirmed`: boolean
  - Indicates if the invite has been confirmed by the remote
- `remote_id`: string
  - Id of the remote cluster that the channel is shared with
- `last_post_update_at`: integer
  - Time in milliseconds of the last post in the channel that was synchronized with the remote update_at
- `last_post_id`: string
  - Id of the last post in the channel that was synchronized with the remote
- `last_post_create_at`: string
  - Time in milliseconds of the last post in the channel that was synchronized with the remote create_at
- `last_post_create_id`: string

## Example JSON

```json
{"id": ""string"", "channel_id": ""string"", "creator_id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "is_invite_accepted": False, "is_invite_confirmed": False, "remote_id": ""string"", "last_post_update_at": 0, "last_post_id": ""string"", "last_post_create_at": ""string"", "last_post_create_id": ""string""}
```
