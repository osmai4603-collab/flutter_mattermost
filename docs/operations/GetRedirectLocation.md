# Get redirect location

Original OpenAPI operationId: `GetRedirectLocation`
- Method: `GET`
- Path: `/api/v4/redirect_location`
- Summary: Get redirect location
- Description: __Minimum server version__: 3.10
##### Permissions
Must be logged in.

- Tags: system

## Parameters
- `url` (query, required, string) - Url to check

## Request body
No request body.

## Responses
- `200`: Got redirect location
  - `image/*` -> object
- `404`: No description available.
