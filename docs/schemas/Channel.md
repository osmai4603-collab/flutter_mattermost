# Channel

Original OpenAPI schema: `Channel`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
- `create_at`: integer
  - The time in milliseconds a channel was created
- `update_at`: integer
  - The time in milliseconds a channel was last updated
- `delete_at`: integer
  - The time in milliseconds a channel was deleted
- `team_id`: string
- `type`: string
- `display_name`: string
- `name`: string
- `header`: string
- `purpose`: string
- `last_post_at`: integer
  - The time in milliseconds of the last post of a channel
- `total_msg_count`: integer
- `extra_update_at`: integer
  - Deprecated in Mattermost 5.0 release
- `creator_id`: string

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "team_id": ""string"", "type": ""string"", "display_name": ""string"", "name": ""string"", "header": ""string"", "purpose": ""string"", "last_post_at": 0, "total_msg_count": 0, "extra_update_at": 0, "creator_id": ""string""}
```

