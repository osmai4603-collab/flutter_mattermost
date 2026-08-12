# Get a public file link

Original OpenAPI operationId: `GetFileLink`
- Method: `GET`
- Path: `/api/v4/files/{file_id}/link`
- Summary: Get a public file link
- Description: Gets a public link for a file that can be accessed without logging into Mattermost.
##### Permissions
Must have `read_channel` permission or be uploader of the file.

- Tags: files

## Parameters
- `file_id` (path, required, string) - The ID of the file to get a link for

## Request body
No request body.

## Responses
- `200`: A publicly accessible link to the given file
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: Do not have appropriate permissions
  - `application/json` -> AppError
- `404`: No description available.
- `501`: No description available.
