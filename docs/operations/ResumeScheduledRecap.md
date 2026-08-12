# Resume a scheduled recap

Original OpenAPI operationId: `ResumeScheduledRecap`
- Method: `POST`
- Path: `/api/v4/scheduled_recaps/{scheduled_recap_id}/resume`
- Summary: Resume a scheduled recap
- Description: Resume a previously paused scheduled recap, allowing it to run on its configured schedule again. Only the user who owns the scheduled recap can resume it.
##### Permissions
Must be authenticated. Must own the scheduled recap.
__Minimum server version__: 11.2

- Tags: scheduled recaps, ai

## Parameters
- `scheduled_recap_id` (path, required, string) - Scheduled Recap GUID

## Request body
No request body.

## Responses
- `200`: Scheduled recap resumed successfully
  - `application/json` -> ScheduledRecap
- `401`: No description available.
- `403`: No description available.
- `404`: No description available.
- `501`: No description available.
