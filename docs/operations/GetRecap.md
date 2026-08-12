# Get a specific recap

Original OpenAPI operationId: `GetRecap`
- Method: `GET`
- Path: `/api/v4/recaps/{recap_id}`
- Summary: Get a specific recap
- Description: Get a recap by its ID, including all channel summaries. Only the authenticated user who created the recap can retrieve it.
##### Permissions
Must be authenticated. Can only retrieve recaps created by the current user.
__Minimum server version__: 11.2

- Tags: recaps, ai

## Parameters
- `recap_id` (path, required, string) - Recap GUID

## Request body
No request body.

## Responses
- `200`: Recap retrieval successful
  - `application/json` -> Recap
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
