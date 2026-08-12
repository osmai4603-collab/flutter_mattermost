# View

Original OpenAPI schema: `View`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique identifier of the view
- `channel_id`: string
  - The ID of the channel this view belongs to
- `type`: string
- `creator_id`: string
  - The ID of the user who created this view
- `title`: string
  - The title of the view
- `description`: string
  - The description of the view
- `sort_order`: integer
  - The display order of the view within the channel
- `props`: object
  - Arbitrary key-value properties for the view
- `create_at`: integer
  - The time in milliseconds the view was created
- `update_at`: integer
  - The time in milliseconds the view was last updated
- `delete_at`: integer
  - The time in milliseconds the view was deleted

## Example JSON

```json
{"id": ""string"", "channel_id": ""string"", "type": ""string"", "creator_id": ""string"", "title": ""string"", "description": ""string"", "sort_order": 0, "props": {}, "create_at": 0, "update_at": 0, "delete_at": 0}
```

