# Upload brand image

Original OpenAPI operationId: `UploadBrandImage`
- Method: `POST`
- Path: `/api/v4/brand/image`
- Summary: Upload brand image
- Description: Uploads a brand image.
##### Permissions
Must have `manage_system` permission.

- Tags: brand

## Parameters
No parameters.

## Request body
- required: False
- content:
  - `multipart/form-data` -> object

## Responses
- `201`: Brand image upload successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `413`: No description available.
- `501`: No description available.
