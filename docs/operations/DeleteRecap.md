# Delete a recap

Original OpenAPI operationId: `DeleteRecap`
- Method: `DELETE`
- Path: `/api/v4/recaps/{recap_id}`
- Summary: Delete a recap
- Description: Delete a recap by its ID. Only the authenticated user who created the recap can delete it.
##### Permissions
Must be authenticated. Can only delete recaps created by the current user.
__Minimum server version__: 11.2

- Tags: recaps, ai

## Parameters
- `recap_id` (path, required, string) - Recap GUID

## Request body
No request body.

## Responses
- `200`: Recap deletion successful
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
