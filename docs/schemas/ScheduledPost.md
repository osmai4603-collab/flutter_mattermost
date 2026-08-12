# ScheduledPost

Original OpenAPI schema: `ScheduledPost`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
- `create_at`: integer
  - The time in milliseconds a scheduled post was created
- `update_at`: integer
  - The time in milliseconds a scheduled post was last updated
- `user_id`: string
- `channel_id`: string
- `root_id`: string
- `message`: string
- `props`: object
- `file_ids`: array
- `scheduled_at`: integer
  - The time in milliseconds a scheduled post is scheduled to be sent at
- `processed_at`: integer
  - The time in milliseconds a scheduled post was processed at
- `error_code`: string
  - Explains the error behind why a scheduled post could not have been sent
- `metadata`: PostMetadata

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "user_id": ""string"", "channel_id": ""string"", "root_id": ""string"", "message": ""string"", "props": {}, "file_ids": [], "scheduled_at": 0, "processed_at": 0, "error_code": ""string"", "metadata": "PostMetadata"}
```
