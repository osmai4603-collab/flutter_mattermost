# Perform a post action

Original OpenAPI operationId: `DoPostAction`
- Method: `POST`
- Path: `/api/v4/posts/{post_id}/actions/{action_id}`
- Summary: Perform a post action
- Description: Perform a post action, which allows users to interact with integrations through posts.
##### Permissions
Must be authenticated and have the `read_channel` permission to the channel the post is in.

- Tags: posts

## Parameters
- `post_id` (path, required, string) - Post GUID
- `action_id` (path, required, string) - Action GUID

## Request body
No request body.

## Responses
- `200`: Post action successful
  - `application/json` -> StatusOK
- `400`: No description available.
- `401`: No description available.
- `403`: No description available.
- `429`: The upstream integration rate-limited the request. The original status code is preserved so clients can honor retry semantics.
  - `application/json` -> AppError
- `502`: The upstream integration returned a 5xx (other than 503). Surfaced as Bad Gateway because the failure is upstream of Mattermost.
  - `application/json` -> AppError
- `503`: The upstream integration is unavailable. The original status code is preserved so clients can honor retry semantics.
  - `application/json` -> AppError
