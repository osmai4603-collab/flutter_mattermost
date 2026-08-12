# Delete a scheduled recap

Original OpenAPI operationId: `DeleteScheduledRecap`
- Method: `DELETE`
- Path: `/api/v4/scheduled_recaps/{scheduled_recap_id}`
- Summary: Delete a scheduled recap
- Description: Delete a scheduled recap by its ID. Only the user who owns the scheduled recap can delete it.
##### Permissions
Must be authenticated. Must own the scheduled recap.
__Minimum server version__: 11.2

- Tags: scheduled recaps, ai

## Parameters
- `scheduled_recap_id` (path, required, string) - Scheduled Recap GUID

## Request body
No request body.

## Responses
- `200`: Scheduled recap deleted successfully
  - `application/json` -> StatusOK
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
