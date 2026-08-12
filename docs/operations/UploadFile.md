# Upload a file

Original OpenAPI operationId: `UploadFile`
- Method: `POST`
- Path: `/api/v4/files`
- Summary: Upload a file
- Description: Uploads a file that can later be attached to a post.

This request can either be a multipart/form-data request with a channel_id, files and optional
client_ids defined in the FormData, or it can be a request with the channel_id and filename
defined as query parameters with the contents of a single file in the body of the request.

Only multipart/form-data requests are supported by server versions up to and including 4.7.
Server versions 4.8 and higher support both types of requests.

__Minimum server version__: 9.4
Starting with server version 9.4 when uploading a file for a channel bookmark, the bookmark=true query parameter should be included in the query string

##### Permissions
Must have `upload_file` permission.

- Tags: files

## Parameters
- `channel_id` (query, optional, string) - The ID of the channel that this file will be uploaded to
- `filename` (query, optional, string) - The name of the file to be uploaded

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `201`: Corresponding lists of the provided client_ids and the metadata that has been stored in the database for each one
  - `application/json` -> object
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
- `501`: No description available.
