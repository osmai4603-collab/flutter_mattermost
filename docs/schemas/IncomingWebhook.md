# IncomingWebhook

Original OpenAPI schema: `IncomingWebhook`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique identifier for this incoming webhook
- `create_at`: integer
  - The time in milliseconds a incoming webhook was created
- `update_at`: integer
  - The time in milliseconds a incoming webhook was last updated
- `delete_at`: integer
  - The time in milliseconds a incoming webhook was deleted
- `last_used`: integer
  - The time in milliseconds this incoming webhook was last used to post a message
- `channel_id`: string
  - The ID of a public channel or private group that receives the webhook payloads
- `description`: string
  - The description for this incoming webhook
- `display_name`: string
  - The display name for this incoming webhook

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "last_used": 0, "channel_id": ""string"", "description": ""string"", "display_name": ""string""}
```

