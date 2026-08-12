# OutcomingWebhook

Original OpenAPI schema: `OutgoingWebhook`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique identifier for this outgoing webhook
- `create_at`: integer
  - The time in milliseconds a outgoing webhook was created
- `update_at`: integer
  - The time in milliseconds a outgoing webhook was last updated
- `delete_at`: integer
  - The time in milliseconds a outgoing webhook was deleted
- `creator_id`: string
  - The Id of the user who created the webhook
- `team_id`: string
  - The ID of the team that the webhook watchs
- `channel_id`: string
  - The ID of a public channel that the webhook watchs
- `description`: string
  - The description for this outgoing webhook
- `display_name`: string
  - The display name for this outgoing webhook
- `trigger_words`: array
  - List of words for the webhook to trigger on
- `trigger_when`: integer
  - When to trigger the webhook, `0` when a trigger word is present at all and `1` if the message starts with a trigger word
- `callback_urls`: array
  - The URLs to POST the payloads to when the webhook is triggered
- `content_type`: string
  - The format to POST the data in, either `application/json` or `application/x-www-form-urlencoded`

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "creator_id": ""string"", "team_id": ""string"", "channel_id": ""string"", "description": ""string"", "display_name": ""string"", "trigger_words": [], "trigger_when": 0, "callback_urls": [], "content_type": ""string""}
```

