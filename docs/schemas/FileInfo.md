# FileInfo

Original OpenAPI schema: `FileInfo`

No description available in the official OpenAPI schema.

## Fields

- `id`: string
  - The unique identifier for this file
- `user_id`: string
  - The ID of the user that uploaded this file
- `post_id`: string
  - If this file is attached to a post, the ID of that post
- `create_at`: integer
  - The time in milliseconds a file was created
- `update_at`: integer
  - The time in milliseconds a file was last updated
- `delete_at`: integer
  - The time in milliseconds a file was deleted
- `name`: string
  - The name of the file
- `extension`: string
  - The extension at the end of the file name
- `size`: integer
  - The size of the file in bytes
- `mime_type`: string
  - The MIME type of the file
- `width`: integer
  - If this file is an image, the width of the file
- `height`: integer
  - If this file is an image, the height of the file
- `has_preview_image`: boolean
  - If this file is an image, whether or not it has a preview-sized version

## Example JSON

```json
{"id": ""string"", "user_id": ""string"", "post_id": ""string"", "create_at": 0, "update_at": 0, "delete_at": 0, "name": ""string"", "extension": ""string"", "size": 0, "mime_type": ""string"", "width": 0, "height": 0, "has_preview_image": False}
```

