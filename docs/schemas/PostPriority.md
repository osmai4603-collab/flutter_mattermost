# PostPriority

Original OpenAPI schema: `PostPriority`

Priority metadata associated with a post or draft.

## Fields

- `priority`: string
  - The priority label of a post, either empty, important, or urgent.
- `requested_ack`: boolean
  - Whether the post author has requested acknowledgements.
- `persistent_notifications`: boolean
  - Whether persistent notifications are enabled for the post.

## Example JSON

```json
{"priority": ""string"", "requested_ack": False, "persistent_notifications": False}
```

