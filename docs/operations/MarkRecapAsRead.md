# Mark a recap as read

Original OpenAPI operationId: `MarkRecapAsRead`
- Method: `POST`
- Path: `/api/v4/recaps/{recap_id}/read`
- Summary: Mark a recap as read
- Description: Mark a recap as read by the authenticated user. This updates the recap's read status and timestamp.
##### Permissions
Must be authenticated. Can only mark recaps created by the current user as read.
__Minimum server version__: 11.2

- Tags: recaps, ai

## Parameters
- `recap_id` (path, required, string) - Recap GUID

## Request body
No request body.

## Responses
- `200`: Recap marked as read successfully
  - `application/json` -> Recap
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
