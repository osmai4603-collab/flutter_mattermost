# DraftUpsertRequest

Original OpenAPI schema: `DraftUpsertRequest`

No description available in the official OpenAPI schema.

## Fields

- `channel_id`: string (required)
- `root_id`: string
- `message`: string (required)
  - Draft message. Set to an empty string to delete the draft.
- `type`: string
- `props`: object
- `file_ids`: array
- `priority`: PostPriority

## Example JSON

```json
{"channel_id": ""string"", "root_id": ""string"", "message": ""string"", "type": ""string"", "props": {}, "file_ids": [], "priority": "PostPriority"}
```

