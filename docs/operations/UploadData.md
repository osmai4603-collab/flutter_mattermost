# Perform a file upload

Original OpenAPI operationId: `UploadData`
- Method: `POST`
- Path: `/api/v4/uploads/{upload_id}`
- Summary: Perform a file upload
- Description: Starts or resumes a file upload.  
To resume an existing (incomplete) upload, data should be sent starting from the offset specified in the upload session object.

The request body can be in one of two formats:
- Binary file content streamed in request's body
- multipart/form-data

##### Permissions
Must be logged in as the user who created the upload session.

- Tags: uploads

## Parameters
- `upload_id` (path, required, string) - The ID of the upload session the data belongs to.

## Request body
- required: False
- content:
  - `application/octet-stream` -> string
  - `multipart/form-data` -> object

## Responses
- `201`: Upload successful
  - `application/json` -> FileInfo
- `204`: Upload incomplete
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
- `501`: No description available.
