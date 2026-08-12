# Delete current brand image

Original OpenAPI operationId: `DeleteBrandImage`
- Method: `DELETE`
- Path: `/api/v4/brand/image`
- Summary: Delete current brand image
- Description: Deletes the previously uploaded brand image. Returns 404 if no brand image has been uploaded.
##### Permissions
Must have `manage_system` permission.
__Minimum server version: 5.6__

- Tags: brand

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Brand image succesfully deleted
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
