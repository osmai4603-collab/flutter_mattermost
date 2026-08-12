# Get brand image

Original OpenAPI operationId: `GetBrandImage`
- Method: `GET`
- Path: `/api/v4/brand/image`
- Summary: Get brand image
- Description: Get the previously uploaded brand image. Returns 404 if no brand image has been uploaded.
##### Permissions
No permission required.

- Tags: brand

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Brand image retrieval successful
  - `application/json` -> string
- `404`: No description available.
- `501`: No description available.
