# Post

Original OpenAPI schema: `Post`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
- `create_at`: integer
  - The time in milliseconds a post was created
- `update_at`: integer
  - The time in milliseconds a post was last updated
- `delete_at`: integer
  - The time in milliseconds a post was deleted
- `edit_at`: integer
- `user_id`: string
- `channel_id`: string
- `root_id`: string
- `original_id`: string
- `message`: string
- `type`: string
- `props`: object
- `hashtag`: string
- `file_ids`: array
- `pending_post_id`: string
- `metadata`: PostMetadata

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "edit_at": 0, "user_id": ""string"", "channel_id": ""string"", "root_id": ""string"", "original_id": ""string"", "message": ""string"", "type": ""string"", "props": {}, "hashtag": ""string"", "file_ids": [], "pending_post_id": ""string"", "metadata": "PostMetadata"}
```

