# ChannelBookmark

Original OpenAPI schema: `ChannelBookmark`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
- `create_at`: integer
  - The time in milliseconds a channel bookmark was created
- `update_at`: integer
  - The time in milliseconds a channel bookmark was last updated
- `delete_at`: integer
  - The time in milliseconds a channel bookmark was deleted
- `channel_id`: string
- `owner_id`: string
  - The ID of the user that the channel bookmark belongs to
- `file_id`: string
  - The ID of the file associated with the channel bookmark
- `display_name`: string
- `sort_order`: integer
  - The order of the channel bookmark
- `link_url`: string
  - The URL associated with the channel bookmark
- `image_url`: string
  - The URL of the image associated with the channel bookmark
- `emoji`: string
- `type`: string
- `target_id`: string
  - Mattermost 26-character ID of a referenced Mattermost entity when the bookmark includes one.
- `original_id`: string
  - The ID of the original channel bookmark
- `parent_id`: string
  - The ID of the parent channel bookmark

## Example JSON

```json
{"id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "channel_id": ""string"", "owner_id": ""string"", "file_id": ""string"", "display_name": ""string"", "sort_order": 0, "link_url": ""string"", "image_url": ""string"", "emoji": ""string"", "type": ""string"", "target_id": ""string"", "original_id": ""string"", "parent_id": ""string""}
```

