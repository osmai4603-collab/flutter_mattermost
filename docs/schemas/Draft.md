# Draft

Original OpenAPI schema: `Draft`

No description available in the official OpenAPI schema.

## Fields

- `create_at`: integer
- `update_at`: integer
- `delete_at`: integer
  - Deprecated. Drafts are hard-deleted.
- `user_id`: string
- `channel_id`: string
- `root_id`: string
- `message`: string
- `type`: string
- `props`: object
- `file_ids`: array
- `metadata`: PostMetadata
- `priority`: PostPriority

## Example JSON

```json
{"create_at": 0, "update_at": 0, "delete_at": 0, "user_id": ""string"", "channel_id": ""string"", "root_id": ""string"", "message": ""string"", "type": ""string"", "props": {}, "file_ids": [], "metadata": "PostMetadata", "priority": "PostPriority"}
```

