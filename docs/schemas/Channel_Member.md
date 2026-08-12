# Channel Member

Original OpenAPI schema: `ChannelMember`

No description available in the official OpenAPI schema.

## Fields

- `channel_id`: string
- `user_id`: string
- `roles`: string
- `last_viewed_at`: integer
  - The time in milliseconds the channel was last viewed by the user
- `msg_count`: integer
- `mention_count`: integer
- `notify_props`: ChannelNotifyProps
- `last_update_at`: integer
  - The time in milliseconds the channel member was last updated

## Example JSON

```json
{"channel_id": ""string"", "user_id": ""string"", "roles": ""string"", "last_viewed_at": 0, "msg_count": 0, "mention_count": 0, "notify_props": "ChannelNotifyProps", "last_update_at": 0}
```

