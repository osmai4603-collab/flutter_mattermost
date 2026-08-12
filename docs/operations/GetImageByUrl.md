# Get an image by url

Original OpenAPI operationId: `GetImageByUrl`
- Method: `GET`
- Path: `/api/v4/image`
- Summary: Get an image by url
- Description: Fetches an image via Mattermost image proxy.
__Minimum server version__: 3.10
##### Permissions
Must be logged in.

- Tags: system

## Parameters
No parameters.

## Request body
No request body.

## Responses
- `200`: Image found
  - `image/*` -> string
- `404`: No description available.
