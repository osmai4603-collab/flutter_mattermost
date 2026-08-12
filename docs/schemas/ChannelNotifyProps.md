# ChannelNotifyProps

Original OpenAPI schema: `ChannelNotifyProps`

No description available in the official OpenAPI schema.

## Fields

- `email`: string
  - Set to "true" to enable email notifications, "false" to disable, or "default" to use the global user notification setting.
- `push`: string
  - Set to "all" to receive push notifications for all activity, "mention" for mentions and direct messages only, "none" to disable, or "default" to use the global user notification setting.
- `desktop`: string
  - Set to "all" to receive desktop notifications for all activity, "mention" for mentions and direct messages only, "none" to disable, or "default" to use the global user notification setting.
- `mark_unread`: string
  - Set to "all" to mark the channel unread for any new message, "mention" to mark unread for new mentions only. Defaults to "all".

## Example JSON

```json
{"email": ""string"", "push": ""string"", "desktop": ""string"", "mark_unread": ""string""}
```
