# Recap

Original OpenAPI schema: `Recap`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - Unique identifier for the recap
- `user_id`: string
  - ID of the user who created the recap
- `title`: string
  - AI-generated title for the recap (max 5 words)
- `create_at`: integer
  - The time in milliseconds the recap was created
- `update_at`: integer
  - The time in milliseconds the recap was last updated
- `delete_at`: integer
  - The time in milliseconds the recap was deleted
- `read_at`: integer
  - The time in milliseconds the recap was marked as read
- `viewed_at`: integer
  - The time in milliseconds the recap was marked as viewed (set in bulk when the recaps page is opened)
- `total_message_count`: integer
  - Total number of messages summarized across all channels
- `status`: string
  - Current status of the recap job
- `bot_id`: string
  - ID of the AI agent/bot used to generate this recap
- `channels`: array
  - List of channel summaries included in this recap

## Example JSON

```json
{"id": ""string"", "user_id": ""string"", "title": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "read_at": 0, "viewed_at": 0, "total_message_count": 0, "status": ""string"", "bot_id": ""string"", "channels": []}
```
