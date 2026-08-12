# Pause a scheduled recap

Original OpenAPI operationId: `PauseScheduledRecap`
- Method: `POST`
- Path: `/api/v4/scheduled_recaps/{scheduled_recap_id}/pause`
- Summary: Pause a scheduled recap
- Description: Pause a scheduled recap, preventing it from running until resumed. Only the user who owns the scheduled recap can pause it.
##### Permissions
Must be authenticated. Must own the scheduled recap.
__Minimum server version__: 11.2

- Tags: scheduled recaps, ai

## Parameters
- `scheduled_recap_id` (path, required, string) - Scheduled Recap GUID

## Request body
No request body.

## Responses
- `200`: Scheduled recap paused successfully
  - `application/json` -> ScheduledRecap
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
