# Upload plugin

Original OpenAPI operationId: `UploadPlugin`
- Method: `POST`
- Path: `/api/v4/plugins`
- Summary: Upload plugin
- Description: Upload a plugin that is contained within a compressed .tar.gz file. Plugins and plugin uploads must be enabled in the server's config settings.

##### Permissions
Must have `manage_system` permission.

__Minimum server version__: 4.4

- Tags: plugins

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `201`: Plugin upload successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
- `501`: No description available.
