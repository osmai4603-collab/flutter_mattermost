# ChannelUnreadAt

Original OpenAPI schema: `ChannelUnreadAt`

No description available in the official OpenAPI schema.

## Fields

- `team_id`: string
  - The ID of the team the channel belongs to.
- `channel_id`: string
  - The ID of the channel the user has access to..
- `msg_count`: integer
  - No. of messages the user has already read.
- `mention_count`: integer
  - No. of mentions the user has within the unread posts of the channel.
- `last_viewed_at`: integer
  - time in milliseconds when the user last viewed the channel.

## Example JSON

```json
{"team_id": ""string"", "channel_id": ""string"", "msg_count": 0, "mention_count": 0, "last_viewed_at": 0}
```

