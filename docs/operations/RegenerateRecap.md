# Regenerate a recap

Original OpenAPI operationId: `RegenerateRecap`
- Method: `POST`
- Path: `/api/v4/recaps/{recap_id}/regenerate`
- Summary: Regenerate a recap
- Description: Regenerate a recap by its ID. This creates a new background job to regenerate the AI-powered recap with the latest messages from the specified channels.
##### Permissions
Must be authenticated. Can only regenerate recaps created by the current user.
__Minimum server version__: 11.2

- Tags: recaps, ai

## Parameters
- `recap_id` (path, required, string) - Recap GUID

## Request body
No request body.

## Responses
- `200`: Recap regeneration initiated successfully
  - `application/json` -> Recap
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
