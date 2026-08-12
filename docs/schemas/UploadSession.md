# UploadSession

Original OpenAPI schema: `UploadSession`

an object containing information used to keep track of a file upload.

## Fields

- `id`: string
  - The unique identifier for the upload.
- `type`: string
  - The type of the upload.
- `create_at`: integer
  - The time the upload was created in milliseconds.
- `user_id`: string
  - The ID of the user performing the upload.
- `channel_id`: string
  - The ID of the channel to upload to.
- `filename`: string
  - The name of the file to upload.
- `file_size`: integer
  - The size of the file to upload in bytes.
- `file_offset`: integer
  - The amount of data uploaded in bytes.

## Example JSON

```json
{"id": ""string"", "type": ""string"", "create_at": 0, "user_id": ""string"", "channel_id": ""string"", "filename": ""string"", "file_size": 0, "file_offset": 0}
```
